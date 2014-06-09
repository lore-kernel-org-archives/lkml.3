Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890AbaFIWgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:36:23 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:41920 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184AbaFIWgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:36:19 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8MBb+7f1bOnJjJWj1vxa0UNuQwz7OGRDR_QFTxOT=9cynabQ@mail.gmail.com>
References: <1397859600-11507-1-git-send-email-robherring2@gmail.com>
	<1397859600-11507-4-git-send-email-robherring2@gmail.com>
	<CAE9FiQVrwypK4u5yTCt-AxMuBnOn7jv=V3d4Zb3cd9JDNEUVPw@mail.gmail.com>
	<CAL_JsqKux+BTHeYo6XEzzQMAFJZHVjbURM973oHT=t698GbJbA@mail.gmail.com>
	<20140503220731.GA10927@kroah.com>
	<20140503221658.GA13403@kroah.com>
	<CA+8MBb+7f1bOnJjJWj1vxa0UNuQwz7OGRDR_QFTxOT=9cynabQ@mail.gmail.com>
Date: Mon, 9 Jun 2014 17:36:18 -0500
Message-ID: <CAL_JsqLa0HiwrbJPPf4dD7HFewVXP8ENuA=eHsX77WBk8pHdkw@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] tty/serial: convert 8250 to generic earlycon
From: Rob Herring <robherring2@gmail.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>, Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2014 at 5:25 PM, Tony Luck <tony.luck@gmail.com> wrote:
> On Sat, May 3, 2014 at 3:16 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>> > >>  drivers/tty/serial/8250/8250_early.c | 138 ++++-------------------------------
>>> > >>  drivers/tty/serial/8250/Kconfig      |   1 +
>>> > >>  2 files changed, 16 insertions(+), 123 deletions(-)
>>> > >
>>> > > Hi Greg, Rob
>>> > >
>>> > > This one in tty-next breaks booting: "console=uart8250,io,0x3f8,115200".
>>> > > No early console and regular console anymore.
>>> > >
>>> > > It should produce "early con and regular con".
>>> >
>>> > This is what I get for running checkpatch and converting
>>> > simple_strtoul to kstrto* which are not so equivalent. kstrto* will
>>> > not convert things such as 115200n8 to a number.
>>> >
>>> > Greg, Do you want a fix or for me to respin the series? The fix looks like this:
>>>
>>> As this is in my tree now (right?), I need a fix to apply to it.
>>
>> Nevermind, you already sent it...
>
> Linus' tree (HEAD=963649d735c8) is spitting out all sorts of garbage
> on the serial console - as if the baud rate is being periodically set
> to something weird, and then back to 112500.  I see over a dozen
> blocks of junk interspersed with good output.

Is there any correlation of the garbage to printks of console enabled messages?

>
> This in on ia64 with "console=uart,io,0x3f8" on the command line.

Does "console=ttyS0,115200" or "console=uart,io,0x3f8,115200" work?

You will need this fix for the 2nd one to work:

commit e26f1db9b8d74617519e50b41749900d0a257406
Author: Rob Herring <robh@kernel.org>
Date:   Wed Apr 30 19:48:29 2014 -0500

    tty/serial: fix generic earlycon option parsing

Rob

>
> git bisect pointed me here:
>
> d2fd6810a823bcde1ee232668f5689837aafa772 is first bad commit
> commit d2fd6810a823bcde1ee232668f5689837aafa772
> Author: Rob Herring <robh@kernel.org>
> Date:   Fri Apr 18 17:19:56 2014 -0500
>
>     tty/serial: convert 8250 to generic earlycon
>
> -Tony

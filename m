Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbaFJWiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 18:38:25 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:49821 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbaFJWiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 18:38:23 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8MBbLooWm9xys+gYa5uL1eVTH-qzaR+RaZgsrqV-8XkqGadQ@mail.gmail.com>
References: <1397859600-11507-1-git-send-email-robherring2@gmail.com>
	<1397859600-11507-4-git-send-email-robherring2@gmail.com>
	<CAE9FiQVrwypK4u5yTCt-AxMuBnOn7jv=V3d4Zb3cd9JDNEUVPw@mail.gmail.com>
	<CAL_JsqKux+BTHeYo6XEzzQMAFJZHVjbURM973oHT=t698GbJbA@mail.gmail.com>
	<20140503220731.GA10927@kroah.com>
	<20140503221658.GA13403@kroah.com>
	<CA+8MBb+7f1bOnJjJWj1vxa0UNuQwz7OGRDR_QFTxOT=9cynabQ@mail.gmail.com>
	<CA+8MBbKE1E2uq9LefiDAV9hv2Z8OTkjx9mkXjE6_--F_emRC8A@mail.gmail.com>
	<CAL_JsqKvoO9acX==-LdD6boO=B3xr=ijra_G0uqRZGzACZZUJg@mail.gmail.com>
	<CA+8MBbLooWm9xys+gYa5uL1eVTH-qzaR+RaZgsrqV-8XkqGadQ@mail.gmail.com>
Date: Tue, 10 Jun 2014 17:38:22 -0500
Message-ID: <CAL_JsqLccXqcsQXoc1ZLcuqUAQMNHW_iApdNpd1ptnNS+1ut0A@mail.gmail.com>
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

On Tue, Jun 10, 2014 at 3:52 PM, Tony Luck <tony.luck@gmail.com> wrote:
> On Mon, Jun 9, 2014 at 4:18 PM, Rob Herring <robherring2@gmail.com> wrote:
>> It should do auto detect of the baud-rate if it is not specified which
>> for 8250 is just reading the baud-rate divider and calculating the
>> baud-rate using the uart clock. It should just reprogram the divider
>> with the same divider value. I don't see anything obvious why this
>> would have broken.
>
> Something very weird is happening.  Output is good so long as I put the
> trailing ",115200" on the command line.
>
> But I made early_serial8250_setup() printk() the return value it got
> from probe_baud() - in case is was somehow getting 115201 or some
> other silly value ... nope. Exactly 115200.
>
> I also can't explain why the "noise" comes and goes a dozen
> times during boot,
>
> Does some other place in the kernel look at the "uart..." command
> line argument?

Would you be using drivers/firmware/pcdp.c as that is ia64 only? That
shouldn't have an impact that I can see.

Can you print the options string in serial8250_console_setup? Maybe it
is getting lost when the real console is setup.

Rob

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab3FRFyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 01:54:24 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:50352 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab3FRFyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 01:54:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130618030709.GJ20795@xanatos>
References: <1370452543-19014-1-git-send-email-yhchen@faraday-tech.com>
	<20130617203948.GA32731@kroah.com>
	<CADB-GoK7Ntv0yM8hWLE7nrdiLq-fZymyHihGuu-78j4qiDCszA@mail.gmail.com>
	<20130618030709.GJ20795@xanatos>
Date: Tue, 18 Jun 2013 13:54:22 +0800
Message-ID: <CADB-GoKACJnearpDL+kxxsW6ez=2cbP0UDgbZNL+uNN0bswDog@mail.gmail.com>
Subject: Re: [PATCH] usb: host: Faraday fotg210-hcd driver
From: Yuan-Hsin Chen <yuanlmm@gmail.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        florian@openwrt.org, USB list <linux-usb@vger.kernel.org>,
        linux-kernel@vger.kernel.org, ratbert <ratbert.chuang@gmail.com>,
        =?UTF-8?B?Sm9obiBGZW5nLUhzaW4gQ2hpYW5nKOaxn+WzsOiIiCk=?= 
	<john453@faraday-tech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 18, 2013 at 11:07 AM, Sarah Sharp
<sarah.a.sharp@linux.intel.com> wrote:
> On Tue, Jun 18, 2013 at 10:42:09AM +0800, Yuan-Hsin Chen wrote:
>> Hi,
>>
>> On Tue, Jun 18, 2013 at 4:39 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Wed, Jun 05, 2013 at 05:15:43PM +0000, Yuan-Hsin Chen wrote:
>> >> FOTG210 is an OTG controller which can be configured as an
>> >> USB2.0 host. FOTG210 host is an ehci-like controller with
>> >> some differences. First, register layout of FOTG210 is
>> >> incompatible with EHCI. Furthermore, FOTG210 is lack of
>> >> siTDs which means iTDs are used for both HS and FS ISO
>> >> transfer.
>> >>
>> >> Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>
>> >> ---
>> >>  drivers/usb/Makefile           |    1 +
>> >>  drivers/usb/host/Kconfig       |   12 +
>> >>  drivers/usb/host/Makefile      |    1 +
>> >>  drivers/usb/host/fotg210-hcd.c | 5967 ++++++++++++++++++++++++++++++++++++++++
>> >>  drivers/usb/host/fotg210.h     |  746 +++++
>> >>  5 files changed, 6727 insertions(+), 0 deletions(-)
>> >>  create mode 100644 drivers/usb/host/fotg210-hcd.c
>> >>  create mode 100644 drivers/usb/host/fotg210.h
>> >
>> > You obviously didn't even run this through checkpatch.pl, did you?
>> >
>> > $ ./scripts/checkpatch.pl --terse ../usb.mbox | tail -n 1
>> > total: 138 errors, 618 warnings, 6742 lines checked
>> >
>> > Please fix all of these if you wish us to at least start reviewing the
>> > patch.  Your internal Q/A should have caught this first, please be more
>> > careful in the future.
>> >
>>
>> Actually I did run checkpatch.pl and found that almost all errors and
>> warnings are from ehci core (ehci-hcd.c, ehci-hub.c and so on) where
>> my driver borrowed most of code.
>>
>> $ ./scripts/checkpatch.pl --terse -f drivers/usb/host/ehci-hub.c | tail -n 1
>> total: 18 errors, 69 warnings, 1138 lines checked
>>
>> $ ./scripts/checkpatch.pl --terse -f drivers/usb/host/ehci-hcd.c | tail -n 1
>> total: 17 errors, 78 warnings, 1403 lines checked
>>
>> So you're saying that I should fix them, is that right?
>
> In that case, no, you should be figuring out how to refactor and reuse
> the EHCI code instead of copying it straight into your driver.

I was trying to use ehci-platform.c, anonymous union/struct, and quirk
flags to avoid copying EHCI code.
But there are too big incompatibilities between fotg210/fusbh200
controller and EHCI.
That's why Alan agreed that I could create a stand-alone driver for
fusbh200 host controller.
Since fotg210 and fusbh200 have the same issue,  fotg210 hcd is
supposed to be stand-alone.
More details please refer to mail sequence
http://www.spinics.net/lists/linux-usb/msg83812.html

Thanks,

Yuan-Hsin

>
> Sarah Sharp

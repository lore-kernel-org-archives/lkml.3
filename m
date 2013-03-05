Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab3CELgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 06:36:22 -0500
Received: from canardo.mork.no ([148.122.252.1]:59103 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab3CELgU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 06:36:20 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Oliver Neukum <oneukum@suse.de>
Cc: Josua Dietze <digidietze@draisberghof.de>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Ben Hutchings <ben@decadent.org.uk>,
        "linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fangxiaozhi \(Franko\)" <fangxiaozhi@huawei.com>, zihan@huawei.com,
        Lin.Lei@huawei.com, Greg KH <gregkh@linuxfoundation.org>,
        "Yili \(Neil\)" <neil.yi@huawei.com>,
        "Wangyuhua \(Roger\, Credit\)" <wangyuhua@huawei.com>,
        Huqiao <huqiao36@huawei.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: storage: fix Huawei mode switching regression
Organization: m
References: <87obezs888.fsf@nemi.mork.no> <87wqtnq8bb.fsf@nemi.mork.no>
	<5135201F.4030200@draisberghof.de>
	<4661149.JOvxeICSJy@linux-5eaq.site>
Date: Tue, 05 Mar 2013 12:35:07 +0100
In-Reply-To: <4661149.JOvxeICSJy@linux-5eaq.site> (Oliver Neukum's message of
	"Tue, 05 Mar 2013 09:32:32 +0100")
Message-ID: <87txoqoz9w.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum <oneukum@suse.de> writes:
> On Monday 04 March 2013 23:28:47 Josua Dietze wrote:
>> > I guess the real problem will be verifying that all of the entries can
>> > go away. This type of hardware tends to get old very fast, but there is
>> > always someone having a really ancient device.
>> 
>> I will check this and add any missing USB IDs to usb_modeswitch, but I can't shake the feeling that not all Huawei entries in "unusual_devs.h" did actually materialize as devices ...
>> 
>> Anyway, as Bjørn said, putting that initialization into the storage
>> driver takes away quite some possibilities to handle these modems in
>> a flexible way.
>
> But it adds the ability to handle loss of power in the suspend case
> cleanly.

How is that different?  If the device loses power, then it will appear
as a new unswitched USB storage device, and go through the switching
sequence again. And if the device does not lose power but the system
does, then it will appear as a new, already switched, USB modem device.

The system behaviour will be exactly the same AFAICS, providing the
switching command is the same.

> As long as the switch only makes additional devices appear,
> doing it in kernel space is the nicer approach.

You cannot guarantee this.  Huawei may not support it, but there are
instructions around the net on how to change this.

And how do you want this to play together with complex devices having
multiple configurations, where one of those is mode switching and the
other is not?  Yes, there are Huawei devices like that.

The firmware implement a wide variety of different alternative
configurations. Some users take advantage of that.  Doing the mode
switching in the kernel removes all but one of these alternatives.  The
fact that the one Windows uses is among those removed is IMHO bad,
regardless of whether Huawei support that mode on Linux.


Bjørn

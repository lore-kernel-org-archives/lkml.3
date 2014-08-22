Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaHVXmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 19:42:21 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:44432 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbaHVXmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 19:42:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140822214244.GA25922@kroah.com>
References: <1408708399-20423-1-git-send-email-sojka@merica.cz>
 <CAK5ve-LaGPgsAVMMMw3=EWpjom5NF29btu0Yxjg=6iwPpioQFg@mail.gmail.com> <20140822214244.GA25922@kroah.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Fri, 22 Aug 2014 16:41:58 -0700
Message-ID: <CAK5ve-J263nk0O378-GF9g600MMTkp2nxoDEkp4nKMxNpRwQ4g@mail.gmail.com>
Subject: Re: [PATCH 1/2] leds: usb: Add LED trigger for USB gadget activity
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Sojka <sojka@merica.cz>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        michal.vokac@comap.cz, Richard Purdie <rpurdie@rpsys.net>,
        Felipe Balbi <balbi@ti.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 2:42 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Aug 22, 2014 at 10:39:03AM -0700, Bryan Wu wrote:
>> On Fri, Aug 22, 2014 at 4:53 AM, Michal Sojka <sojka@merica.cz> wrote:
>> > With this patch, USB gadget activity can be signaled by blinking a LED.
>> >
>> > Since there is no generic code where to put the trigger for all USB
>> > controllers, each USB controller needs to call the trigger individually.
>> > This patch adds the call only for the musb controller where I can test
>> > it.
>> >
>>
>> Generally I think one led trigger for both USB host and USB gadget
>> activity is good enough. We don't need 2 same led trigger here.
>
> What about systems that have both running at the same time?  Don't you
> want individual control?
>

Actually I wanted to say we don't need 2 same driver for USB host and
USB gadget but one driver which has 2 led triggers like
usb_host_ledtrig and usb_gadget_ledtrig.

I think drivers/net/can/led.c is a good example to start.

>> And probably you can just put this code in drivers/usb subsystem,
>> since this driver is quite simple to add to USB subsystem.
>
> I have no objection to that, if the LED people don't mind it.
>

Because logically it's only used by USB subsystem and it can be a core
component of USB, also drivers/net/can/led.c is a good example.

Thanks,
-Bryan

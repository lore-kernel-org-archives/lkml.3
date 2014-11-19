Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbaKSAom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 19:44:42 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:49822 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbaKSAok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 19:44:40 -0500
MIME-Version: 1.0
In-Reply-To: <20141118211734.GA19146@saruman>
References: <1415953486-6000-1-git-send-email-george.cherian@ti.com>
	<20141118211734.GA19146@saruman>
Date: Tue, 18 Nov 2014 18:44:39 -0600
Message-ID: <CADYTM3b9zSpP2yO2Lp5WOxBxB0yX=bG_20mFKQNGnyXV0XLOHg@mail.gmail.com>
Subject: Re: [PATCH] usb: musb: core: Disable the Interrupts till BABBLE is
 fully handled
From: Bin Liu <binmlist@gmail.com>
To: balbi@ti.com
Cc: George Cherian <george.cherian@ti.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        bigeasy@linutronix.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe,

On Tue, Nov 18, 2014 at 3:17 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Fri, Nov 14, 2014 at 01:54:46PM +0530, George Cherian wrote:
>> Disable the MUSB interrupts till MUSB is recovered fully from BABBLE
>> condition. There are chances that we could get multiple interrupts
>> till the time the babble recover work gets scheduled. Sometimes
>> this could even end up in an endless loop making MUSB itself unusable.
>>
>> Reported-by: Felipe Balbi <balbi@ti.com>
>> Signed-off-by: George Cherian <george.cherian@ti.com>
>
> while this helps the situation it doesn't solve the problem I'm having
> with testusb on BBB when host port is connected to peripheral port on
> the same BBB.

Try to find a BB white (which has rev 1.0 SoC) to see if babble still
happens, this could be PHY hw issue.

Regards,
-Bin.


>
> I still have:
>
> # ./testusb -t 13 -c 10 -s 2048 -a
> unknown speed   /dev/bus/usb/002/004    0
> [  114.811407] usbtest 2-1:3.0: set altsetting to 0 failed, -71
> /dev/bus/usb/002/004 test 13 --> 71 (error 71)
> [  114.862387] CAUTION: musb: Babble Interrupt Occurred
> [  114.868132] usb 2-1: USB disconnect, device number 4
> [  114.961491] musb-hdrc musb-hdrc.1.auto: Restarting MUSB to recover from Babble
> [  115.430829] usb 2-1: new high-speed USB device number 5 using musb-hdrc
> [  115.573471] zero gadget: high-speed config #3: source/sink
> [  115.584014] usbtest 2-1:3.0: Linux gadget zero
> [  115.588682] usbtest 2-1:3.0: high-speed {control in/out bulk-in bulk-out} tests (+alt)
>
> I think the driver is mis-detecting Babble. A babble only occurs when
> the device side tries to move data without the host asking for anything.
>
> --
> balbi

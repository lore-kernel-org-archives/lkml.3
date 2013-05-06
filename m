Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab3EFODO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 10:03:14 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:52869 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab3EFODN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 10:03:13 -0400
Message-ID: <5187B813.8000907@ahsoftware.de>
Date: Mon, 06 May 2013 16:02:59 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: rtc-linux@googlegroups.com, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: adjusting the monotonic system time (from inside the kernel)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm looking at how to adjust the (monotonic) system time from inside the 
kernel.

Use case is that I have a hw-clock which (not necessarily) regulary 
sends a timestamp with millisecond precision which I want to use to 
adjust the system time.

It seems the usual solution to do such, is to use NTP which uses it's 
own driver (which usually seems to be based on some serial connection):

hw-clock --serial--> kernel --serial-device--> ntpd -> kernel -> system-time

So one solution would be to emulate such a serial device:

hw-clock --> kernel --emulated-serial-device--> ntpd -> kernel -> 
system-time

Another solution would be to "invent" a ntp-device and write a driver 
for ntpd to use it:

hw-clock --> kernel --ntp-device--> ntpd -> kernel -> system-time

But I would prefer the following:

hw-clock --> kernel -> system-time

Problem is that the hw-clock in question doesn't offer something like a 
tick. It just might send a timestamp with millisecond precision whenever 
it wants.

Because I don't want to reinvent the wheel and because I think there are 
some people which already have spend some thoughts on similiar things, 
I'm asking here before I try to implement something which then never 
might find it's way into the mainline kernel.

Any hints, suggestions, whatever?

Regards,

Alexander Holler

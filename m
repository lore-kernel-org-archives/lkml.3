Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab3FGXt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:49:26 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:60657 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab3FGXtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:49:25 -0400
Message-ID: <51B27182.8010506@linaro.org>
Date: Fri, 07 Jun 2013 16:49:22 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: adjusting the monotonic system time (from inside the kernel)
References: <5187B813.8000907@ahsoftware.de>
In-Reply-To: <5187B813.8000907@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 07:02 AM, Alexander Holler wrote:
> Hello,
>
> I'm looking at how to adjust the (monotonic) system time from inside 
> the kernel.
>
> Use case is that I have a hw-clock which (not necessarily) regulary 
> sends a timestamp with millisecond precision which I want to use to 
> adjust the system time.
>
> It seems the usual solution to do such, is to use NTP which uses it's 
> own driver (which usually seems to be based on some serial connection):
>
> hw-clock --serial--> kernel --serial-device--> ntpd -> kernel -> 
> system-time
>
> So one solution would be to emulate such a serial device:
>
> hw-clock --> kernel --emulated-serial-device--> ntpd -> kernel -> 
> system-time
>
> Another solution would be to "invent" a ntp-device and write a driver 
> for ntpd to use it:
>
> hw-clock --> kernel --ntp-device--> ntpd -> kernel -> system-time
>
> But I would prefer the following:
>
> hw-clock --> kernel -> system-time
>
> Problem is that the hw-clock in question doesn't offer something like 
> a tick. It just might send a timestamp with millisecond precision 
> whenever it wants.
>
> Because I don't want to reinvent the wheel and because I think there 
> are some people which already have spend some thoughts on similiar 
> things, I'm asking here before I try to implement something which then 
> never might find it's way into the mainline kernel.
>
> Any hints, suggestions, whatever?

Sorry on the delay to reply here, just noticed this in my spam folder 
(hopefully I've trained it not to catch your mails now).

You probably want to check out do_adjtimex() in the kernel. It has a 
number of ways that allow for the clock to be slewed or jumped. 
Otherwise you probably should look into the PPS subsystems to see if it 
could be extended to support your needs.

thanks
-john



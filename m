Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaF1Uui (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 16:50:38 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:38795 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaF1Uug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 16:50:36 -0400
Message-ID: <53AF2A83.8040003@ahsoftware.de>
Date: Sat, 28 Jun 2014 22:50:11 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marc Dietrich <marvin24@gmx.de>
CC: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Whitmore <arigead@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 0/2][RFC] Try to handle hctosys w/ rtc modules
References: <1403890031-26419-1-git-send-email-john.stultz@linaro.org>	<53AE6C3C.5090308@ahsoftware.de>	<53AE6FA2.7000808@ahsoftware.de> <20140628205433.0ef4a8cf28a7fe4861a733dd@gmx.de>
In-Reply-To: <20140628205433.0ef4a8cf28a7fe4861a733dd@gmx.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 28.06.2014 20:54, schrieb Marc Dietrich:
> On Sat, 28 Jun 2014 09:32:50 +0200
> Alexander Holler <holler@ahsoftware.de> wrote:
>
>> Am 28.06.2014 09:18, schrieb Alexander Holler:
>>> Am 27.06.2014 19:27, schrieb John Stultz:
>>>> Its been pointed out that the RTC hctosys functionality doesn't
>>>> work well with RTC modules, which may not be loaded until after
>>>> late_init().
>>>>
>>>> While there have been other attempts to sovle this, this patchset
>>>> is a very quick 10 minute effort to show how I'd try to resolve
>>>> this. There likely are still issues here, but I'd be happy to
>>>> make fixes and adjustments to ensure it works.
>>
>> How long you needed to getthe idea?
>>
>>>>
>>>> Feedback and comments always appreciated!
>>>
>>> And it still uses the non-deterministic and therefor almost unusable
>>> rtcN. Well done.
>>
>> Besides that the current hctosys-mechanism doesn't really work with
>> hot-plugable devices at all. Guess what N will be when you unplug and
>> plug in such a RTC again.
>
> We have a patch in the kernel which binds the rtc number to the
> hw device, so this even works for hotpluggable devices (at least on
> systems supporting device-tree). Not sure what your needs are.

First, the number depends on the kernel-configuration and the order how 
RTCs are detected and might even change between minor kernel versions. 
Thus it's totally non-deterministic across different kernel builds.

Second, I wonder about which hotpluggable devices you are talking. Last 
time I've dived into that part of the kernel was when I've written my 
fully working patch set and at that time a usb-rtc (the only really 
hotpluggable RTC I currently know about) did get a new N whenever it 
appeared again (e.g. on suspend/resume). So with the proposed 
non-working clone of my patch, the RTC would be gone after a resume.

Anyway, sorry, I won't spend more time on discussing with kernel 
maintainers. I don't receive any compensations to do so and therefor I 
absolutely have no reason to accept all the pain and insults which are 
happening when doing so. I've come to the conclusion that I should not 
have posted patches at all (not just this one) and really regret that.

Alexander Holler

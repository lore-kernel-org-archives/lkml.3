Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbaGASmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:42:51 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:45919 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbaGASmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:42:50 -0400
Message-ID: <53B30118.8060507@ahsoftware.de>
Date: Tue, 01 Jul 2014 20:42:32 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alessandro Zummo <a.zummo@towertech.it>, Marc Dietrich <marvin24@gmx.de>
CC: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Whitmore <arigead@gmail.com>
Subject: Re: [PATCH 0/2][RFC] Try to handle hctosys w/ rtc modules
References: <1403890031-26419-1-git-send-email-john.stultz@linaro.org>	<53AE6C3C.5090308@ahsoftware.de>	<53AE6FA2.7000808@ahsoftware.de>	<20140628205433.0ef4a8cf28a7fe4861a733dd@gmx.de> <20140630213716.36dd4227@linux.lan.towertech.it>
In-Reply-To: <20140630213716.36dd4227@linux.lan.towertech.it>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 30.06.2014 21:37, schrieb Alessandro Zummo:
> On Sat, 28 Jun 2014 20:54:33 +0200
> Marc Dietrich <marvin24@gmx.de> wrote:
>
>>> Besides that the current hctosys-mechanism doesn't really work with
>>> hot-plugable devices at all. Guess what N will be when you unplug and
>>> plug in such a RTC again.
>>
>> We have a patch in the kernel which binds the rtc number to the
>> hw device, so this even works for hotpluggable devices (at least on
>> systems supporting device-tree). Not sure what your needs are.
>
>   I'm still not sure about how to solve this, maybe it would be better to
>   identify the hctosys device that should be used at boot with
>   a different identifier than rtcX (and move the option to the kernel command line)

Just in case some missunderstood me. I didn't talk about the userland 
but the in-kernel stuff. Currently, it uses the N which was defined by 
in the config (or zero) on resume to update the time. If you look at my 
3. patch, you will see I have changed this there to use the driver (by 
name) which was used at boot to set the time.

Fixing userspace would be easy too by just changing /dev/rtcN to 
/dev/rtc_drivername. But I didn't that in my 3 patches in order to not 
confuse maintainers (and userland people) with too much changes or new 
stuff at once (unsucessfully, but ...).

There still would be a problem about how to handle two RTCs which do use 
the same driver, but I think this is fictitious scenario (and broken if 
that should be for backup purposes) and therefor if someone would really 
design such a system, he should solve this problem himself.

Alexander Holler

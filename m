Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab3BVLCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 06:02:37 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:58705 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757019Ab3BVLCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 06:02:35 -0500
Message-ID: <51275047.70401@suse.cz>
Date: Fri, 22 Feb 2013 12:02:31 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: ojab <ojab@ojab.ru>, stable <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [stable-request] [Bisected] Kernel 3.8 hangs on boot
References: <512710F3.9070602@ojab.ru> <51273988.2070907@suse.cz> <5127402A.6040501@ojab.ru> <51274FFD.4050509@suse.cz>
In-Reply-To: <51274FFD.4050509@suse.cz>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 12:01 PM, Jiri Slaby wrote:
> On 02/22/2013 10:53 AM, ojab wrote:
>> On 22.02.2013 13:25, Jiri Slaby wrote:
>>> On 02/22/2013 07:32 AM, ojab wrote:
>>>
>>> Ideally with description of tha hang. Are there any messages (if you
>>> disable splash and enable debug)? Do keyboard LEDs blink?
>>>
>>>
>>> Especially architecture. Then do you have serial ports, some GSM devices
>>> or GPS?
>>
>> It's x86_64 machine and I have GPS w/ PPS (Garmin 18x LVC) connected via
>> serial, without it kernel boots/works fine. Also no issues with GPS
>> connected, but PPS disabled (by removing pps_core.ko module).
>> If I'm connecting GPS w/ PPS to already booted machine — cursor on the
>> display stops blinking and I cannot input anything, but I still can
>> switch between VTs using Ctrl-Fx and keyboard LEDs are blinking when I'm
>> pressing Num/Caps Lock keys.
> 
> Ok, you have a problem fixed by this commit:
> commit 03a7ffe4e542310838bac70ef85acc17536b6d7c
> Author: George Spelvin <linux@horizon.com>
> Date:   Sun Feb 10 04:41:56 2013 -0500
> 
>     pps: Use pps_lookup_dev to reduce ldisc coupling
> 
> I think this should go to stable-3.8 with its prerequisity:
> 
> commit 513b032c98b4b9414aa4e9b4a315cb1bf0380101
> Author: George Spelvin <linux@horizon.com>
> Date:   Sun Feb 10 04:08:32 2013 -0500
> 
>     pps: Add pps_lookup_dev() function
> 
> George?

Sorry for the noise: it *is* marked by "CC: stable" which I missed, so
it will go to stable eventually.

-- 
js
suse labs

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab3CDNZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 08:25:38 -0500
Received: from mx02.infracom.it ([62.196.48.10]:38765 "EHLO mx02.infracom.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757224Ab3CDNZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 08:25:37 -0500
Message-ID: <5134A0C1.3010107@infracom.it>
Date: Mon, 4 Mar 2013 14:25:21 +0100
From: Roberto Oppedisano <roberto.oppedisano@infracom.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: Zhang Rui <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>
Subject: Re: regression in linux 3.7 - fan speed at 100% after suspend/resume
 at 100%
References: <50BDF345.60804@gmail.com> <loom.20130303T010825-770@post.gmane.org> <513493C1.6070206@gmail.com>
In-Reply-To: <513493C1.6070206@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added Cc: list

Il 04/03/2013 13:29, Roberto Oppedisano ha scritto:
> Il 03/03/2013 01:22, Ville Syrjala ha scritto:
>> Roberto Oppedisano <roberto.oppedisano <at> gmail.com> writes:
>>
>>> Hello,
>>>       with recent kernels after a suspend/resume cycle on my laptop (HP
>>> 6730b) the fans stays at full speed.
>> I too have been hit by this regression w/ a HP Compaq NC6000 laptop.
>>
>> >From what I can tell 3.7.x gets confused about trip points after 
>> resume. Based
>> on the information in sysfs, it seems to always think that the CPU 
>> temp > 65C,
>> when in fact it's usually 40C or so. Loading the CPU enough to rise the
>> temperature past the trip point where the kernel thinks we're at 
>> seems to
>> re-synchronize the kernel's reality with the firmware's reality. On a 
>> few
>> occasions however the fan did stop, but the trip points were still 
>> confused the
>> same way. So what happened is that the fan didn't come back to life 
>> until I hit
>> the next higher trip point at 80C. Under normal conditions I've never 
>> reached
>> the 80C trip point on this laptop.
>>
>> I also tried this tree:
>> git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git next
>> $ git describe
>> v3.8-rc2-72-gf5b6d45
>>
>> Sadly I must report that it's even worse than 3.7. Even without any
>> suspend/resume cycles, the system gets confused. When I heat up the 
>> CPU the fan
>> comes on correctly and speeds up as the temperature rises. 
>> Unfortunately when
>> the temperature drops the fan doesn't slow down at all. So once I hit 
>> a high
>> trip point the fan stays at that speed forever.
>
> I'm running now with:
>
> $ git describe
> v3.9-rc1
>
> and it seem that the behaviour of my laptop is similar to yours.
> Also, immediately after a suspend/resume cycle, the fan speed goes down,
> and again the speeds correctly goes up as the temperature rises, but when
> the temperature drops the fan doesn't slow.
>
> Now the suspend/resume cycle seems almost unrelated with the issue 
> (except for
> the fan speed reset at resume).
>



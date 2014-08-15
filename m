Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbaHOQgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:36:03 -0400
Received: from service87.mimecast.com ([91.220.42.44]:52255 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaHOQgB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:36:01 -0400
Message-ID: <53EE36F5.7000801@arm.com>
Date: Fri, 15 Aug 2014 17:36:05 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Will Deacon <Will.Deacon@arm.com>, Chao Xie <chao.xie@marvell.com>,
        Stephen Warren <swarren@nvidia.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Chao Xie Linux <xiechao.mail@gmail.com>,
        Juri Lelli <juri.lelli@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] cpuidle/cpuidle-big_little: fix reading cpu id part
 number
References: <1408004865-27525-1-git-send-email-juri.lelli@arm.com> <7hwqa9ww6n.fsf@paris.lan>
In-Reply-To: <7hwqa9ww6n.fsf@paris.lan>
X-OriginalArrivalTime: 15 Aug 2014 16:35:56.0890 (UTC) FILETIME=[FD300BA0:01CFB8A6]
X-MC-Unique: 114081517355801201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/08/14 17:32, Kevin Hilman wrote:
> Juri Lelli <juri.lelli@arm.com> writes:
> 
>> Commit af040ffc9ba1 ("ARM: make it easier to check the CPU part number
>> correctly") changed ARM_CPU_PART_X masks, and the way they are returned and
>> checked against. Usage of read_cpuid_part_number() is now deprecated, and
>> calling places updated accordingly. This actually broke cpuidle-big_little
>> initialization, as bl_idle_driver_init() performs a check using an hardcoded
>> mask on cpu_id.
>>
>> Create an interface to perform the check (that is now even easier to read).
>> Define also a proper mask (ARM_CPU_PART_MASK) that makes this kind of checks
>> cleaner and helps preventing bugs in the future. Update usage accordingly.
> 
> [...]
> 
> Tested-by: Kevin Hilman <khilman@linaro.org>
> 

Great, thanks!

> FWIW, I can confirm that this patch is needed for cpuidle-big_little to
> work on the Exynos5800/Chromebook2.
> 

Ok, the patch has been already sent to Russell's patch system.

Best,

- Juri

> Kevin
> 


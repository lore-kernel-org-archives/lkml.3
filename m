Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab3LMAcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 19:32:53 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:35326 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab3LMAcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 19:32:50 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Tarek Dakhran <t.dakhran@samsung.com>
Cc: Vyacheslav Tyrtov <v.tyrtov@samsung.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Heiko Stuebner <heiko@sntech.de>,
        Naour Romain <romain.naour@openwide.fr>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Dave.Martin@arm.com,
        nicolas.pitre@linaro.org, tomasz.figa@gmail.com
Subject: Re: [PATCH v5 0/3] Exynos 5410 support
In-Reply-To: <52A836C9.9020405@samsung.com> (Tarek Dakhran's message of "Wed,
	11 Dec 2013 13:56:25 +0400")
References: <1386685599-31536-1-git-send-email-v.tyrtov@samsung.com>
	<87ppp48xrs.fsf@linaro.org> <52A836C9.9020405@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
Date: Thu, 12 Dec 2013 16:32:46 -0800
Message-ID: <87haad615d.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tarek Dakhran <t.dakhran@samsung.com> writes:

> On 12/10/2013 08:40 PM, Kevin Hilman wrote:
>> Vyacheslav Tyrtov <v.tyrtov@samsung.com> writes:
>>
>>> The series of patches represent support of Exynos 5410 SoC
>>>
>>> The Exynos 5410 is the first Samsung SoC based on bigLITTLE architecture
>>>
>>> Patches add new platform description, support of clock controller and device
>>> tree for Exynos 5410.
>>>
>>> Dual cluster support for Exynos 5410 (EDCS) has been removed from this series
>>> This patches is activating only the big cluster (all A15 cores)
>> Testing this series on top of v3.13-rc3, plus a couple of other
>> necessary changes (which should've probably been noted in the changelog):
>>
>> 1) change CONFIG_NR_CPUS=8 in .config
>> 2) add the exynos combiner patch from Chander:
>>     [PATCH v2] irqchip: exynos-combiner: remove hard-coded irq_base value
>>
>> I'm still only seeing 2 out of 4 cores come up on my odroid-xu:
>>
>> [    0.045000] CPU: Testing write buffer coherency: ok
>> [    0.045000] CPU0: update cpu_power 1024
>> [    0.045000] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
>> [    0.045000] Setting up static identity map for 0x403717d8 - 0x40371830
>> [    0.045000] CPU1: Booted secondary processor
>> [    0.065000] CPU1: update cpu_power 1024
>> [    0.065000] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
>> [    1.075000] CPU2: failed to boot: -38
>> [    2.075000] CPU3: failed to boot: -38
>> [    2.075000] Brought up 2 CPUs
>> [    2.075000] SMP: Total of 2 processors activated.
>> [    2.075000] CPU: All CPU(s) started in SVC mode.
>>
> Hi Kevin,
>
> EDCS(exynos dual cluster support) moved to separate patch now.
> This patches introduce only base SoC support  (2xA15).

Thanks for the clarification

I thought there were 4 A15s, and the changelog mentioned this patch
enabled "all A15s".

Kevin

> Patches tested on samsung smdk5410 board.
>
> Next version of EDCS patches will be available soon.
> They allow power on and boot all 8 cores.


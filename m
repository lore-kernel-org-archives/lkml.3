Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab3LKJ5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 04:57:09 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42279 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3LKJ4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 04:56:36 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-87-52a836d18420
Message-id: <52A836C9.9020405@samsung.com>
Date: Wed, 11 Dec 2013 13:56:25 +0400
From: Tarek Dakhran <t.dakhran@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Kevin Hilman <khilman@linaro.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
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
References: <1386685599-31536-1-git-send-email-v.tyrtov@samsung.com>
 <87ppp48xrs.fsf@linaro.org>
In-reply-to: <87ppp48xrs.fsf@linaro.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t/xq7oXzVYEGZw8aW4xad0BJot5n2Ut
	mubuYbSYf+Qcq8X/R69ZLc69Wslo0bvgKpvF18MrGC02Pb7GarGwbQmLxeVdc9gsZpzfx2Rx
	+zKvxdLrF5ksnk64yGbx6dk/dosJ09eyWBxeATRy3cvpLBZbfnYwWrw62MZisXnTVGaLVbv+
	MFpMnfGD3UHCY828NYweLc09bB4LPl9h9/i76gWzx85Zd9k9Vi7/wubxavVMVo871/awebw7
	d47dY/OSeo9X11g8+rasYvTYfm0es8fnTXIeG+eGBvBHcdmkpOZklqUW6dslcGX0butlKjjG
	V9E+/QtzA+NW7i5GTg4JAROJpvfnGSFsMYkL99azdTFycQgJLGWUWNK6iAXCec8osfvlGxaQ
	Kl4BLYlF5yaygtgsAqoSm39PAOrm4GAT0JbYssMLJCwqECHxd956RohyQYkfk++BtYoI+Ets
	uPMXbCazQD+bxIR1H8DmCAvoS1z99ocdxBYSSJJY1Q3RzCmgIfG7ZR6YzSxgLbFy0jYoW15i
	85q3zBMYBWYh2TELSdksJGULGJlXMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoTE+tcdjEuP
	WR1iFOBgVOLhPVC0PEiINbGsuDL3EKMEB7OSCO8KhhVBQrwpiZVVqUX58UWlOanFhxiZODil
	GhjFD37hff5gy+MJF5Yk75gesviZxc9vaaWxWT+1eVYZ1YTzzVx5uf/Gp5snDu/gmy/5+/1/
	pstewdHLtt0IWKB/UeDW4+cN81//THVMCXnKmHz22r91Qov/GAqZ/ms9UqQtyF5286wSq4l/
	frb8B6Zlbz1UdZlqOV7uma1X2izjcmEOZ97/AKnnSizFGYmGWsxFxYkAGjBDy9MCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 08:40 PM, Kevin Hilman wrote:
> Vyacheslav Tyrtov <v.tyrtov@samsung.com> writes:
>
>> The series of patches represent support of Exynos 5410 SoC
>>
>> The Exynos 5410 is the first Samsung SoC based on bigLITTLE architecture
>>
>> Patches add new platform description, support of clock controller and device
>> tree for Exynos 5410.
>>
>> Dual cluster support for Exynos 5410 (EDCS) has been removed from this series
>> This patches is activating only the big cluster (all A15 cores)
> Testing this series on top of v3.13-rc3, plus a couple of other
> necessary changes (which should've probably been noted in the changelog):
>
> 1) change CONFIG_NR_CPUS=8 in .config
> 2) add the exynos combiner patch from Chander:
>     [PATCH v2] irqchip: exynos-combiner: remove hard-coded irq_base value
>
> I'm still only seeing 2 out of 4 cores come up on my odroid-xu:
>
> [    0.045000] CPU: Testing write buffer coherency: ok
> [    0.045000] CPU0: update cpu_power 1024
> [    0.045000] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
> [    0.045000] Setting up static identity map for 0x403717d8 - 0x40371830
> [    0.045000] CPU1: Booted secondary processor
> [    0.065000] CPU1: update cpu_power 1024
> [    0.065000] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
> [    1.075000] CPU2: failed to boot: -38
> [    2.075000] CPU3: failed to boot: -38
> [    2.075000] Brought up 2 CPUs
> [    2.075000] SMP: Total of 2 processors activated.
> [    2.075000] CPU: All CPU(s) started in SVC mode.
>
Hi Kevin,

EDCS(exynos dual cluster support) moved to separate patch now.
This patches introduce only base SoC support  (2xA15).

Patches tested on samsung smdk5410 board.

Next version of EDCS patches will be available soon.
They allow power on and boot all 8 cores.

Best regards,
     Tarek Dakhran.

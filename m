Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbaGAIj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:39:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18113 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047AbaGAIjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:39:16 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-b7f2f6d0000040c4-f8-53b273b15b63
Content-transfer-encoding: 8BIT
Message-id: <53B273A6.1010808@samsung.com>
Date: Tue, 01 Jul 2014 17:39:02 +0900
From: Inki Dae <inki.dae@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/exynos: Fix NULL pointer exception when suspending
 without components
References: <1404134744-15852-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1404134744-15852-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsWyRsSkWHdj8aZgg7tfFS1urTvHatF77iST
	xcYZ61ktrnx9z2bx4t5FFovXLwwtehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF2iN32S0W
	bHzEaDFj8ks2Bz6P7d8esHrc7z7O5LF5Sb1H35ZVjB6fN8kFsEZx2aSk5mSWpRbp2yVwZdz4
	f4Ox4Ld9xdvH7g2MX0y6GDk5JARMJA69vcQOYYtJXLi3nq2LkYtDSGApo8T8HU2MMEU9az6y
	QiSmM0rcXTyFBSTBKyAo8WPyPSCbg4NZQF7iyKVskDCzgLrEpHmLmCHqXzFK3G9/zQhRryVx
	pe0JK4jNIqAq8fn9bzCbDcieuOI+G4gtKhAm8eLVLmYQW0TAUOLg7u1MIIOYBX4xS0y4NY8V
	ZJmwQIJEX18GSI2QgLtE05TvYL2cAh4SO+5dYYI4upVD4uQiV4hdAhLfJh8Cu1NCQFZi0wFm
	iBJJiYMrbrBMYBSbheSbWQjfzELyzQJG5lWMoqkFyQXFSelFpnrFibnFpXnpesn5uZsYgTF7
	+t+ziTsY7x+wPsSYDLRxIrOUaHI+MObzSuINjc2MLExNTI2NzC3NSBNWEudNf5QUJCSQnliS
	mp2aWpBaFF9UmpNafIiRiYNTqoHRTObJhebDylcbFt89Pj30rGb0NtNXlnzB778z1Z2z+h0S
	rpretHD9vqpXmnrKUbb3V18Oefxw2+P1nMl76o4tuHIua/J3FZuL096s+Hj05d2/BpkzZ9+U
	f2Qcz/C7UvNt/bdNj+R4H+/+dSNkxrndj0R4an0mzqxaEqbX/Hx6omJ8/cfqkG0TziuxFGck
	GmoxFxUnAgBbyt/p7wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xoO7G4k3BBmu2S1rcWneO1aL33Ekm
	i40z1rNaXPn6ns3ixb2LLBavXxha9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaLtUfuslss
	2PiI0WLG5JdsDnwe2789YPW4332cyWPzknqPvi2rGD0+b5ILYI1qYLTJSE1MSS1SSM1Lzk/J
	zEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMATpUSaEsMacUKBSQWFyspG+HaUJo
	iJuuBUxjhK5vSBBcj5EBGkhYw5hx4/8NxoLf9hVvH7s3MH4x6WLk5JAQMJHoWfORFcIWk7hw
	bz1bFyMXh5DAdEaJu4unsIAkeAUEJX5Mvgdkc3AwC8hLHLmUDRJmFlCXmDRvETNE/StGifvt
	rxkh6rUkrrQ9ARvKIqAq8fn9bzCbDcieuOI+G4gtKhAm8eLVLmYQW0TAUOLg7u1MIIOYBX4x
	S0y4NY8VZJmwQIJEX18GSI2QgLtE05TvYL2cAh4SO+5dYZrAKDALyXmzEM6bheS8BYzMqxhF
	UwuSC4qT0nON9IoTc4tL89L1kvNzNzGCU8Iz6R2MqxosDjEKcDAq8fCeqN0YLMSaWFZcmXuI
	UYKDWUmElz1tU7AQb0piZVVqUX58UWlOavEhRlOg5yYyS4km5wPTVV5JvKGxiZmRpZG5oYWR
	sbmSOO/BVutAIYH0xJLU7NTUgtQimD4mDk6pBsbNiXJhzkb2m6Y8EN3doLT2/P7b3z6+su7y
	PfQq1kVr7SXes5uzj1gcfanceMxTs3v1mRDHIoHmB9deHGq7t/OPkXuC6dzXz5wjGW3TAx/1
	1zamP33XL70jxPyCWcmbKUbTDsZ+Y10Z8J/jsKr9An3r9xx1EpO2OH/W0fzHusp+jZmWj7MW
	p4ISS3FGoqEWc1FxIgAnH4dSHwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 06월 30일 22:25, Krzysztof Kozlowski wrote:
> Fix a NULL pointer exception when main exynos drm driver was probed
> successfully but no components were added (e.g. by incomplete DTS). In
> such case the exynos_drm_load() is never called and drvdata is NULL.
> 

Right, it's good report. Applied.

Thanks,
Inki Dae


> The NULL pointer exception may theoretically also happen as a effect of race between
> adding components and main driver: if suspend of the driver happens
> before adding components.
> 
> Trace:
> [    1.190295] [drm] Initialized drm 1.1.0 20060810
> [    1.195209] exynos-drm-ipp exynos-drm-ipp: drm ipp registered successfully.
> (...)
> [   24.001743] PM: Syncing filesystems ... done.
> [   24.002177] Freezing user space processes ... (elapsed 0.000 seconds) done.
> [   24.007403] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
> [   24.032559] Unable to handle kernel NULL pointer dereference at virtual address 00000134
> [   24.035007] pgd = dedd8000
> [   24.037734] [00000134] *pgd=5ee13831, *pte=00000000, *ppte=00000000
> [   24.043953] Internal error: Oops: 17 [#1] PREEMPT SMP ARM
> [   24.049329] Modules linked in:
> [   24.052371] CPU: 0 PID: 1 Comm: sh Not tainted 3.16.0-rc3-00035-geba20bbdde04-dirty #51
> [   24.060354] task: df478000 ti: df480000 task.ti: df480000
> [   24.065743] PC is at mutex_lock+0x10/0x50
> [   24.069733] LR is at drm_modeset_lock_all+0x30/0xbc
> [   24.074590] pc : [<c048516c>]    lr : [<c02a14b4>]    psr: a0000013
> [   24.074590] sp : df481db8  ip : 00000000  fp : c05e524c
> [   24.086045] r10: 00000002  r9 : c02c1fe4  r8 : deca5e44
> [   24.091253] r7 : 00000000  r6 : 00000000  r5 : 0000014c  r4 : 00000134
> [   24.097763] r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 : 00000134
> [   24.104275] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [   24.111391] Control: 10c53c7d  Table: 5edd806a  DAC: 00000015
> [   24.117120] Process sh (pid: 1, stack limit = 0xdf480240)
> [   24.122502] Stack: (0xdf481db8 to 0xdf482000)
> [   24.126843] 1da0:                                                       dee01d80 c02a14b4
> [   24.135004] 1dc0: 00000000 00000000 c07aff98 c02aec7c 00000002 00000000 00000000 c07aff98
> [   24.143164] 1de0: deca5e10 c02aecf4 c02aecd4 c02c2010 00000000 c02c9470 00000000 00000000
> [   24.151322] 1e00: 00000000 00000000 deca5e10 deca5e10 00000000 c07aff98 00000002 deca5e44
> [   24.159482] 1e20: c06d8f78 c06fb800 deca5e78 c02ca660 df7baf00 007b0aa0 deca5e10 c06fb7c8
> [   24.167641] 1e40: c07aff98 00000000 00000002 c02cbe18 9757aec5 00000005 9757aec5 00000005
> [   24.175801] 1e60: ded1d380 00000003 00000003 c05c74d8 ded1d380 c07209d4 c05c7514 c07105d8
> [   24.183960] 1e80: 01e2a738 c0068a74 00000000 c05c7514 ded1d380 c071c6e0 00000004 c07105d8
> [   24.192119] 1ea0: 01e2a738 c047f1e0 c0600cc0 df481ec4 00000003 00000000 00000003 c05c74d8
> [   24.200278] 1ec0: ded1d380 c071c6e0 c05c7514 c07105d8 01e2a738 c0069444 c06d905c 00000003
> [   24.208438] 1ee0: 00000003 ded1d380 c06d9064 00000004 c05c3fc0 c0067d4c df535ab0 ded1d380
> [   24.216596] 1f00: df481f80 ded1d380 00000004 ded1d1cc ded1d1c0 c0221724 00000004 c016ca6c
> [   24.224756] 1f20: c016ca28 00000000 00000000 c016c1d4 00000000 00000000 b6f37000 df481f80
> [   24.232915] 1f40: decedd80 00000004 df480000 df480000 b6f37000 c0110920 df47839c 60000013
> [   24.241074] 1f60: 00000000 00000000 decedd80 decedd80 00000004 df480000 b6f37000 c0110da8
> [   24.249233] 1f80: 00000000 00000000 00000004 b6edf5d8 00000004 b6f37000 00000004 c000f2a8
> [   24.257393] 1fa0: 00001000 c000f0e0 b6edf5d8 00000004 00000001 b6f37000 00000004 00000000
> [   24.265551] 1fc0: b6edf5d8 00000004 b6f37000 00000004 00000004 00000001 00000000 01e2a738
> [   24.273711] 1fe0: 00000000 beba0a20 b6e1f4f0 b6e7022c 60000010 00000001 ffffffff ffffffff
> [   24.281885] [<c048516c>] (mutex_lock) from [<c02a14b4>] (drm_modeset_lock_all+0x30/0xbc)
> [   24.289950] [<c02a14b4>] (drm_modeset_lock_all) from [<c02aec7c>] (exynos_drm_suspend+0xc/0x64)
> [   24.298627] [<c02aec7c>] (exynos_drm_suspend) from [<c02aecf4>] (exynos_drm_sys_suspend+0x20/0x34)
> [   24.307568] [<c02aecf4>] (exynos_drm_sys_suspend) from [<c02c2010>] (platform_pm_suspend+0x2c/0x54)
> [   24.316597] [<c02c2010>] (platform_pm_suspend) from [<c02c9470>] (dpm_run_callback+0x48/0x170)
> [   24.325188] [<c02c9470>] (dpm_run_callback) from [<c02ca660>] (__device_suspend+0x128/0x39c)
> [   24.333606] [<c02ca660>] (__device_suspend) from [<c02cbe18>] (dpm_suspend+0x5c/0x314)
> [   24.341506] [<c02cbe18>] (dpm_suspend) from [<c0068a74>] (suspend_devices_and_enter+0x8c/0x598)
> [   24.350185] [<c0068a74>] (suspend_devices_and_enter) from [<c0069444>] (pm_suspend+0x4c4/0x5d0)
> [   24.358862] [<c0069444>] (pm_suspend) from [<c0067d4c>] (state_store+0x70/0xd4)
> [   24.366156] [<c0067d4c>] (state_store) from [<c0221724>] (kobj_attr_store+0x14/0x20)
> [   24.373885] [<c0221724>] (kobj_attr_store) from [<c016ca6c>] (sysfs_kf_write+0x44/0x48)
> [   24.381867] [<c016ca6c>] (sysfs_kf_write) from [<c016c1d4>] (kernfs_fop_write+0xc0/0x17c)
> [   24.390027] [<c016c1d4>] (kernfs_fop_write) from [<c0110920>] (vfs_write+0xa0/0x1c4)
> [   24.397750] [<c0110920>] (vfs_write) from [<c0110da8>] (SyS_write+0x40/0x8c)
> [   24.404782] [<c0110da8>] (SyS_write) from [<c000f0e0>] (ret_fast_syscall+0x0/0x3c)
> [   24.412332] Code: e92d4010 e1a04000 f57ff05b f590f000 (e1903f9f)
> [   24.418448] ---[ end trace cfa06690eabe8dd5 ]---
> [   24.423032] Kernel panic - not syncing: Fatal exception
> [   24.428220] CPU1: stopping
> [   24.430905] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D       3.16.0-rc3-00035-geba20bbdde04-dirty #51
> [   24.440549] [<c0016440>] (unwind_backtrace) from [<c001294c>] (show_stack+0x10/0x14)
> [   24.448269] [<c001294c>] (show_stack) from [<c04811e8>] (dump_stack+0x80/0xcc)
> [   24.455472] [<c04811e8>] (dump_stack) from [<c001495c>] (handle_IPI+0x130/0x15c)
> [   24.462850] [<c001495c>] (handle_IPI) from [<c000862c>] (gic_handle_irq+0x60/0x68)
> [   24.470400] [<c000862c>] (gic_handle_irq) from [<c0013440>] (__irq_svc+0x40/0x70)
> [   24.477860] Exception stack(0xdf4bdf88 to 0xdf4bdfd0)
> [   24.482898] df80:                   ffffffed 00000000 00000000 00000000 df4bc000 c06d042c
> [   24.491058] dfa0: 00000000 ffffffed c06d03c0 00000000 c070c288 00000000 00000000 df4bdfd0
> [   24.499214] dfc0: c0010324 c0010328 60000013 ffffffff
> [   24.504254] [<c0013440>] (__irq_svc) from [<c0010328>] (arch_cpu_idle+0x28/0x30)
> [   24.511634] [<c0010328>] (arch_cpu_idle) from [<c005f110>] (cpu_startup_entry+0x2c4/0x3f0)
> [   24.519878] [<c005f110>] (cpu_startup_entry) from [<400086c4>] (0x400086c4)
> [   24.526821] ---[ end Kernel panic - not syncing: Fatal exception
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Andrzej Hajda <a.hajda@samsung.com>
> Cc: Inki Dae <inki.dae@samsung.com>
> Fixes: af65c8048770 ("drm/exynos: Consolidate suspend/resume in drm_drv")
> Cc: <stable@vger.kernel.org>
> 
> ---
> Probably other DRM drivers may be also affected by this issue (e.g.
> msm).
> ---
>  drivers/gpu/drm/exynos/exynos_drm_drv.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
> index ab7d182063c3..e98a882c1bba 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
> @@ -362,7 +362,7 @@ static int exynos_drm_sys_suspend(struct device *dev)
>  	struct drm_device *drm_dev = dev_get_drvdata(dev);
>  	pm_message_t message;
>  
> -	if (pm_runtime_suspended(dev))
> +	if (pm_runtime_suspended(dev) || !drm_dev)
>  		return 0;
>  
>  	message.event = PM_EVENT_SUSPEND;
> @@ -373,7 +373,7 @@ static int exynos_drm_sys_resume(struct device *dev)
>  {
>  	struct drm_device *drm_dev = dev_get_drvdata(dev);
>  
> -	if (pm_runtime_suspended(dev))
> +	if (pm_runtime_suspended(dev) || !drm_dev)
>  		return 0;
>  
>  	return exynos_drm_resume(drm_dev);
> 


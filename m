Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727Ab3GPNQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 09:16:29 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42289 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932697Ab3GPNQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 09:16:25 -0400
Message-ID: <51E5475B.1050900@ti.com>
Date: Tue, 16 Jul 2013 16:15:07 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <linus.walleij@linaro.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 1/4] pinctrl: Remove duplicate code in pinctrl_pm_select_state
 functions
References: <20130716090310.5541.36777.stgit@localhost> <20130716090529.5541.54331.stgit@localhost>
In-Reply-To: <20130716090529.5541.54331.stgit@localhost>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

This patch causes boot failure when I've applied my patch
"[RFC] ARM: OMAP2+: omap_device: add pinctrl handling"
https://lkml.org/lkml/2013/6/21/309

on top of it:

[    0.264007] L310 cache controller enabled
[    0.268310] l2x0: 16 ways, CACHE_ID 0x410000c4, AUX_CTRL 0x7e470000, 
Cache size: 1048576 B
[    0.282440] CPU1: Booted secondary processor
[    0.366760] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    0.367401] Brought up 2 CPUs
[    0.380920] SMP: Total of 2 processors activated (2387.96 BogoMIPS).
[    0.387573] CPU: All CPU(s) started in SVC mode.
[    0.395324] devtmpfs: initialized
[    0.468658] pinctrl core: initialized pinctrl subsystem
[    0.477996] regulator-dummy: no parameters
[    0.485412] NET: Registered protocol family 16
[    0.499145] DMA: preallocated 256 KiB pool for atomic coherent 
allocations
[    0.573181] Unable to handle kernel NULL pointer dereference at 
virtual address 00000008
[    0.581573] pgd = c0004000
[    0.584472] [00000008] *pgd=00000000
[    0.588226] Internal error: Oops: 5 [#1] SMP ARM
[    0.593078] Modules linked in:
[    0.596313] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 
3.11.0-rc1-00005-g37e15e6-dirty #100
[    0.604888] task: de07f3c0 ti: de080000 task.ti: de080000
[    0.610565] PC is at pinctrl_pm_select_active_state+0x4/0xc
[    0.616394] LR is at _od_runtime_resume+0xc/0x20
[    0.621215] pc : [<c02d4e2c>]    lr : [<c002e930>]    psr: 60000193
[    0.621215] sp : de081cc0  ip : 60000193  fp : 00000000
[    0.633209] r10: de080000  r9 : c0067e90  r8 : 00000004
[    0.638671] r7 : c07800c0  r6 : c002e924  r5 : de0cf4a0  r4 : de0cf410
[    0.645477] r3 : 00000000  r2 : 00000004  r1 : 00000470  r0 : de0cf410
[    0.652282] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM 
Segment kernel
[    0.660003] Control: 10c53c7d  Table: 8000404a  DAC: 00000017
[    0.665985] Process swapper/0 (pid: 1, stack limit = 0xde080240)
[    0.672241] Stack: (0xde081cc0 to 0xde082000)
[    0.676818] 1cc0: de0cf410 c0335310 de0cf410 de0cb410 00000001 
c0335374 de0cf410 de0cb410
[    0.685333] 1ce0: 00000001 c033664c c0336b14 00000004 c1bbdedc 
00000000 00000000 c0507c5c
[    0.693847] 1d00: de0cf4a0 de0cf410 60000113 00000004 c1bbdedc 
00000000 00000000 c0336b24
[    0.702362] 1d20: de07f3c0 de11ea10 de0cf410 de0cf400 de0cd780 
c02df144 de0cd740 00000000
[    0.710845] 1d40: de0cf410 c0d6a634 de0cf410 00000000 00000000 
c07efe7c 00000000 00000000
[    0.719360] 1d60: 00000000 c032d794 c032d77c c032c554 de0cf410 
c032c784 00000000 00000000
[    0.727874] 1d80: c0d6a5f0 c032ac98 de07bed8 de0fd714 de0cf410 
de0cf444 c07f65e8 c032c48c
[    0.736389] 1da0: de0cf410 de0cf410 c07f65e8 c032b[RFC] ARM: OMAP2+: 
omap_device: add pinctrl handlinga94 de0cf410 de0cf418 de0cb410 c0329ef8
[    0.744873] 1dc0: 4a3101ff 00000000 00000200 00000000 00000000 
00000000 c076f630 00000000
[    0.753387] 1de0: de0cf400 00000000 de0cb410 c076f630 de0cb410 
00000000 00000000 c042c2dc
[    0.761901] 1e00: de0cb410 c1bbdedc 00000000 00000000 00000001 
c042c3dc 00000001 c076f630
[    0.770385] 1e20: 00000000 de0cb410 00000000 c0099068 60000113 
c080b22c c1bbdd98 00000001
[    0.778900] 1e40: c076f630 c1bbcaec 00000000 c1bbdedc 00000001 
c076f630 00000000 de0cb410
[    0.787414] 1e60: 00000000 c042c440 00000001 c076f630 00000000 
00000001 00000000 c0099068
[    0.795928] 1e80: 60000113 c080b22c 00000000 00000000 c076f630 
c1bbcaec c1bbc09c 00000000
[    0.804412] 1ea0: 00000000 c076f630 00000000 00000001 00000000 
c042c4e4 00000001 c072c37c
[    0.812927] 1ec0: c07221e0 de080000 c0762648 00000000 000000a4 
c077979c c071f1c8 c0730a6c
[    0.821441] 1ee0: c0760aec c07221fc 00000000 c0008978 00000083 
de07f3c0 60000193 00000000
[    0.829925] 1f00: 00000006 c07dbcd4 c07dbcd4 60000113 c02bf100 
00000000 c07dbcd0 c07dbcd0
[    0.838439] 1f20: 00000000 c0507c5c 00000002 de080000 c06f1920 
c1bc531d 000000a4 c00655ec
[    0.846954] 1f40: c06b2bd8 c06f0ee0 00000003 00000003 60000113 
c0762668 00000003 c0762648
[    0.855468] 1f60: c0817500 000000a4 c077979c c071f1c8 00000000 
c071f91c 00000003 00000003
[    0.863952] 1f80: c071f1c8 00000000 00000000 c04fd9ac 00000000 
00000000 00000000 00000000
[    0.872467] 1fa0: 00000000 c04fd9b4 00000000 c0013ac8 00000000 
00000000 00000000 00000000
[    0.880981] 1fc0: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[    0.889465] 1fe0: 00000000 00000000 00000000 00000000 00000013 
00000000 ce5331ac 3153ceac
[    0.898010] [<c02d4e2c>] (pinctrl_pm_select_active_state+0x4/0xc) 
from [<c002e930>] (_od_runtime_resume+0xc/0x20)
[    0.908660] [<c002e930>] (_od_runtime_resume+0xc/0x20) from 
[<c0335310>] (__rpm_callback+0x34/0x70)
[    0.918060] [<c0335310>] (__rpm_callback+0x34/0x70) from [<c0335374>] 
(rpm_callback+0x28/0x88)
[    0.927032] [<c0335374>] (rpm_callback+0x28/0x88) from [<c033664c>] 
(rpm_resume+0x3c8/0x624)
[    0.935821] [<c033664c>] (rpm_resume+0x3c8/0x624) from [<c0336b24>] 
(__pm_runtime_resume+0x48/0x60)
[    0.945220] [<c0336b24>] (__pm_runtime_resume+0x48/0x60) from 
[<c02df144>] (omap_gpio_probe+0x254/0x6c0)
[    0.955078] [<c02df144>] (omap_gpio_probe+0x254/0x6c0) from 
[<c032d794>] (platform_drv_probe+0x18/0x1c)
[    0.964843] [<c032d794>] (platform_drv_probe+0x18/0x1c) from 
[<c032c554>] (driver_probe_device+0x88/0x220)
[    0.974884] [<c032c554>] (driver_probe_device+0x88/0x220) from 
[<c032ac98>] (bus_for_each_drv+0x5c/0x88)
[    0.984710] [<c032ac98>] (bus_for_each_drv+0x5c/0x88) from 
[<c032c48c>] (device_attach+0x80/0xa4)
[    0.993957] [<c032c48c>] (device_attach+0x80/0xa4) from [<c032ba94>] 
(bus_probe_device+0x88/0xac)
[    1.003173] [<c032ba94>] (bus_probe_device+0x88/0xac) from 
[<c0329ef8>] (device_add+0x418/0x61c)
[    1.012329] [<c0329ef8>] (device_add+0x418/0x61c) from [<c042c2dc>] 
(of_platform_device_create_pdata+0x5c/0x80)
[    1.022796] [<c042c2dc>] (of_platform_device_create_pdata+0x5c/0x80) 
from [<c042c3dc>] (of_platform_bus_create+0xdc/0x184)
[    1.034271] [<c042c3dc>] (of_platform_bus_create+0xdc/0x184) from 
[<c042c440>] (of_platform_bus_create+0x140/0x184)
[    1.045104] [<c042c440>] (of_platform_bus_create+0x140/0x184) from 
[<c042c4e4>] (of_platform_populate+0x60/0x98)
[    1.055664] [<c042c4e4>] (of_platform_populate+0x60/0x98) from 
[<c0730a6c>] (omap_generic_init+0x24/0x60)
[    1.065612] [<c0730a6c>] (omap_generic_init+0x24/0x60) from 
[<c07221fc>] (customize_machine+0x1c/0x40)
[    1.075286] [<c07221fc>] (customize_machine+0x1c/0x40) from 
[<c0008978>] (do_one_initcall+0xe4/0x148)
[    1.084869] [<c0008978>] (do_one_initcall+0xe4/0x148) from 
[<c071f91c>] (kernel_init_freeable+0xfc/0x1c8)
[    1.094818] [<c071f91c>] (kernel_init_freeable+0xfc/0x1c8) from 
[<c04fd9b4>] (kernel_init+0x8/0xe4)
[    1.104248] [<c04fd9b4>] (kernel_init+0x8/0xe4) from [<c0013ac8>] 
(ret_from_fork+0x14/0x2c)
[    1.112915] Code: e59031b4 e593100c eaffffde e59031b4 (e5931008)
[    1.119323] ---[ end trace fd7907bbe82cc699 ]---
[    1.124206] Kernel panic - not syncing: Attempted to kill init! 
exitcode=0x0000000b
[    1.124206]
[    1.133789] CPU1: stopping
[    1.136657] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D 
3.11.0-rc1-00005-g37e15e6-dirty #100
[    1.146270] [<c001b62c>] (unwind_backtrace+0x0/0xf0) from 
[<c00177fc>] (show_stack+0x10/0x14)
[    1.155151] [<c00177fc>] (show_stack+0x10/0x14) from [<c05027cc>] 
(dump_stack+0x70/0x8c)
[    1.163574] [<c05027cc>] (dump_stack+0x70/0x8c) from [<c0019384>] 
(handle_IPI+0x130/0x158)
[    1.172180] [<c0019384>] (handle_IPI+0x130/0x158) from [<c0008760>] 
(gic_handle_irq+0x54/0x5c)
[    1.181121] [<c0008760>] (gic_handle_irq+0x54/0x5c) from [<c0508624>] 
(__irq_svc+0x44/0x5c)
[    1.189819] Exception stack(0xde0a7f90 to 0xde0a7fd8)
[    1.195098] 7f80:                                     c0014ca8 
000002da 00000000 00000000
[    1.203613] 7fa0: de0a6000 00000000 10c03c7d c0817774 c0514820 
c0815e40 c07869a8 00000000
[    1.212097] 7fc0: 01000000 de0a7fd8 c0014ca8 c0014cac 60000113 ffffffff
[    1.219024] [<c0508624>] (__irq_svc+0x44/0x5c) from [<c0014cac>] 
(arch_cpu_idle+0x38/0x44)
[    1.227630] [<c0014cac>] (arch_cpu_idle+0x38/0x44) from [<c00875d4>] 
(cpu_startup_entry+0xa8/0x228)
[    1.237030] [<c00875d4>] (cpu_startup_entry+0xa8/0x228) from 
[<80008264>] (0x80008264)


On 07/16/2013 12:05 PM, Tony Lindgren wrote:
> There's no need to duplicate essentially the same functions. Let's
> introduce static int pinctrl_pm_select_state() and make the other
> related functions call that.
>
> This allows us to add support later on for multiple active states,
> and more optimized dynamic remuxing.
>
> Note that we still need to export the various pinctrl_pm_select
> functions as we want to keep struct pinctrl_state private to the
> pinctrl code, and cannot replace those with inline functions.
>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
>   drivers/pinctrl/core.c |   47 +++++++++++++++++++----------------------------
>   1 file changed, 19 insertions(+), 28 deletions(-)
>
> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> index 5b272bf..bda2c61 100644
> --- a/drivers/pinctrl/core.c
> +++ b/drivers/pinctrl/core.c
> @@ -1227,23 +1227,34 @@ EXPORT_SYMBOL_GPL(pinctrl_force_default);
>   #ifdef CONFIG_PM
>
>   /**
> - * pinctrl_pm_select_default_state() - select default pinctrl state for PM
> + * pinctrl_pm_select_state() - select pinctrl state for PM
>    * @dev: device to select default state for
> + * @state: state to set
>    */
> -int pinctrl_pm_select_default_state(struct device *dev)
> +static int pinctrl_pm_select_state(struct device *dev, struct pinctrl_state *state)
>   {
>   	struct dev_pin_info *pins = dev->pins;
>   	int ret;
>
>   	if (!pins)
>   		return 0;
> -	if (IS_ERR(pins->default_state))
> -		return 0; /* No default state */
> -	ret = pinctrl_select_state(pins->p, pins->default_state);
> +	if (IS_ERR(state))
> +		return 0; /* No such state */
> +	ret = pinctrl_select_state(pins->p, state);
>   	if (ret)
> -		dev_err(dev, "failed to activate default pinctrl state\n");
> +		dev_err(dev, "failed to activate pinctrl state %s\n",
> +			state->name);
>   	return ret;
>   }
> +
> +/**
> + * pinctrl_pm_select_default_state() - select default pinctrl state for PM
> + * @dev: device to select default state for
> + */
> +int pinctrl_pm_select_default_state(struct device *dev)
> +{

Seems, need to keep check for !dev->pins here
if (!dev->pins)
	                return 0;

> +	return pinctrl_pm_select_state(dev, dev->pins->default_state);
> +}
>   EXPORT_SYMBOL_GPL(pinctrl_pm_select_default_state);
>
>   /**
> @@ -1252,17 +1263,7 @@ EXPORT_SYMBOL_GPL(pinctrl_pm_select_default_state);
>    */
>   int pinctrl_pm_select_sleep_state(struct device *dev)
>   {
> -	struct dev_pin_info *pins = dev->pins;
> -	int ret;
> -
> -	if (!pins)
> -		return 0;
> -	if (IS_ERR(pins->sleep_state))
> -		return 0; /* No sleep state */
> -	ret = pinctrl_select_state(pins->p, pins->sleep_state);
> -	if (ret)
> -		dev_err(dev, "failed to activate pinctrl sleep state\n");
> -	return ret;
here
if (!dev->pins)
	                return 0;
> +	return pinctrl_pm_select_state(dev, dev->pins->sleep_state);
>   }
>   EXPORT_SYMBOL_GPL(pinctrl_pm_select_sleep_state);
>
> @@ -1272,17 +1273,7 @@ EXPORT_SYMBOL_GPL(pinctrl_pm_select_sleep_state);
>    */
>   int pinctrl_pm_select_idle_state(struct device *dev)
>   {
> -	struct dev_pin_info *pins = dev->pins;
> -	int ret;
> -
> -	if (!pins)
> -		return 0;
> -	if (IS_ERR(pins->idle_state))
> -		return 0; /* No idle state */
> -	ret = pinctrl_select_state(pins->p, pins->idle_state);
> -	if (ret)
> -		dev_err(dev, "failed to activate pinctrl idle state\n");
> -	return ret;
here
if (!dev->pins)
	                return 0;
> +	return pinctrl_pm_select_state(dev, dev->pins->idle_state);
>   }
>   EXPORT_SYMBOL_GPL(pinctrl_pm_select_idle_state);
>   #endif
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


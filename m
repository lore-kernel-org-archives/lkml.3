Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab3CTRVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:21:31 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:49568 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab3CTRV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:21:28 -0400
Message-ID: <5149F013.6050301@free-electrons.com>
Date: Wed, 20 Mar 2013 18:21:23 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 09/10] clocksource: time-armada-370-xp: Divorce from
 local timer API
References: <1363198676-30417-1-git-send-email-sboyd@codeaurora.org> <1363198676-30417-10-git-send-email-sboyd@codeaurora.org> <5149ED53.5060002@free-electrons.com>
In-Reply-To: <5149ED53.5060002@free-electrons.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 06:09 PM, Gregory CLEMENT wrote:
> On 03/13/2013 07:17 PM, Stephen Boyd wrote:
>> Separate the armada 370xp local timers from the local timer API.
>> This will allow us to remove ARM local timer support in the near
>> future and makes this driver multi-architecture friendly.
> 
> At first view the code looks good, but when I applied your patch set on
> linux-next, build it and run it on a Armada XP based board (AX3 with 2 cores),
> it crashed:
> 
> Booting Linux on physical CPU 0x0
> Linux version 3.9.0-rc3-next-20130319-00010-g728b448 (gclement@FE-greg-laptop) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #153 SMP Wed Mar 20 17:58:57 CET 2013
> CPU: ARMv7 Processor [562f5842] revision 2 (ARMv7), cr=10c53c7d
> CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
> Machine: Marvell Armada 370/XP (Device Tree), model: PlatHome OpenBlocks AX3-4 board
> bootconsole [earlycon0] enabled
> Memory policy: ECC disabled, Data cache writealloc
> PERCPU: Embedded 7 pages/cpu @c22b0000 s7104 r8192 d13376 u32768
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 784912
> Kernel command line: console=ttyS0,115200 earlyprintk
> PID hash table entries: 4096 (order: 2, 16384 bytes)
> Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> __ex_table already sorted, skipping sort
> Memory: 3072MB = 3072MB total
> Memory: 3113520k/3113520k available, 32208k reserved, 2367488K highmem
> Virtual kernel memory layout:
>     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
>     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
>     vmalloc : 0xf0000000 - 0xff000000   ( 240 MB)
>     lowmem  : 0xc0000000 - 0xef800000   ( 760 MB)
>     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
>     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
>       .text : 0xc0008000 - 0xc041647c   (4154 kB)
>       .init : 0xc0417000 - 0xc0633bc0   (2163 kB)
>       .data : 0xc0634000 - 0xc06605c0   ( 178 kB)
>        .bss : 0xc06605c0 - 0xc0686a2c   ( 154 kB)
> Hierarchical RCU implementation.
>         RCU restricting CPUs from NR_CPUS=4 to nr_cpu_ids=2.
> NR_IRQS:16 nr_irqs:16 16
> Aurora cache controller enabled
> l2x0: 16 ways, CACHE_ID 0x00000100, AUX_CTRL 0x1a696b12, Cache size: 1048576 B
> sched_clock: 32 bits at 25MHz, resolution 40ns, wraps every 171798ms
> Console: colour dummy device 80x30
> Calibrating delay loop...
> Internal error: Oops - undefined instruction: 0 [#1] SMP ARM
> Modules linked in:
> CPU: 0    Not tainted  (3.9.0-rc3-next-20130319-00010-g728b448 #153)
> PC is at 0xe92d45f0
> LR is at armada_370_xp_timer_interrupt+0x3c/0x4c
> pc : [<e92d45f0>]    lr : [<c023c2bc>]    psr: 600001d3
> sp : c0635eb8  ip : 00000000  fp : c063c3f0
> r10: 000003ff  r9 : 00000000  r8 : 00000010
> r7 : c22b3c40  r6 : ef007c00  r5 : c0640fcc  r4 : c0053e30
> r3 : e92d45f0  r2 : fffffffe  r1 : c22b3c40  r0 : c0053e30
> Flags: nZCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
> Control: 10c53c7d  Table: 0000406a  DAC: 00000015
> Process swapper/0 (pid: 0, stack limit = 0xc0634238)
> Stack: (0xc0635eb8 to 0xc0636000)
> 5ea0:                                                       ef004c80 c0063224
> 5ec0: 00000010 00000010 00000000 c0660ac0 c0635f18 c005fcb8 c0632b90 c000ed94
> 5ee0: c0313c60 60000153 00000001 c00085a8 c0313c54 c0313c60 60000153 ffffffff
> 5f00: c0635f4c 00000000 562f5842 c06360c0 00000000 c000db60 0000001a ffff8ad0
> 5f20: ffff8ad0 c06360c0 00000000 00000000 c04379c0 c22ad780 00000000 562f5842
> 5f40: c06360c0 00000000 60000153 c0635f60 c0313c54 c0313c60 60000153 ffffffff
> 5f60: 00000021 00000000 00000003 00000004 0000006e c065fcc0 c067924c c063ceb8
> 5f80: c063cc84 c006d8c0 00000005 c065fcc0 c067924c c0421764 c22ad780 c063c42c
> 5fa0: 562f5842 c063cca8 c06605c0 c04379c0 c22ad780 00000000 562f5842 00000000
> 5fc0: 00000000 c0417754 ffffffff ffffffff c04172dc 00000000 00000000 c04379c0
> 5fe0: 10c53c7d c063c414 c04379bc c063febc 0000406a 00008074 00000000 00000000
> [<c023c2bc>] (armada_370_xp_timer_interrupt+0x3c/0x4c) from [<c0063224>] (handle_percpu_devid_irq+0x64/0x80)
> [<c0063224>] (handle_percpu_devid_irq+0x64/0x80) from [<c005fcb8>] (generic_handle_irq+0x20/0x30)
> [<c005fcb8>] (generic_handle_irq+0x20/0x30) from [<c000ed94>] (handle_IRQ+0x38/0x90)
> [<c000ed94>] (handle_IRQ+0x38/0x90) from [<c00085a8>] (armada_370_xp_handle_irq+0xa4/0xb0)
> [<c00085a8>] (armada_370_xp_handle_irq+0xa4/0xb0) from [<c000db60>] (__irq_svc+0x40/0x50)
> Exception stack(0xc0635f18 to 0xc0635f60)
> 5f00:                                                       0000001a ffff8ad0
> 5f20: ffff8ad0 c06360c0 00000000 00000000 c04379c0 c22ad780 00000000 562f5842
> 5f40: c06360c0 00000000 60000153 c0635f60 c0313c54 c0313c60 60000153 ffffffff
> [<c000db60>] (__irq_svc+0x40/0x50) from [<c0313c60>] (calibrate_delay+0x378/0x528)
> [<c0313c60>] (calibrate_delay+0x378/0x528) from [<c0417754>] (start_kernel+0x250/0x2dc)
> [<c0417754>] (start_kernel+0x250/0x2dc) from [<00008074>] (0x8074)
> Code: 1fe7deb7 cd5772dd fff5692e ed55f79e (7ed5a5f7)
> ---[ end trace 1b75b31a2719ed1c ]---
> Kernel panic - not syncing: Fatal exception in interrupt
> Internal error: Oops - undefined instruction: 0 [#2] SMP ARM
> Modules linked in:
> CPU: 0    Tainted: G      D       (3.9.0-rc3-next-20130319-00010-g728b448 #153)
> PC is at 0xe92d45f0
> LR is at armada_370_xp_timer_interrupt+0x3c/0x4c
> pc : [<e92d45f0>]    lr : [<c023c2bc>]    psr: 600001d3
> sp : c0635cc0  ip : 00000000  fp : c063c3f0
> r10: 000003ff  r9 : 00000000  r8 : 00000010
> r7 : c22b3c40  r6 : ef007c00  r5 : c0640fcc  r4 : c0053e30
> r3 : e92d45f0  r2 : fffffffe  r1 : c22b3c40  r0 : c0053e30
> Flags: nZCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
> Control: 10c53c7d  Table: 0000406a  DAC: 00000015
> Process swapper/0 (pid: 0, stack limit = 0xc0634238)
> Stack: (0xc0635cc0 to 0xc0636000)
> 5cc0: ef004c80 c0063224 00000010 00000010 c0635f18 c0660ac0 c0635d20 c005fcb8
> 5ce0: c0632b90 c000ed94 c0316d54 60000153 00000001 c00085a8 c0316ca4 c0316d54
> 5d00: 60000153 ffffffff c0635d54 c03a53b0 00000000 c0660b70 600001d3 c000db60
> 5d20: c0660fc0 00000000 c0642f80 00000000 00000000 00000000 0000000b c06400e0
> 5d40: c03a53b0 00000000 c0660b70 600001d3 00000000 c0635d68 c0316ca4 c0316d54
> 5d60: 60000153 ffffffff 600001d3 c0635d94 c06608c0 c0634000 0000000b c06400e0
> 5d80: c03a53b0 00000000 c063f180 c0011624 c03a5310 200001d3 c0642f80 00010000
> 5da0: c0634238 0000000b 00100100 c0635e70 e92d45f0 7ed5a5f7 00000001 00000500
> 5dc0: c000dbcc c0634000 c063c3f0 c00082a0 00000006 c22b0768 00000004 00000000
> 5de0: 00030001 e92d45f0 ffffffff 00000001 c22b076c 00000000 c065fa1c c065f9c0
> 5e00: 00100100 00000002 c065f9c0 00000000 c063cca0 00000000 00000002 c065f9c0
> 5e20: c0661ca4 c06618e6 00000041 00000002 0000000a 00000002 ffffffff 00000000
> 5e40: 00000000 00000000 00000000 00000000 c06602cc 00000000 c00146d4 e92d45f4
> 5e60: 600001d3 c0634050 00000001 c000dbcc c0053e30 c22b3c40 fffffffe e92d45f0
> 5e80: c0053e30 c0640fcc ef007c00 c22b3c40 00000010 00000000 000003ff c063c3f0
> 5ea0: 00000000 c0635eb8 c023c2bc e92d45f0 600001d3 ffffffff ef004c80 c0063224
> 5ec0: 00000010 00000010 00000000 c0660ac0 c0635f18 c005fcb8 c0632b90 c000ed94
> 5ee0: c0313c60 60000153 00000001 c00085a8 c0313c54 c0313c60 60000153 ffffffff
> 5f00: c0635f4c 00000000 562f5842 c06360c0 00000000 c000db60 0000001a ffff8ad0
> 5f20: ffff8ad0 c06360c0 00000000 00000000 c04379c0 c22ad780 00000000 562f5842
> 5f40: c06360c0 00000000 60000153 c0635f60 c0313c54 c0313c60 60000153 ffffffff
> 5f60: 00000021 00000000 00000003 00000004 0000006e c065fcc0 c067924c c063ceb8
> 5f80: c063cc84 c006d8c0 00000005 c065fcc0 c067924c c0421764 c22ad780 c063c42c
> 5fa0: 562f5842 c063cca8 c06605c0 c04379c0 c22ad780 00000000 562f5842 00000000
> 5fc0: 00000000 c0417754 ffffffff ffffffff c04172dc 00000000 00000000 c04379c0
> 5fe0: 10c53c7d c063c414 c04379bc c063febc 0000406a 00008074 00000000 00000000
> [<c023c2bc>] (armada_370_xp_timer_interrupt+0x3c/0x4c) from [<c0063224>] (handle_percpu_devid_irq+0x64/0x80)
> [<c0063224>] (handle_percpu_devid_irq+0x64/0x80) from [<c005fcb8>] (generic_handle_irq+0x20/0x30)
> [<c005fcb8>] (generic_handle_irq+0x20/0x30) from [<c000ed94>] (handle_IRQ+0x38/0x90)
> [<c000ed94>] (handle_IRQ+0x38/0x90) from [<c00085a8>] (armada_370_xp_handle_irq+0xa4/0xb0)
> [<c00085a8>] (armada_370_xp_handle_irq+0xa4/0xb0) from [<c000db60>] (__irq_svc+0x40/0x50)
> Exception stack(0xc0635d20 to 0xc0635d68)
> 5d20: c0660fc0 00000000 c0642f80 00000000 00000000 00000000 0000000b c06400e0
> 5d40: c03a53b0 00000000 c0660b70 600001d3 00000000 c0635d68 c0316ca4 c0316d54
> 5d60: 60000153 ffffffff
> [<c000db60>] (__irq_svc+0x40/0x50) from [<c0316d54>] (panic+0x144/0x1b0)
> [<c0316d54>] (panic+0x144/0x1b0) from [<c0011624>] (die+0x278/0x2a8)
> [<c0011624>] (die+0x278/0x2a8) from [<c00082a0>] (do_undefinstr+0x9c/0x1c4)
> [<c00082a0>] (do_undefinstr+0x9c/0x1c4) from [<c000dbcc>] (__und_svc_finish+0x0/0x14)
> Exception stack(0xc0635e70 to 0xc0635eb8)
> 5e60:                                     c0053e30 c22b3c40 fffffffe e92d45f0
> 5e80: c0053e30 c0640fcc ef007c00 c22b3c40 00000010 00000000 000003ff c063c3f0
> 5ea0: 00000000 c0635eb8 c023c2bc e92d45f0 600001d3 ffffffff
> [<c000dbcc>] (__und_svc_finish+0x0/0x14) from [<e92d45f0>] (0xe92d45f0)
> Code: 1fe7deb7 cd5772dd fff5692e ed55f79e (7ed5a5f7)
> ---[ end trace 1b75b31a2719ed1d ]---
> 
> 
> I am trying to figure out what happened.

Ok I found it, you forgot to also change the indirection in interrupt handler,
if you add the following chunk to your patch, it fixes the issue:


--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -150,7 +150,7 @@ static irqreturn_t armada_370_xp_timer_interrupt(int irq, void *dev_id)
        /*
         * ACK timer interrupt and call event handler.
         */
-       struct clock_event_device *evt = *(struct clock_event_device **)dev_id;
+       struct clock_event_device *evt = (struct clock_event_device *)dev_id;

        writel(TIMER0_CLR_MASK, local_base + LCL_TIMER_EVENTS_STATUS);
        evt->event_handler(evt);


> 
> 
>>
>> Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>  drivers/clocksource/time-armada-370-xp.c | 85 ++++++++++++++------------------
>>  1 file changed, 38 insertions(+), 47 deletions(-)
>>
>> diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
>> index efe4aef..ee2e50c5 100644
>> --- a/drivers/clocksource/time-armada-370-xp.c
>> +++ b/drivers/clocksource/time-armada-370-xp.c
>> @@ -19,6 +19,7 @@
>>  #include <linux/platform_device.h>
>>  #include <linux/kernel.h>
>>  #include <linux/clk.h>
>> +#include <linux/cpu.h>
>>  #include <linux/timer.h>
>>  #include <linux/clockchips.h>
>>  #include <linux/interrupt.h>
>> @@ -31,7 +32,6 @@
>>  #include <linux/time-armada-370-xp.h>
>>  
>>  #include <asm/sched_clock.h>
>> -#include <asm/localtimer.h>
>>  /*
>>   * Timer block registers.
>>   */
>> @@ -70,7 +70,7 @@ static bool timer25Mhz = true;
>>   */
>>  static u32 ticks_per_jiffy;
>>  
>> -static struct clock_event_device __percpu **percpu_armada_370_xp_evt;
>> +static struct clock_event_device __percpu *armada_370_xp_evt;
>>  
>>  static u32 notrace armada_370_xp_read_sched_clock(void)
>>  {
>> @@ -143,14 +143,7 @@ armada_370_xp_clkevt_mode(enum clock_event_mode mode,
>>  	}
>>  }
>>  
>> -static struct clock_event_device armada_370_xp_clkevt = {
>> -	.name		= "armada_370_xp_per_cpu_tick",
>> -	.features	= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC,
>> -	.shift		= 32,
>> -	.rating		= 300,
>> -	.set_next_event	= armada_370_xp_clkevt_next_event,
>> -	.set_mode	= armada_370_xp_clkevt_mode,
>> -};
>> +static int armada_370_xp_clkevt_irq;
>>  
>>  static irqreturn_t armada_370_xp_timer_interrupt(int irq, void *dev_id)
>>  {
>> @@ -173,42 +166,53 @@ static int __cpuinit armada_370_xp_timer_setup(struct clock_event_device *evt)
>>  	u32 u;
>>  	int cpu = smp_processor_id();
>>  
>> -	/* Use existing clock_event for cpu 0 */
>> -	if (!smp_processor_id())
>> -		return 0;
>> -
>>  	u = readl(local_base + TIMER_CTRL_OFF);
>>  	if (timer25Mhz)
>>  		writel(u | TIMER0_25MHZ, local_base + TIMER_CTRL_OFF);
>>  	else
>>  		writel(u & ~TIMER0_25MHZ, local_base + TIMER_CTRL_OFF);
>>  
>> -	evt->name		= armada_370_xp_clkevt.name;
>> -	evt->irq		= armada_370_xp_clkevt.irq;
>> -	evt->features		= armada_370_xp_clkevt.features;
>> -	evt->shift		= armada_370_xp_clkevt.shift;
>> -	evt->rating		= armada_370_xp_clkevt.rating,
>> +	evt->name		= "armada_370_xp_per_cpu_tick",
>> +	evt->features		= CLOCK_EVT_FEAT_ONESHOT |
>> +				  CLOCK_EVT_FEAT_PERIODIC;
>> +	evt->shift		= 32,
>> +	evt->rating		= 300,
>>  	evt->set_next_event	= armada_370_xp_clkevt_next_event,
>>  	evt->set_mode		= armada_370_xp_clkevt_mode,
>> +	evt->irq		= armada_370_xp_clkevt_irq;
>>  	evt->cpumask		= cpumask_of(cpu);
>>  
>> -	*__this_cpu_ptr(percpu_armada_370_xp_evt) = evt;
>> -
>>  	clockevents_config_and_register(evt, timer_clk, 1, 0xfffffffe);
>>  	enable_percpu_irq(evt->irq, 0);
>>  
>>  	return 0;
>>  }
>>  
>> -static void  armada_370_xp_timer_stop(struct clock_event_device *evt)
>> +static void __cpuinit armada_370_xp_timer_stop(struct clock_event_device *evt)
>>  {
>>  	evt->set_mode(CLOCK_EVT_MODE_UNUSED, evt);
>>  	disable_percpu_irq(evt->irq);
>>  }
>>  
>> -static struct local_timer_ops armada_370_xp_local_timer_ops __cpuinitdata = {
>> -	.setup	= armada_370_xp_timer_setup,
>> -	.stop	=  armada_370_xp_timer_stop,
>> +static int __cpuinit armada_370_xp_timer_cpu_notify(struct notifier_block *self,
>> +					   unsigned long action, void *hcpu)
>> +{
>> +	struct clock_event_device *evt = this_cpu_ptr(armada_370_xp_evt);
>> +
>> +	switch (action & ~CPU_TASKS_FROZEN) {
>> +	case CPU_STARTING:
>> +		armada_370_xp_timer_setup(evt);
>> +		break;
>> +	case CPU_DYING:
>> +		armada_370_xp_timer_stop(evt);
>> +		break;
>> +	}
>> +
>> +	return NOTIFY_OK;
>> +}
>> +
>> +static struct notifier_block armada_370_xp_timer_cpu_nb __cpuinitdata = {
>> +	.notifier_call = armada_370_xp_timer_cpu_notify,
>>  };
>>  
>>  void __init armada_370_xp_timer_init(void)
>> @@ -224,9 +228,6 @@ void __init armada_370_xp_timer_init(void)
>>  
>>  	if (of_find_property(np, "marvell,timer-25Mhz", NULL)) {
>>  		/* The fixed 25MHz timer is available so let's use it */
>> -		u = readl(local_base + TIMER_CTRL_OFF);
>> -		writel(u | TIMER0_25MHZ,
>> -		       local_base + TIMER_CTRL_OFF);
>>  		u = readl(timer_base + TIMER_CTRL_OFF);
>>  		writel(u | TIMER0_25MHZ,
>>  		       timer_base + TIMER_CTRL_OFF);
>> @@ -236,9 +237,6 @@ void __init armada_370_xp_timer_init(void)
>>  		struct clk *clk = of_clk_get(np, 0);
>>  		WARN_ON(IS_ERR(clk));
>>  		rate =  clk_get_rate(clk);
>> -		u = readl(local_base + TIMER_CTRL_OFF);
>> -		writel(u & ~(TIMER0_25MHZ),
>> -		       local_base + TIMER_CTRL_OFF);
>>  
>>  		u = readl(timer_base + TIMER_CTRL_OFF);
>>  		writel(u & ~(TIMER0_25MHZ),
>> @@ -252,7 +250,7 @@ void __init armada_370_xp_timer_init(void)
>>  	 * We use timer 0 as clocksource, and private(local) timer 0
>>  	 * for clockevents
>>  	 */
>> -	armada_370_xp_clkevt.irq = irq_of_parse_and_map(np, 4);
>> +	armada_370_xp_clkevt_irq = irq_of_parse_and_map(np, 4);
>>  
>>  	ticks_per_jiffy = (timer_clk + HZ / 2) / HZ;
>>  
>> @@ -277,26 +275,19 @@ void __init armada_370_xp_timer_init(void)
>>  			      "armada_370_xp_clocksource",
>>  			      timer_clk, 300, 32, clocksource_mmio_readl_down);
>>  
>> -	/* Register the clockevent on the private timer of CPU 0 */
>> -	armada_370_xp_clkevt.cpumask = cpumask_of(0);
>> -	clockevents_config_and_register(&armada_370_xp_clkevt,
>> -					timer_clk, 1, 0xfffffffe);
>> +	register_cpu_notifier(&armada_370_xp_timer_cpu_nb);
>>  
>> -	percpu_armada_370_xp_evt = alloc_percpu(struct clock_event_device *);
>> +	armada_370_xp_evt = alloc_percpu(struct clock_event_device);
>>  
>>  
>>  	/*
>>  	 * Setup clockevent timer (interrupt-driven).
>>  	 */
>> -	*__this_cpu_ptr(percpu_armada_370_xp_evt) = &armada_370_xp_clkevt;
>> -	res = request_percpu_irq(armada_370_xp_clkevt.irq,
>> +	res = request_percpu_irq(armada_370_xp_clkevt_irq,
>>  				armada_370_xp_timer_interrupt,
>> -				armada_370_xp_clkevt.name,
>> -				percpu_armada_370_xp_evt);
>> -	if (!res) {
>> -		enable_percpu_irq(armada_370_xp_clkevt.irq, 0);
>> -#ifdef CONFIG_LOCAL_TIMERS
>> -		local_timer_register(&armada_370_xp_local_timer_ops);
>> -#endif
>> -	}
>> +				"armada_370_xp_per_cpu_tick",
>> +				armada_370_xp_evt);
>> +	/* Immediately configure the timer on the boot CPU */
>> +	if (!res)
>> +		armada_370_xp_timer_setup(this_cpu_ptr(armada_370_xp_evt));
>>  }
>>
> 
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com

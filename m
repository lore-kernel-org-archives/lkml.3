Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaIBPMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:12:49 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40623 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbaIBPMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:12:46 -0400
Message-ID: <5405DE71.4000103@wwwdotorg.org>
Date: Tue, 02 Sep 2014 09:12:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sahara <kpark3469@gmail.com>
CC: Thierry Reding <thierry.reding@gmail.com>, akpm@linux-foundation.org,
        keun-o.park@windriver.com, hpa@zytor.com, rafael.j.wysocki@intel.com,
        peterz@infradead.org, rusty@rustcorp.com.au,
        kirill.shutemov@linux.intel.com, oleg@redhat.com, prarit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] earlyprintk: re-enable earlyprintk calling early_param
References: <1408011216-8621-1-git-send-email-kpark3469@gmail.com> <20140827151504.GA22824@ulmo> <alpine.DEB.2.02.1408291216350.5912@SEL-KPARK-D2> <5400A2BD.8080508@wwwdotorg.org> <alpine.DEB.2.02.1409011115530.14117@SEL-KPARK-D2>
In-Reply-To: <alpine.DEB.2.02.1409011115530.14117@SEL-KPARK-D2>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2014 08:28 PM, Sahara wrote:
>
>
> On Fri, 29 Aug 2014, Stephen Warren wrote:
>
>> On 08/28/2014 11:28 PM, Sahara wrote:
>>>
>>>
>>> On Wed, 27 Aug 2014, Thierry Reding wrote:
>>>
>>>> On Thu, Aug 14, 2014 at 07:13:36PM +0900, kpark3469@gmail.com wrote:
>>>>> From: Sahara <keun-o.park@windriver.com>
>>>>>
>>>>> Although there are many obs_kernel_param and its names are
>>>>> earlyprintk and also EARLY_PRINTK is also enabled, we could not
>>>>> see the early_printk output properly until now. This patch
>>>>> considers earlycon as well as earlyprintk.
>>>>>
>>>>> Signed-off-by: Sahara <keun-o.park@windriver.com>
>>>>> ---
>>>>>  init/main.c |    3 ++-
>>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/init/main.c b/init/main.c
>>>>> index bb1aed9..235d248 100644
>>>>> --- a/init/main.c
>>>>> +++ b/init/main.c
>>>>> @@ -426,7 +426,8 @@ static int __init do_early_param(char *param, char
>>> *val, const char *unused)
>>>>>      for (p = __setup_start; p < __setup_end; p++) {
>>>>>          if ((p->early && parameq(param, p->str)) ||
>>>>>              (strcmp(param, "console") == 0 &&
>>>>> -             strcmp(p->str, "earlycon") == 0)
>>>>> +             ((strcmp(p->str, "earlycon") == 0) ||
>>>>> +             (strcmp(p->str, "earlyprintk") == 0)))
>>>>>          ) {
>>>>>              if (p->setup_func(val) != 0)
>>>>>                  pr_warn("Malformed early option '%s'\n",
>>> param);
>>>>
>>>> It seems like this patch causes the following warning for me during
>>>> boot:
>>>>
>>>> [    0.000000] Booting Linux on physical CPU 0x0
>>>> [    0.000000] Initializing cgroup subsys cpu
>>>> [    0.000000] Initializing cgroup subsys cpuacct
>>>> [    0.000000] Linux version 3.17.0-rc2-next-20140827
>>> (thierry.reding@ulmo) (gcc version 4.9.0 (GCC) ) #18 SMP PREEMPT Wed Aug
>>> 27 17:08:12 CEST 2014
>>>> [    0.000000] CPU: ARMv7 Processor [413fc0f3] revision 3 (ARMv7),
>>> cr=10c5387d
>>>> [    0.000000] CPU: PIPT / VIPT nonaliasing data cache, PIPT
>>>> instruction
>>> cache
>>>> [    0.000000] Machine model: NVIDIA Tegra124 Jetson TK1
>>>> [    0.000000] bootconsole [earlycon0] enabled
>>>> [    0.000000] debug: ignoring loglevel setting.
>>>> [    0.000000] ------------[ cut here ]------------
>>>> [    0.000000] WARNING: CPU: 0 PID: 0 at
>>> /home/thierry.reding/src/kernel/linux-work.git/kernel/printk/printk.c:2402
>>>
>>> register_console+0x60/0x37c()
>>>> [    0.000000] console 'earlycon0' already registered
>>>> [    0.000000] Modules linked in:
>>>> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted
>>> 3.17.0-rc2-next-20140827 #18
>>>> [    0.000000] [<c0015fec>] (unwind_backtrace) from [<c0011aac>]
>>> (show_stack+0x10/0x14)
>>>> [    0.000000] [<c0011aac>] (show_stack) from [<c062b700>]
>>> (dump_stack+0x98/0xd8)
>>>> [    0.000000] [<c062b700>] (dump_stack) from [<c0025ba0>]
>>> (warn_slowpath_common+0x70/0x8c)
>>>> [    0.000000] [<c0025ba0>] (warn_slowpath_common) from [<c0025bec>]
>>> (warn_slowpath_fmt+0x30/0x40)
>>>> [    0.000000] [<c0025bec>] (warn_slowpath_fmt) from [<c00639b8>]
>>> (register_console+0x60/0x37c)
>>>> [    0.000000] [<c00639b8>] (register_console) from [<c0883870>]
>>> (setup_early_printk+0x20/0x28)
>>>> [    0.000000] [<c0883870>] (setup_early_printk) from [<c087f43c>]
>>> (do_early_param+0x6c/0xd0)
>>>> [    0.000000] [<c087f43c>] (do_early_param) from [<c003cba0>]
>>> (parse_args+0x238/0x3d0)
>>>> [    0.000000] [<c003cba0>] (parse_args) from [<c087f814>]
>>> (parse_early_options+0x38/0x40)
>>>> [    0.000000] [<c087f814>] (parse_early_options) from [<c087f84c>]
>>> (parse_early_param+0x30/0x40)
>>>> [    0.000000] [<c087f84c>] (parse_early_param) from [<c088206c>]
>>> (setup_arch+0x4b4/0x974)
>>>> [    0.000000] [<c088206c>] (setup_arch) from [<c087f8f8>]
>>> (start_kernel+0x98/0x3a8)
>>>> [    0.000000] [<c087f8f8>] (start_kernel) from [<80008074>]
>>> (0x80008074)
>>>> [    0.000000] ---[ end trace cb88537fdc8fa200 ]---
>>>> [    0.000000] cma: Reserved 128 MiB at a7800000
>>>> [    0.000000] Memory policy: Data cache writealloc
>>>> [    0.000000] On node 0 totalpages: 524032
>>>> [    0.000000] free_area_init_node: node 0, pgdat c091cc00,
>>>> node_mem_map
>>> e67b7000
>>>> [    0.000000]   Normal zone: 1520 pages used for memmap
>>>> [    0.000000]   Normal zone: 0 pages reserved
>>>> [    0.000000]   Normal zone: 194560 pages, LIFO batch:31
>>>> [    0.000000]   HighMem zone: 2574 pages used for memmap
>>>> [    0.000000]   HighMem zone: 329472 pages, LIFO batch:31
>>>> [    0.000000] PERCPU: Embedded 8 pages/cpu @e6767000 s8832 r8192
>>>> d15744
>>> u32768
>>>> [    0.000000] pcpu-alloc: s8832 r8192 d15744 u32768 alloc=8*4096
>>>> [    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3
>>>> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
>>> Total pages: 522512
>>>> [    0.000000] Kernel command line: console=ttyS0,115200n8
>>> ignore_loglevel rootwait ro earlyprintk ip=:::::eth0:dhcp root=/dev/nfs
>>> nfsroot=192.168.69.100:/srv/nfs/tegra124 drm.debug=0xf cma=128M
>>>>
>>>> Reverting the patch eliminates the warning. earlyprintk does work fine
>>>> for me without this patch.
>>>>
>>>> Thierry
>>>
>>>
>>> This warning message is caused by specifying 'earlyprintk' in
>>> your command line args. Same problem may happen if you specify
>>> 'earlycon'
>>> in your command line args and enable CONFIG_SERIAL_EARLYCON with
>>> the current code without this patch. I think it's appropriate result
>>> letting a developer know that both ways of using earlyprintk are
>>> enabled.
>>> With current code, although a developer enables CONFIG_EARLY_PRINTK and
>>> has "console=" arg in command line args, he/she should specify the
>>> 'earlyprintk' in command line args also to see early_printk() outputs.
>>> With this patch, simply enabling CONFIG_EARLY_PRINTK and having
>>> 'console='
>>> line make you be able to the early_printk().
>>>
>>> Nonetheless I want to retract this patch. It's good for ARM, but not
>>> good
>>> for other architectures such as x86. And, because CONFIG_EARLY_PRINTK is
>>> depending on DEBUG_LL in ARM, making a relation with "console=" is
>>> absurd.
>>> (see strcmp(param, "console") == 0 && strcmp(p->str, "earlyprintk")
>>> == 0)
>>
>> Even on ARM, this patch feels like the wrong thing. After all, I can
>> build a DEBUG_LL enabled multi-platform kernel, and boot it on a bunch
>> of different SoCs. However, earlyprintk will only work on one (or
>> zero) of those SoCs, and hence shouldn't automatically enable itself;
>> specifically requesting activation using the earlyprintk kernel
>> command-line parameter is the correct approach.
>>
>
> So you are saying, because DEBUG_LL didn't work on several SoCs, using the
> earlyprintk in command line args is the correct approach?

No, I'm saying: Kconfig options DEBUG_LL/CONFIG_EARLY_PRINTK add code 
into the kernel. The earlyprintk command-line option activates the early 
printk feature at run-time.

> You are misunderstanding how it works. On ARM with enabling multi-platform
> kernel, you should choose a specific low-level debug port for DEBUG_LL.

Actually, I am well aware of how the feature works and use it daily.

> For example, if you have OMAP ZOOM3, you should select
> CONFIG_DEBUG_ZOOM_UART from menu.
> If you chose a right port for your SoCs and if it didn't work properly,
> that means its port code should be fixed. (Please report it.)

Everything works fine for me, at least on Tegra, for both Tegra-specific 
and IIRC also for multi-platform kernels (although I don't use those often).

> All the code for low-level debugging is located at arch/arm/include/debug.

I know.

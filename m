Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab3FCCTl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 22:19:41 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:40897 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab3FCCTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 22:19:34 -0400
MIME-Version: 1.0
In-Reply-To: <1369993501-24309-1-git-send-email-srinivas.kandagatla@st.com>
References: <1369993439-24216-1-git-send-email-srinivas.kandagatla@st.com> <1369993501-24309-1-git-send-email-srinivas.kandagatla@st.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 3 Jun 2013 10:19:13 +0800
Message-ID: <CAGsJ_4xqGZVL7ZsYx1gpeUVoQan4hn=05_v51Kar78Vdkz0hig@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] ARM:prima2: move sirfsoc_of_rstc_init to .init_early
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: Barry Song <baohua.song@csr.com>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Srinivas,

2013/5/31 Srinivas KANDAGATLA <srinivas.kandagatla@st.com>:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>
> This patch moves sirfsoc_of_rstc_init from early_initcall to .init_early
> in machine descriptor, doing this way a multi_v7 kernel will not crash
> on non-prima2 SOCs.
>
> Without this patch the multi_v7 kernel panics if we boot it on any non
> prima2 parts with below log:
>
> Kernel panic - not syncing: unable to find compatible rstc node in dtb
>
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc3-00535-gc3cc4ac #62
> [<c001387c>] (unwind_backtrace+0x0/0xf8) from [<c00111cc>]
> (show_stack+0x10/0x14)
> [<c00111cc>] (show_stack+0x10/0x14) from [<c03417f4>] (panic+0x90/0x1e4)
> [<c03417f4>] (panic+0x90/0x1e4) from [<c04256d0>]
> (sirfsoc_of_rstc_init+0x24/0x5c)
> [<c04256d0>] (sirfsoc_of_rstc_init+0x24/0x5c) from [<c041f854>]
> (do_one_initcall+0x90/0x150)
> [<c041f854>] (do_one_initcall+0x90/0x150) from [<c041f978>]
> (kernel_init_freeable+0x64/0x1c4)
> [<c041f978>] (kernel_init_freeable+0x64/0x1c4) from [<c033d344>]
> (kernel_init+0x8/0xe4)
> [<c033d344>] (kernel_init+0x8/0xe4) from [<c000ded8>]
> (ret_from_fork+0x14/0x3c)
>
> Initially detected when booting Stih415 SOC with multi_v7_defconfig.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> ---

this broke SiRF by:
Uncompressing Linux... done, booting the kernel.
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.10.0-rc2-00723-gd1a0472-dirty
(barry@barry-laptop) (gcc version 4.5.4 20110505 (prerelease)
(Ubuntu/Linaro 4.5-2011.5-csr-build) ) #35 SMP PREEMPT Mon Jun 3
09:51:59 CST 2013
[    0.000000] CPU: ARMv7 Processor [413fc090] revision 0 (ARMv7), cr=10c53c7d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing
instruction cache
[    0.000000] Machine: Generic ATLAS6 (Flattened Device Tree), model:
CSR SiRFatlas6 Evaluation Board
[    0.000000] bootconsole [earlycon0] enabled
[    0.000000] Memory policy: ECC disabled, Data cache writealloc
[    0.000000] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[    0.000000] pgd = c0004000
[    0.000000] [00000000] *pgd=00000000
[    0.000000] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted
3.10.0-rc2-00723-gd1a0472-dirty #35
[    0.000000] task: c05cfb40 ti: c05c4000 task.ti: c05c4000
[    0.000000] PC is at kmem_cache_alloc+0x2c/0x124
[    0.000000] LR is at __get_vm_area_node.clone.26+0x7c/0x190
[    0.000000] pc : [<c00bf338>]    lr : [<c00b2b88>]    psr: 200001d3
[    0.000000] sp : c05c5ec8  ip : c05c4000  fp : 00000000
[    0.000000] r10: 00000000  r9 : 00001000  r8 : c00b2b88
[    0.000000] r7 : 00002000  r6 : c05c4000  r5 : 000080d0  r4 : 00000000
[    0.000000] r3 : 40000002  r2 : 00000001  r1 : 000080d0  r0 : 00000000
[    0.000000] Flags: nzCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM
Segment kernel
[    0.000000] Control: 10c53c7d  Table: 0000404a  DAC: 00000015
[    0.000000] Process swapper (pid: 0, stack limit = 0xc05c4238)
[    0.000000] Stack: (0xc05c5ec8 to 0xc05c6000)
[    0.000000] 5ec0:                   c0613948 c05c5ef0 00000001
000000d0 00002000 c027255c
[    0.000000] 5ee0: 00001000 d0800000 00000000 c00b2b88 00000001
c040d90c 00088010 00000000
[    0.000000] 5f00: 88010000 00001000 c05d1924 88010fff 00000000
c00b32ec ff000000 000000d0
[    0.000000] 5f20: c027255c 00000000 c05d18fc c001a3f4 c027255c
00000000 c04788e0 c045b7a0
[    0.000000] 5f40: c0008000 413fc090 c05c5fe4 c001a4dc c027255c
c082b0ac c04788e0 c05d1a68
[    0.000000] 5f60: c082b0ac c001a1c4 00000000 c027255c c05d1a90
88010000 88010fff c082b0e8
[    0.000000] 5f80: 00000200 00000000 00000000 00000000 c045b7a0
c0462d9c c0477620 c05cf880
[    0.000000] 5fa0: c04788e0 c045f2f4 00000000 c05c5fc4 00000000
c05c4000 00000001 00000000
[    0.000000] 5fc0: c05d0984 0000406a 00000000 c045c628 00000000
00000000 00000000 00000000
[    0.000000] 5fe0: 00000000 c04788e0 10c53c7d c05cd3b4 c04788dc
00008074 00000000 00000000
[    0.000000] [<c00bf338>] (kmem_cache_alloc+0x2c/0x124) from
[<c00b2b88>] (__get_vm_area_node.clone.26+0x7c/0x190)
[    0.000000] [<c00b2b88>] (__get_vm_area_node.clone.26+0x7c/0x190)
from [<c00b32ec>] (get_vm_area_caller+0x44/0x4c)
[    0.000000] [<c00b32ec>] (get_vm_area_caller+0x44/0x4c) from
[<c001a3f4>] (__arm_ioremap_pfn_caller+0x124/0x1a0)
[    0.000000] [<c001a3f4>] (__arm_ioremap_pfn_caller+0x124/0x1a0)
from [<c001a4dc>] (__arm_ioremap_caller+0x54/0x5c)
[    0.000000] [<c001a4dc>] (__arm_ioremap_caller+0x54/0x5c) from
[<c001a1c4>] (__arm_ioremap+0x18/0x1c)
[    0.000000] [<c001a1c4>] (__arm_ioremap+0x18/0x1c) from
[<c027255c>] (of_iomap+0x2c/0x34)
[    0.000000] [<c027255c>] (of_iomap+0x2c/0x34) from [<c0462d9c>]
(sirfsoc_of_rstc_init+0x38/0x68)
[    0.000000] [<c0462d9c>] (sirfsoc_of_rstc_init+0x38/0x68) from
[<c045f2f4>] (setup_arch+0x19c/0x1a8)
[    0.000000] [<c045f2f4>] (setup_arch+0x19c/0x1a8) from [<c045c628>]
(start_kernel+0x7c/0x2b4)
[    0.000000] [<c045c628>] (start_kernel+0x7c/0x2b4) from [<00008074>] (0x8074)
[    0.000000] Code: ee1daf90 e5963004 e2833001 e5863004 (e5947000)
[    0.000000] ---[ end trace 1b75b31a2719ed1c ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!

>  arch/arm/mach-prima2/common.c |    3 +++
>  arch/arm/mach-prima2/common.h |    1 +
>  arch/arm/mach-prima2/rstc.c   |    5 +----
>  3 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/mach-prima2/common.c b/arch/arm/mach-prima2/common.c
> index 4f94cd8..9aefcd6 100644
> --- a/arch/arm/mach-prima2/common.c
> +++ b/arch/arm/mach-prima2/common.c
> @@ -61,6 +61,7 @@ DT_MACHINE_START(ATLAS6_DT, "Generic ATLAS6 (Flattened Device Tree)")
>         .init_late      = sirfsoc_init_late,
>         .dt_compat      = atlas6_dt_match,
>         .restart        = sirfsoc_restart,
> +       .init_early     = sirfsoc_of_rstc_init,
>  MACHINE_END
>  #endif
>
> @@ -81,6 +82,7 @@ DT_MACHINE_START(PRIMA2_DT, "Generic PRIMA2 (Flattened Device Tree)")
>         .init_late      = sirfsoc_init_late,
>         .dt_compat      = prima2_dt_match,
>         .restart        = sirfsoc_restart,
> +       .init_early     = sirfsoc_of_rstc_init,
>  MACHINE_END
>  #endif
>
> @@ -100,5 +102,6 @@ DT_MACHINE_START(MARCO_DT, "Generic MARCO (Flattened Device Tree)")
>         .init_late      = sirfsoc_init_late,
>         .dt_compat      = marco_dt_match,
>         .restart        = sirfsoc_restart,
> +       .init_early     = sirfsoc_of_rstc_init,
>  MACHINE_END
>  #endif
> diff --git a/arch/arm/mach-prima2/common.h b/arch/arm/mach-prima2/common.h
> index 81135cd..65703a4 100644
> --- a/arch/arm/mach-prima2/common.h
> +++ b/arch/arm/mach-prima2/common.h
> @@ -20,6 +20,7 @@ extern struct smp_operations   sirfsoc_smp_ops;
>  extern void sirfsoc_secondary_startup(void);
>  extern void sirfsoc_cpu_die(unsigned int cpu);
>
> +extern void sirfsoc_of_rstc_init(void);
>  extern void __init sirfsoc_of_irq_init(void);
>  extern void __init sirfsoc_of_clk_init(void);
>  extern void sirfsoc_restart(char, const char *);
> diff --git a/arch/arm/mach-prima2/rstc.c b/arch/arm/mach-prima2/rstc.c
> index 435019c..5506425 100644
> --- a/arch/arm/mach-prima2/rstc.c
> +++ b/arch/arm/mach-prima2/rstc.c
> @@ -23,7 +23,7 @@ static struct of_device_id rstc_ids[]  = {
>         {},
>  };
>
> -static int __init sirfsoc_of_rstc_init(void)
> +void sirfsoc_of_rstc_init(void)
>  {
>         struct device_node *np;
>
> @@ -36,10 +36,7 @@ static int __init sirfsoc_of_rstc_init(void)
>                 panic("unable to map rstc cpu registers\n");
>
>         of_node_put(np);
> -
> -       return 0;
>  }
> -early_initcall(sirfsoc_of_rstc_init);
>
>  int sirfsoc_reset_device(struct device *dev)
>  {
> --
> 1.7.6.5
>

-barry

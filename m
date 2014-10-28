Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbaJ1R6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:58:54 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58648 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaJ1R6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:58:52 -0400
Date: Tue, 28 Oct 2014 10:58:50 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Jacob Bramley <jacob.bramley@arm.com>,
        Kyrylo Tkachov <kyrylo.tkachov@arm.com>
Subject: Re: [RFC/PATCH] ARM: Expose cpuid registers to userspace
Message-ID: <20141028175850.GF12469@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414459152-32425-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding some Ccs.

On 10/27, Stephen Boyd wrote:
> Exporting all the different possible configurations of CPUID
> registers to userspace via hwcaps is going to explode the hwcaps.
> Emulate userspace cpuid register accesses and export a new
> "cpuid" hwcap instead so that userspace can know to try to
> read the cpuid registers itself.
> 
> Cc: Måns Rullgård <mans@mansr.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> 
> This is in response to Will's suggestion[1] that we explore exposing
> these cpuid registers to userspace. A simple test program is as follows:
> 
>   #include <stdio.h>
>   
>   int main(void)
>   {
>   	int val;
>   
>   	__asm__ volatile ("mrc p15, 0, %0, c0, c1, 0\n" : "=r" (val));
>   	fprintf(stderr, "mrc p15, 0, rX, c0, c1, 0 is %#x\n", val);
>   	__asm__ volatile ("mrc p15, 0, %0, c0, c1, 1\n" : "=r" (val));
>   	fprintf(stderr, "mrc p15, 0, rX, c0, c1, 1 is %#x\n", val);
>   	__asm__ volatile ("mrc p15, 0, %0, c0, c1, 2\n" : "=r" (val));
>   	fprintf(stderr, "mrc p15, 0, rX, c0, c1, 2 is %#x\n", val);
>   	__asm__ volatile ("mrc p15, 0, %0, c0, c1, 3\n" : "=r" (val));
>   	fprintf(stderr, "mrc p15, 0, rX, c0, c1, 3 is %#x\n", val);
>   	__asm__ volatile ("mrc p15, 0, %0, c0, c1, 4\n" : "=r" (val));
>   	fprintf(stderr, "mrc p15, 0, rX, c0, c1, 4 is %#x\n", val);
>   	__asm__ volatile ("mrc p15, 0, %0, c0, c1, 5\n" : "=r" (val));
>   	fprintf(stderr, "mrc p15, 0, rX, c0, c1, 5 is %#x\n", val);
>   	__asm__ volatile ("mrc p15, 0, %0, c0, c1, 6\n" : "=r" (val));
>   	fprintf(stderr, "mrc p15, 0, rX, c0, c1, 6 is %#x\n", val);
>   	__asm__ volatile ("mrc p15, 0, %0, c0, c1, 7\n" : "=r" (val));
>   	fprintf(stderr, "mrc p15, 0, rX, c0, c1, 7 is %#x\n", val);
>   	__asm__ volatile ("mrc p15, 0, %0, c0, c2, 0\n" : "=r" (val));
>   	fprintf(stderr, "mrc p15, 0, rX, c0, c2, 0 is %#x\n", val);
>   	__asm__ volatile ("mrc p15, 0, %0, c0, c2, 1\n" : "=r" (val));
>   	fprintf(stderr, "mrc p15, 0, rX, c0, c2, 1 is %#x\n", val);
>   	__asm__ volatile ("mrc p15, 0, %0, c0, c2, 2\n" : "=r" (val));
>   	fprintf(stderr, "mrc p15, 0, rX, c0, c2, 2 is %#x\n", val);
>   	__asm__ volatile ("mrc p15, 0, %0, c0, c2, 3\n" : "=r" (val));
>   	fprintf(stderr, "mrc p15, 0, rX, c0, c2, 3 is %#x\n", val);
>   	__asm__ volatile ("mrc p15, 0, %0, c0, c2, 4\n" : "=r" (val));
>   	fprintf(stderr, "mrc p15, 0, rX, c0, c2, 4 is %#x\n", val);
>   	__asm__ volatile ("mrc p15, 0, %0, c0, c2, 5\n" : "=r" (val));
>   	fprintf(stderr, "mrc p15, 0, rX, c0, c2, 5 is %#x\n", val);
>   	__asm__ volatile ("mrc p15, 0, %0, c0, c2, 6\n" : "=r" (val));
>   	fprintf(stderr, "mrc p15, 0, rX, c0, c2, 6 is %#x\n", val);
>   	__asm__ volatile ("mrc p15, 0, %0, c0, c2, 7\n" : "=r" (val));
>   	fprintf(stderr, "mrc p15, 0, rX, c0, c2, 7 is %#x\n", val);
>   	__asm__ volatile ("mrc p10, 7, %0, c7, c0, 0\n" : "=r" (val));
>   	fprintf(stderr, "mrc p10, 0, rX, c7, c0, 0 is %#x\n", val);
>   	__asm__ volatile ("mrc p10, 7, %0, c6, c0, 0\n" : "=r" (val));
>   	fprintf(stderr, "mrc p10, 0, rX, c6, c0, 0 is %#x\n", val);
>   	__asm__ volatile ("mrc p10, 7, %0, c0, c0, 0\n" : "=r" (val));
>   	fprintf(stderr, "mrc p10, 0, rX, c0, c0, 0 is %#x\n", val);
>   	__asm__ volatile ("mrc p10, 7, %0, c2, c0, 0\n" : "=r" (val));
>   
>   	return 0;
>   }
> 
> [1] http://lkml.kernel.org/r/20141027103118.GA8768@arm.com
> 
>  arch/arm/include/asm/opcodes.h    |   9 +++
>  arch/arm/include/uapi/asm/hwcap.h |   1 +
>  arch/arm/kernel/setup.c           | 113 +++++++++++++++++++++++++++++++++++++-
>  arch/arm/kernel/swp_emulate.c     |   8 ---
>  4 files changed, 122 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/include/asm/opcodes.h b/arch/arm/include/asm/opcodes.h
> index e796c598513b..751eca1d4e22 100644
> --- a/arch/arm/include/asm/opcodes.h
> +++ b/arch/arm/include/asm/opcodes.h
> @@ -216,6 +216,15 @@ extern asmlinkage unsigned int arm_check_condition(u32 opcode, u32 psr);
>  #define __inst_arm_thumb32(arm_opcode, thumb_opcode) __inst_arm(arm_opcode)
>  #endif
>  
> +/*
> + * Macros/defines for extracting register numbers from instruction.
> + */
> +#define EXTRACT_REG_NUM(instruction, offset) \
> +	(((instruction) & (0xf << (offset))) >> (offset))
> +#define RN_OFFSET  16
> +#define RT_OFFSET  12
> +#define RT2_OFFSET  0
> +
>  /* Helpers for the helpers.  Don't use these directly. */
>  #ifdef __ASSEMBLY__
>  #define ___inst_arm(x) .long x
> diff --git a/arch/arm/include/uapi/asm/hwcap.h b/arch/arm/include/uapi/asm/hwcap.h
> index 20d12f230a2f..4ec061e81d38 100644
> --- a/arch/arm/include/uapi/asm/hwcap.h
> +++ b/arch/arm/include/uapi/asm/hwcap.h
> @@ -27,6 +27,7 @@
>  #define HWCAP_IDIV	(HWCAP_IDIVA | HWCAP_IDIVT)
>  #define HWCAP_LPAE	(1 << 20)
>  #define HWCAP_EVTSTRM	(1 << 21)
> +#define HWCAP_CPUID	(1 << 22)
>  
>  /*
>   * HWCAP2 flags - for elf_hwcap2 (in kernel) and AT_HWCAP2
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index 84db893dedc2..ea0c1a013e00 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -30,6 +30,7 @@
>  #include <linux/bug.h>
>  #include <linux/compiler.h>
>  #include <linux/sort.h>
> +#include <linux/perf_event.h>
>  
>  #include <asm/unified.h>
>  #include <asm/cp15.h>
> @@ -56,9 +57,11 @@
>  #include <asm/unwind.h>
>  #include <asm/memblock.h>
>  #include <asm/virt.h>
> +#include <asm/opcodes.h>
> +#include <asm/vfp.h>
>  
>  #include "atags.h"
> -
> +#include "../vfp/vfpinstr.h"
>  
>  #if defined(CONFIG_FPE_NWFPE) || defined(CONFIG_FPE_FASTFPE)
>  char fpe_type[8];
> @@ -371,6 +374,108 @@ void __init early_print(const char *str, ...)
>  	printk("%s", buf);
>  }
>  
> +static u32 arm_id_registers[2 * 8];
> +static u32 arm_vfp_id_registers[3];
> +
> +static void cache_id_registers(void)
> +{
> +	arm_id_registers[0]  = read_cpuid_ext(CPUID_EXT_PFR0);
> +	arm_id_registers[1]  = read_cpuid_ext(CPUID_EXT_PFR1);
> +	arm_id_registers[2] = read_cpuid_ext(CPUID_EXT_DFR0);
> +	arm_id_registers[3] = read_cpuid_ext(CPUID_EXT_AFR0);
> +	arm_id_registers[4] = read_cpuid_ext(CPUID_EXT_MMFR0);
> +	arm_id_registers[5] = read_cpuid_ext(CPUID_EXT_MMFR1);
> +	arm_id_registers[6] = read_cpuid_ext(CPUID_EXT_MMFR2);
> +	arm_id_registers[7] = read_cpuid_ext(CPUID_EXT_MMFR3);
> +	arm_id_registers[8] = read_cpuid_ext(CPUID_EXT_ISAR0);
> +	arm_id_registers[9] = read_cpuid_ext(CPUID_EXT_ISAR1);
> +	arm_id_registers[10] = read_cpuid_ext(CPUID_EXT_ISAR2);
> +	arm_id_registers[11] = read_cpuid_ext(CPUID_EXT_ISAR3);
> +	arm_id_registers[12] = read_cpuid_ext(CPUID_EXT_ISAR4);
> +	arm_id_registers[13] = read_cpuid_ext(CPUID_EXT_ISAR5);
> +	arm_vfp_id_registers[0] = fmrx(FPSID);
> +	arm_vfp_id_registers[1] = fmrx(MVFR1);
> +	arm_vfp_id_registers[2] = fmrx(MVFR0);
> +}
> +
> +static int get_id_trap(struct pt_regs *regs, unsigned int instr)
> +{
> +	unsigned int destreg, crm, opc2;
> +	unsigned int res;
> +
> +	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, regs, regs->ARM_pc);
> +
> +	res = arm_check_condition(instr, regs->ARM_cpsr);
> +	if (res == ARM_OPCODE_CONDTEST_FAIL) {
> +		regs->ARM_pc += 4;
> +		return 0;
> +	}
> +
> +	destreg = EXTRACT_REG_NUM(instr, RT_OFFSET);
> +	crm = instr & 0xf;
> +	opc2 = (instr >> 5) & 0x7;
> +
> +	if (crm > 2 || crm == 0)
> +		return -EINVAL;
> +
> +	regs->uregs[destreg] = arm_id_registers[((crm - 1) * 8) + opc2];
> +	regs->ARM_pc += 4;
> +
> +	return 0;
> +}
> +
> +struct undef_hook arm_mrc_id_hook = {
> +	.instr_mask	= 0x0f100f10,
> +	.instr_val	= 0x0e100f10,
> +	.cpsr_mask	= MODE_MASK,
> +	.cpsr_val	= USR_MODE,
> +	.fn		= get_id_trap,
> +};
> +
> +static int get_vmrs_id_trap(struct pt_regs *regs, unsigned int instr)
> +{
> +	unsigned int destreg, data, reg;
> +	unsigned int res;
> +
> +	perf_sw_event(PERF_COUNT_SW_EMULATION_FAULTS, 1, regs, regs->ARM_pc);
> +
> +	res = arm_check_condition(instr, regs->ARM_cpsr);
> +	if (res == ARM_OPCODE_CONDTEST_FAIL) {
> +		regs->ARM_pc += 4;
> +		return 0;
> +	}
> +
> +	destreg = EXTRACT_REG_NUM(instr, RT_OFFSET);
> +	reg = (instr >> 16) & 0xf;
> +
> +	switch (reg) {
> +	case 0:
> +		data = arm_vfp_id_registers[0];
> +		break;
> +	case 6:
> +		data = arm_vfp_id_registers[1];
> +		break;
> +	case 7:
> +		data = arm_vfp_id_registers[2];
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	regs->uregs[destreg] = data;
> +	regs->ARM_pc += 4;
> +
> +	return 0;
> +}
> +
> +struct undef_hook arm_vmrs_id_hook = {
> +	.instr_mask	= 0x0ff00ff0,
> +	.instr_val	= 0x0ef00a10,
> +	.cpsr_mask	= MODE_MASK,
> +	.cpsr_val	= USR_MODE,
> +	.fn		= get_vmrs_id_trap,
> +};
> +
>  static void __init cpuid_init_hwcaps(void)
>  {
>  	unsigned int divide_instrs, vmsa;
> @@ -378,6 +483,11 @@ static void __init cpuid_init_hwcaps(void)
>  	if (cpu_architecture() < CPU_ARCH_ARMv7)
>  		return;
>  
> +	cache_id_registers();
> +	elf_hwcap |= HWCAP_CPUID;
> +	register_undef_hook(&arm_mrc_id_hook);
> +	register_undef_hook(&arm_vmrs_id_hook);
> +
>  	divide_instrs = (read_cpuid_ext(CPUID_EXT_ISAR0) & 0x0f000000) >> 24;
>  
>  	switch (divide_instrs) {
> @@ -1009,6 +1119,7 @@ static const char *hwcap_str[] = {
>  	"vfpd32",
>  	"lpae",
>  	"evtstrm",
> +	"cpuid",
>  	NULL
>  };
>  
> diff --git a/arch/arm/kernel/swp_emulate.c b/arch/arm/kernel/swp_emulate.c
> index 67ca8578c6d8..ebdcac50feef 100644
> --- a/arch/arm/kernel/swp_emulate.c
> +++ b/arch/arm/kernel/swp_emulate.c
> @@ -62,14 +62,6 @@
>  	__user_swpX_asm(data, addr, res, temp, "b")
>  
>  /*
> - * Macros/defines for extracting register numbers from instruction.
> - */
> -#define EXTRACT_REG_NUM(instruction, offset) \
> -	(((instruction) & (0xf << (offset))) >> (offset))
> -#define RN_OFFSET  16
> -#define RT_OFFSET  12
> -#define RT2_OFFSET  0
> -/*
>   * Bit 22 of the instruction encoding distinguishes between
>   * the SWP and SWPB variants (bit set means SWPB).
>   */

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

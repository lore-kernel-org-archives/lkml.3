Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaH2NGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 09:06:44 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:53755 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbaH2NGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 09:06:42 -0400
Message-ID: <54007AD4.6070701@de.ibm.com>
Date: Fri, 29 Aug 2014 15:06:28 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
CC: rkrcmar@redhat.com
Subject: Re: [PATCH] KVM: forward declare structs in kvm_types.h
References: <1409313707-7791-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1409313707-7791-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082913-8372-0000-0000-000000FA0475
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/14 14:01, Paolo Bonzini wrote:
> Opaque KVM structs are useful for prototypes in asm/kvm_host.h, to avoid
> "'struct foo' declared inside parameter list" warnings (and consequent
> breakage due to conflicting types).
> 
> Move them from individual files to a generic place in linux/kvm_types.h.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

I can confirm that s390 still builds and works.

> ---
>  arch/arm/include/asm/kvm_host.h     |  7 ++-----
>  arch/arm64/include/asm/kvm_host.h   |  6 ++----
>  arch/ia64/include/asm/kvm_host.h    |  3 ---
>  arch/mips/include/asm/kvm_host.h    |  5 -----
>  arch/powerpc/include/asm/kvm_host.h |  5 -----
>  arch/s390/include/asm/kvm_host.h    |  5 +++--
>  arch/x86/include/asm/kvm_host.h     |  4 ----
>  include/linux/kvm_types.h           | 11 +++++++++++
>  8 files changed, 18 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 84291feee9e1..aea259e9431f 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -19,6 +19,8 @@
>  #ifndef __ARM_KVM_HOST_H__
>  #define __ARM_KVM_HOST_H__
> 
> +#include <linux/types.h>
> +#include <linux/kvm_types.h>
>  #include <asm/kvm.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_mmio.h>
> @@ -40,7 +42,6 @@
> 
>  #include <kvm/arm_vgic.h>
> 
> -struct kvm_vcpu;
>  u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
>  int kvm_target_cpu(void);
>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
> @@ -149,20 +150,17 @@ struct kvm_vcpu_stat {
>  	u32 halt_wakeup;
>  };
> 
> -struct kvm_vcpu_init;
>  int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
>  			const struct kvm_vcpu_init *init);
>  int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init);
>  unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu);
>  int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
> -struct kvm_one_reg;
>  int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
>  int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
>  u64 kvm_call_hyp(void *hypfn, ...);
>  void force_vm_exit(const cpumask_t *mask);
> 
>  #define KVM_ARCH_WANT_MMU_NOTIFIER
> -struct kvm;
>  int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
>  int kvm_unmap_hva_range(struct kvm *kvm,
>  			unsigned long start, unsigned long end);
> @@ -187,7 +185,6 @@ struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
> 
>  int kvm_arm_copy_coproc_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
>  unsigned long kvm_arm_num_coproc_regs(struct kvm_vcpu *vcpu);
> -struct kvm_one_reg;
>  int kvm_arm_coproc_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *);
>  int kvm_arm_coproc_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *);
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 94d8a3c9b644..b5045e3e05f8 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -22,6 +22,8 @@
>  #ifndef __ARM64_KVM_HOST_H__
>  #define __ARM64_KVM_HOST_H__
> 
> +#include <linux/types.h>
> +#include <linux/kvm_types.h>
>  #include <asm/kvm.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_mmio.h>
> @@ -41,7 +43,6 @@
> 
>  #define KVM_VCPU_MAX_FEATURES 3
> 
> -struct kvm_vcpu;
>  int kvm_target_cpu(void);
>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
>  int kvm_arch_dev_ioctl_check_extension(long ext);
> @@ -164,18 +165,15 @@ struct kvm_vcpu_stat {
>  	u32 halt_wakeup;
>  };
> 
> -struct kvm_vcpu_init;
>  int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
>  			const struct kvm_vcpu_init *init);
>  int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init);
>  unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu);
>  int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
> -struct kvm_one_reg;
>  int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
>  int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
> 
>  #define KVM_ARCH_WANT_MMU_NOTIFIER
> -struct kvm;
>  int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
>  int kvm_unmap_hva_range(struct kvm *kvm,
>  			unsigned long start, unsigned long end);
> diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
> index 353167d95c66..4729752b7256 100644
> --- a/arch/ia64/include/asm/kvm_host.h
> +++ b/arch/ia64/include/asm/kvm_host.h
> @@ -234,9 +234,6 @@ struct kvm_vm_data {
>  #define KVM_REQ_PTC_G		32
>  #define KVM_REQ_RESUME		33
> 
> -struct kvm;
> -struct kvm_vcpu;
> -
>  struct kvm_mmio_req {
>  	uint64_t addr;          /*  physical address		*/
>  	uint64_t size;          /*  size in bytes		*/
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index b4d900acbdb9..0b24d6622ec1 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -96,11 +96,6 @@
>  #define CAUSEB_DC			27
>  #define CAUSEF_DC			(_ULCAST_(1) << 27)
> 
> -struct kvm;
> -struct kvm_run;
> -struct kvm_vcpu;
> -struct kvm_interrupt;
> -
>  extern atomic_t kvm_mips_instance;
>  extern pfn_t(*kvm_mips_gfn_to_pfn) (struct kvm *kvm, gfn_t gfn);
>  extern void (*kvm_mips_release_pfn_clean) (pfn_t pfn);
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index 0e646c1bff13..237cc0cc80a2 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -53,7 +53,6 @@
> 
>  #define KVM_ARCH_WANT_MMU_NOTIFIER
> 
> -struct kvm;
>  extern int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
>  extern int kvm_unmap_hva_range(struct kvm *kvm,
>  			       unsigned long start, unsigned long end);
> @@ -76,10 +75,6 @@ extern void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
>  /* Physical Address Mask - allowed range of real mode RAM access */
>  #define KVM_PAM			0x0fffffffffffffffULL
> 
> -struct kvm;
> -struct kvm_run;
> -struct kvm_vcpu;
> -
>  struct lppaca;
>  struct slb_shadow;
>  struct dtl_entry;
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index cee2be94e4ae..f6dd90684b97 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -13,8 +13,11 @@
> 
>  #ifndef ASM_KVM_HOST_H
>  #define ASM_KVM_HOST_H
> +
> +#include <linux/types.h>
>  #include <linux/hrtimer.h>
>  #include <linux/interrupt.h>
> +#include <linux/kvm_types.h>
>  #include <linux/kvm_host.h>
>  #include <linux/kvm.h>
>  #include <asm/debug.h>
> @@ -431,8 +434,6 @@ static inline bool kvm_is_error_hva(unsigned long addr)
>  }
> 
>  #define ASYNC_PF_PER_VCPU	64
> -struct kvm_vcpu;
> -struct kvm_async_pf;
>  struct kvm_arch_async_pf {
>  	unsigned long pfault_token;
>  };
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ac0f90e26a0b..567fface45f8 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -99,10 +99,6 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
> 
>  #define ASYNC_PF_PER_VCPU 64
> 
> -struct kvm_vcpu;
> -struct kvm;
> -struct kvm_async_pf;
> -
>  enum kvm_reg {
>  	VCPU_REGS_RAX = 0,
>  	VCPU_REGS_RCX = 1,
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index b0bcce0ddc95..1d6daca4927a 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -17,6 +17,17 @@
>  #ifndef __KVM_TYPES_H__
>  #define __KVM_TYPES_H__
> 
> +struct kvm;
> +struct kvm_async_pf;
> +struct kvm_interrupt;
> +struct kvm_memory_slot;
> +struct kvm_one_reg;
> +struct kvm_run;
> +struct kvm_userspace_memory_region;
> +struct kvm_vcpu;
> +struct kvm_vcpu_init;
> +enum kvm_mr_change;
> +
>  #include <asm/types.h>
> 
>  /*
> 


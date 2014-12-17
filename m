Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaLQRc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 12:32:29 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:61973 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaLQRc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 12:32:27 -0500
Message-ID: <5491BE24.4040105@redhat.com>
Date: Wed, 17 Dec 2014 18:32:20 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
Newsgroups: gmane.comp.emulators.kvm.devel
To: "Wu, Feng" <feng.wu@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Eric Auger <eric.auger@linaro.org>
Subject: Re: [v3 17/26] KVM: make kvm_set_msi_irq() public
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com> <1418397300-10870-18-git-send-email-feng.wu@intel.com>
In-Reply-To: <1418397300-10870-18-git-send-email-feng.wu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/12/2014 16:14, Feng Wu wrote:
> Make kvm_set_msi_irq() public, we can use this function outside.
> 
> Signed-off-by: Feng Wu <feng.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  include/linux/kvm_host.h | 2 ++
>  virt/kvm/irq_comm.c      | 2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index cfa85ac..5cd4420 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -785,6 +785,8 @@ void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
>  				   struct kvm_irq_ack_notifier *kian);
>  int kvm_request_irq_source_id(struct kvm *kvm);
>  void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
> +void kvm_set_msi_irq(struct kvm_kernel_irq_routing_entry *e,
> +		     struct kvm_lapic_irq *irq);

This function is now in arch/x86, so please add to
arch/x86/include/asm/kvm_host.h instead.

>  #ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
>  int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
> diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
> index f3c5d69..231671a 100644
> --- a/virt/kvm/irq_comm.c
> +++ b/virt/kvm/irq_comm.c
> @@ -106,7 +106,7 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
>  	return r;
>  }
>  
> -static inline void kvm_set_msi_irq(struct kvm_kernel_irq_routing_entry *e,
> +void kvm_set_msi_irq(struct kvm_kernel_irq_routing_entry *e,
>  				   struct kvm_lapic_irq *irq)
>  {
>  	trace_kvm_msi_set_irq(e->msi.address_lo, e->msi.data);
> 

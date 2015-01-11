Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbbAKVLf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 16:11:35 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:54275 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbbAKVLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 16:11:33 -0500
Date: Sun, 11 Jan 2015 22:11:29 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, agraf@suse.de,
        joel.schopp@amd.com, gleb@kernel.org, pbonzini@redhat.com,
        borntraeger@de.ibm.com, cornelia.huck@de.ibm.com,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        a.motakis@virtualopensystems.com
Subject: Re: [PATCH v5 2/5] KVM: introduce
 kvm_arch_is_virtual_intc_initialized
Message-ID: <20150111211129.GD3868@cbox>
References: <1417622832-5460-1-git-send-email-eric.auger@linaro.org>
 <1417622832-5460-3-git-send-email-eric.auger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417622832-5460-3-git-send-email-eric.auger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 05:07:09PM +0100, Eric Auger wrote:
> Introduce __KVM_HAVE_ARCH_VIRTUAL_INTC_INITIALIZED define and
> associated kvm_arch_is_virtual_intc_initialized function. This latter
> allows to test whether the virtual interrupt controller is initialized
> and ready to accept virtual IRQ injection. On some architectures,
> the virtual interrupt controller is dynamically instantiated, justifying
> that kind of check.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> ---
>  include/linux/kvm_host.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ea53b04..45fea3c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -696,6 +696,18 @@ static inline wait_queue_head_t *kvm_arch_vcpu_wq(struct kvm_vcpu *vcpu)
>  #endif
>  }
>  
> +#ifndef __KVM_HAVE_ARCH_VIRTUAL_INTC_INITIALIZED

maybe you can drop the _virtual_ from all these names to make it
slightly shorter.

alternatively to this approach you could expose a function from the
irqfd layer that KVM intc implementations call into to say "I'm
ready"...  Not sure if it would look nicer.

> +/*
> + * returns trues if the virtual interrupt controller is initialized and
> + * ready to accept virtual IRQ. On some architectures the virtual interrupt
> + * controller is dynamically instantiated and this is not always true.
> + */
> +static inline bool kvm_arch_is_virtual_intc_initialized(struct kvm *kvm)
> +{
> +	return true;
> +}

don't you need to define a prototype if the architecture does define the
symbol?

> +#endif
> +
>  int kvm_arch_init_vm(struct kvm *kvm, unsigned long type);
>  void kvm_arch_destroy_vm(struct kvm *kvm);
>  void kvm_arch_sync_events(struct kvm *kvm);
> -- 
> 1.9.1
> 

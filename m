Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbbAKVRU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 16:17:20 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:33554 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbbAKVRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 16:17:17 -0500
Date: Sun, 11 Jan 2015 22:17:13 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, agraf@suse.de,
        joel.schopp@amd.com, gleb@kernel.org, pbonzini@redhat.com,
        borntraeger@de.ibm.com, cornelia.huck@de.ibm.com,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        a.motakis@virtualopensystems.com
Subject: Re: [PATCH v5 4/5] KVM: irqfd: use
 kvm_arch_is_virtual_intc_initialized
Message-ID: <20150111211713.GF3868@cbox>
References: <1417622832-5460-1-git-send-email-eric.auger@linaro.org>
 <1417622832-5460-5-git-send-email-eric.auger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417622832-5460-5-git-send-email-eric.auger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 05:07:11PM +0100, Eric Auger wrote:
> On arm/arm64, the interrupt controller is dynamically instantiated.
> There is a risk the user-space assigns an irqfd before this latter
> is initialized and ready to accept virtual irq injection. On such
> attempt, the IRQFD setup is rejected and -EAGAIN is returned.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> ---
>  virt/kvm/eventfd.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index b0fb390..f837c83 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -314,6 +314,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  	unsigned int events;
>  	int idx;
>  
> +	if (!kvm_arch_is_virtual_intc_initialized(kvm))
> +		return -EAGAIN;
> +

You can fold this into the patch that defines the static inline since
nothing defines the KVM_HAVE_ARCH_... yet.

>  	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
>  	if (!irqfd)
>  		return -ENOMEM;
> -- 
> 1.9.1
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab3H0H4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 03:56:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab3H0H4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 03:56:14 -0400
Date: Tue, 27 Aug 2013 10:56:00 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        Alexander Graf <agraf@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8] KVM: PPC: reserve a capability and ioctl numbers for
 realmode VFIO
Message-ID: <20130827075600.GE22899@redhat.com>
References: <1376552966-8529-1-git-send-email-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376552966-8529-1-git-send-email-aik@ozlabs.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 05:49:26PM +1000, Alexey Kardashevskiy wrote:
> This is to reserve a capablity number for upcoming support
> of VFIO-IOMMU DMA operations in real mode.
> 
> The last ioctl in the group which KVM_CREATE_SPAPR_TCE_IOMMU is added to
> is 0xac, the next two numbers are taken - 0xad for KVM_KVMCLOCK_CTRL and
0xac was also taken by KVM_SET_ONE_REG :(

> 0xae for KVM_ARM_VCPU_INIT. So the KVM_CREATE_SPAPR_TCE_IOMMU ioclt gets
> 0xaf.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> 
> ---
> Changes:
> 2013/08/15 v8:
> * fixed comment again
> 
> 2013/08/15:
> * fixed mistype in comments
> * fixed commit message which says what uses ioctls 0xad and 0xae
> 
> 2013/07/16:
> * changed the number
> 
> 2013/07/11:
> * changed order in a file, added comment about a gap in ioctl number
> ---
>  include/uapi/linux/kvm.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 99c2533..bd94127 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -668,6 +668,7 @@ struct kvm_ppc_smmu_info {
>  #define KVM_CAP_IRQ_XICS 92
>  #define KVM_CAP_ARM_EL1_32BIT 93
>  #define KVM_CAP_SPAPR_MULTITCE 94
> +#define KVM_CAP_SPAPR_TCE_IOMMU 95
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> @@ -933,6 +934,11 @@ struct kvm_s390_ucas_mapping {
>  #define KVM_ARM_SET_DEVICE_ADDR	  _IOW(KVMIO,  0xab, struct kvm_arm_device_addr)
>  /* Available with KVM_CAP_PPC_RTAS */
>  #define KVM_PPC_RTAS_DEFINE_TOKEN _IOW(KVMIO,  0xac, struct kvm_rtas_token_args)
> +/* 0xad is taken by KVM_KVMCLOCK_CTRL */
> +/* 0xae is taken by KVM_ARM_VCPU_INIT */
> +/* Available with KVM_CAP_SPAPR_TCE_IOMMU */
> +#define KVM_CREATE_SPAPR_TCE_IOMMU _IOW(KVMIO,  0xaf, \
> +					struct kvm_create_spapr_tce_iommu)
>  
Why not use KVM_CREATE_DEVICE API for that?

>  /* ioctl for vm fd */
>  #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
> -- 
> 1.8.3.2

--
			Gleb.

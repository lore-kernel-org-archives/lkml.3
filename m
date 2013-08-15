Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760321Ab3HOHQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:16:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43293 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab3HOHQ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:16:28 -0400
Subject: Re: [PATCH 03/10] KVM: PPC: reserve a capability and ioctl numbers for realmode VFIO
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1375332272-22176-4-git-send-email-aik@ozlabs.ru>
Date: Thu, 15 Aug 2013 09:16:19 +0200
Cc: linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <ED8250FB-B0A8-4C32-A960-20ADB5742D2B@suse.de>
References: <1375332272-22176-1-git-send-email-aik@ozlabs.ru> <1375332272-22176-4-git-send-email-aik@ozlabs.ru>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01.08.2013, at 06:44, Alexey Kardashevskiy wrote:

> This is to reserve a capablity number for upcoming support
> of VFIO-IOMMU DMA operations in real mode.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> 
> ---
> Changes:
> 2013/07/16:
> * changed the number
> 
> 2013/07/11:
> * changed order in a file, added comment about a gap in ioctl number
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
> include/uapi/linux/kvm.h | 4 ++++
> 1 file changed, 4 insertions(+)
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 99c2533..53c3f1f 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -668,6 +668,7 @@ struct kvm_ppc_smmu_info {
> #define KVM_CAP_IRQ_XICS 92
> #define KVM_CAP_ARM_EL1_32BIT 93
> #define KVM_CAP_SPAPR_MULTITCE 94
> +#define KVM_CAP_SPAPR_TCE_IOMMU 95
> 
> #ifdef KVM_CAP_IRQ_ROUTING
> 
> @@ -933,6 +934,9 @@ struct kvm_s390_ucas_mapping {
> #define KVM_ARM_SET_DEVICE_ADDR	  _IOW(KVMIO,  0xab, struct kvm_arm_device_addr)
> /* Available with KVM_CAP_PPC_RTAS */
> #define KVM_PPC_RTAS_DEFINE_TOKEN _IOW(KVMIO,  0xac, struct kvm_rtas_token_args)
> +/* 0xad and 0xaf are already taken */

so 0xad and 0xaf are already taken? where?

> +/* Available with KVM_CAP_SPAPR_TCE_IOMMU */
> +#define KVM_CREATE_SPAPR_TCE_IOMMU _IOW(KVMIO,  0xaf, struct kvm_create_spapr_tce_iommu)

and why is this one 0xaf then?


Alex

> 
> /* ioctl for vm fd */
> #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
> -- 
> 1.8.3.2
> 


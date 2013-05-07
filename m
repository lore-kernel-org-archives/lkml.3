Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595Ab3EGBnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:43:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756768Ab3EGBnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:43:15 -0400
Message-ID: <1367890979.2868.93.camel@ul30vt.home>
Subject: Re: [PATCH 2/5] KVM: PPC: iommu: Add missing
 kvm_iommu_map_pages/kvm_iommu_unmap_pages
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-pci@vger.kernel.org
Date: Mon, 06 May 2013 19:42:59 -0600
In-Reply-To: <51884FA8.6010400@ozlabs.ru>
References: <1367824921-27151-1-git-send-email-y>
	  <51875a36.25ac440a.50d9.ffffe90d@mx.google.com>
	 <1367874436.2868.90.camel@ul30vt.home> <51884FA8.6010400@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-07 at 10:49 +1000, Alexey Kardashevskiy wrote:
> On 05/07/2013 07:07 AM, Alex Williamson wrote:
> > On Mon, 2013-05-06 at 17:21 +1000, aik@ozlabs.ru wrote:
> >> From: Alexey Kardashevskiy <aik@ozlabs.ru>
> >>
> >> The IOMMU API implements groups creating/deletion, device binding
> >> and IOMMU map/unmap operations.
> >>
> >> The PowerPC implementation uses most of the API except map/unmap
> >> operations, which are implemented on POWER using hypercalls.
> >>
> >> However, in order to link a kernel with the CONFIG_IOMMU_API enabled,
> >> the empty kvm_iommu_map_pages/kvm_iommu_unmap_pages have to be
> >> defined, so this defines them.
> >>
> >> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> >> Cc: David Gibson <david@gibson.dropbear.id.au>
> >> Signed-off-by: Paul Mackerras <paulus@samba.org>
> >> ---
> >>  arch/powerpc/include/asm/kvm_host.h |   14 ++++++++++++++
> >>  1 file changed, 14 insertions(+)
> >>
> >> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> >> index b6a047e..c025d91 100644
> >> --- a/arch/powerpc/include/asm/kvm_host.h
> >> +++ b/arch/powerpc/include/asm/kvm_host.h
> >> @@ -603,4 +603,18 @@ struct kvm_vcpu_arch {
> >>  
> >>  #define __KVM_HAVE_ARCH_WQP
> >>  
> >> +#ifdef CONFIG_IOMMU_API
> >> +/* POWERPC does not use IOMMU API for mapping/unmapping */
> >> +static inline int kvm_iommu_map_pages(struct kvm *kvm,
> >> +		struct kvm_memory_slot *slot)
> >> +{
> >> +	return 0;
> >> +}
> >> +
> >> +static inline void kvm_iommu_unmap_pages(struct kvm *kvm,
> >> +		struct kvm_memory_slot *slot)
> >> +{
> >> +}
> >> +#endif /* CONFIG_IOMMU_API */
> >> +
> >>  #endif /* __POWERPC_KVM_HOST_H__ */
> > 
> > This is no longer needed, Gleb applied my patch for 3.10 that make all
> > of KVM device assignment dependent on a build config option and the top
> > level kvm_host.h now includes this when that is not set.  Thanks,
> 
> Cannot find it, could you point me please where it is on github or
> git.kernel.org? Thanks.

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=2a5bab1004729f3302c776e53ee7c895b98bb1ce


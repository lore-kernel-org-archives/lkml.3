Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab3IRGWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 02:22:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab3IRGWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 02:22:48 -0400
Date: Wed, 18 Sep 2013 09:21:55 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        marc.zyngier@arm.com, pbonzini@redhat.com, linux@arm.linux.org.uk,
        will.deacon@arm.com
Subject: Re: [PATCH 3/3] aarch64: kvm: introduce CONFIG_KVM_MAX_VCPUS
Message-ID: <20130918062155.GF5657@redhat.com>
References: <1379160656-28050-1-git-send-email-drjones@redhat.com>
 <1379160656-28050-4-git-send-email-drjones@redhat.com>
 <20130917213428.GJ7623@lvm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130917213428.GJ7623@lvm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 10:34:28PM +0100, Christoffer Dall wrote:
> On Sat, Sep 14, 2013 at 02:10:56PM +0200, Andrew Jones wrote:
> > Take CONFIG_KVM_MAX_VCPUS from arm32, but set the default to 8.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  7 ++++++-
> >  arch/arm64/kvm/Kconfig            | 11 +++++++++++
> >  2 files changed, 17 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 0859a4ddd1e7d..d1af8c49a5ca4 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -26,7 +26,12 @@
> >  #include <asm/kvm_asm.h>
> >  #include <asm/kvm_mmio.h>
> >  
> > -#define KVM_MAX_VCPUS 4
> > +#if defined(CONFIG_KVM_MAX_VCPUS)
> > +#define KVM_MAX_VCPUS CONFIG_KVM_MAX_VCPUS
> > +#else
> > +#define KVM_MAX_VCPUS 0
> > +#endif
> > +
> >  #define KVM_USER_MEM_SLOTS 32
> >  #define KVM_PRIVATE_MEM_SLOTS 4
> >  #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index 21e90820bd23c..c9924b02e84f7 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -35,6 +35,17 @@ config KVM_ARM_HOST
> >  	---help---
> >  	  Provides host support for ARM processors.
> >  
> > +config KVM_MAX_VCPUS
> > +	int "Number maximum supported virtual CPUs per VM"
> > +	depends on KVM_ARM_HOST
> > +	default 8
> 
> That data structure gets really big with 8 max vcpus.  I think we should
> keep this at 4 for now, a quad-core VM is quite reasonable for now.
> 
Which data structure? vgic? IIRC with 8 vcpus it will be something like
500 bytes bigger then it is now.

--
			Gleb.

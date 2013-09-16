Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab3IPIrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:47:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab3IPIrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:47:12 -0400
Date: Mon, 16 Sep 2013 11:47:10 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: kvm: introduce CONFIG_KVM_MAX_VCPUS
Message-ID: <20130916084710.GJ17294@redhat.com>
References: <1379161129-28393-1-git-send-email-drjones@redhat.com>
 <20130915090838.GW17294@redhat.com>
 <20130916082820.GB2101@hawk.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130916082820.GB2101@hawk.usersys.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 10:28:20AM +0200, Andrew Jones wrote:
> On Sun, Sep 15, 2013 at 12:08:38PM +0300, Gleb Natapov wrote:
> > On Sat, Sep 14, 2013 at 02:18:49PM +0200, Andrew Jones wrote:
> > > Take CONFIG_KVM_MAX_VCPUS from arm32, but set the default to 255.
> > > 
> > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > ---
> > >  arch/x86/include/asm/kvm_host.h |  5 +++--
> > >  arch/x86/kvm/Kconfig            | 10 ++++++++++
> > >  2 files changed, 13 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index c76ff74a98f2e..e7e9b523a8f7e 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -31,8 +31,9 @@
> > >  #include <asm/msr-index.h>
> > >  #include <asm/asm.h>
> > >  
> > > -#define KVM_MAX_VCPUS 255
> > > -#define KVM_SOFT_MAX_VCPUS 160
> > > +#define KVM_MAX_VCPUS CONFIG_KVM_MAX_VCPUS
> > > +#define KVM_SOFT_MAX_VCPUS min(160, KVM_MAX_VCPUS)
> > > +
> > >  #define KVM_USER_MEM_SLOTS 125
> > >  /* memory slots that are not exposed to userspace */
> > >  #define KVM_PRIVATE_MEM_SLOTS 3
> > > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > > index a47a3e54b964b..e9532c33527ee 100644
> > > --- a/arch/x86/kvm/Kconfig
> > > +++ b/arch/x86/kvm/Kconfig
> > > @@ -52,6 +52,16 @@ config KVM
> > >  
> > >  	  If unsure, say N.
> > >  
> > > +config KVM_MAX_VCPUS
> > > +	int "Number maximum supported virtual CPUs per VM"
> > > +	depends on KVM
> > > +	default 255
> > > +	help
> > > +	  Static number of max supported virtual CPUs per VM.
> > > +
> > > +	  Set to a lower number to save some resources. Set to a higher
> > > +	  number to test scalability.
> > > +
> > Maximum this can save is around 2K per VM. This is pretty insignificant
> > considering overall memory footprint even smallest VM has.
> 
> Should I reword this, dropping all 'save resources' verbiage, in order to
> avoid sending a message that this option can affect resource consumption?
> Or just leave it as it is, because even though it's insignificant, it's
> still true and balances out the 'Set to a higher' part.
> 
I do not think config option is necessary. The overhead is so
insignificant that there is no point in additional user visible knob,
at least while only 255 vcpu are supported. Is there a reason for anyone
to configure less them 255 vcpus here? OTOH what prevents someone from
configuring more then 255 vcpus?

--
			Gleb.

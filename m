Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab3IZHzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:55:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab3IZHzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:55:09 -0400
Date: Thu, 26 Sep 2013 09:54:14 +0200
From: Andrew Jones <drjones@redhat.com>
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com,
        gleb@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        pbonzini@redhat.com, linux@arm.linux.org.uk, will.deacon@arm.com
Subject: Re: [PATCH v2] arm32: kvm: rename CONFIG_KVM_ARM_MAX_VCPUS
Message-ID: <20130926075413.GA2062@hawk.usersys.redhat.com>
References: <1379160656-28050-3-git-send-email-drjones@redhat.com>
 <1380031768-21354-1-git-send-email-drjones@redhat.com>
 <20130925193127.GD32311@cbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925193127.GD32311@cbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 12:31:27PM -0700, Christoffer Dall wrote:
> On Tue, Sep 24, 2013 at 04:09:28PM +0200, Andrew Jones wrote:
> > Drop the _ARM_ part of the name. We can then introduce a config option
> > like this to aarch64 and other arches using the same name - allowing
> > grep to show them all. Also update the help text to describe the option
> > more completely.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > 
> > ---
> > v2: reword help text some more
> > ---
> >  arch/arm/include/asm/kvm_host.h | 4 ++--
> >  arch/arm/kvm/Kconfig            | 9 +++++----
> >  2 files changed, 7 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> > index 7d22517d80711..c614d3eb176c6 100644
> > --- a/arch/arm/include/asm/kvm_host.h
> > +++ b/arch/arm/include/asm/kvm_host.h
> > @@ -25,8 +25,8 @@
> >  #include <asm/fpstate.h>
> >  #include <kvm/arm_arch_timer.h>
> >  
> > -#if defined(CONFIG_KVM_ARM_MAX_VCPUS)
> > -#define KVM_MAX_VCPUS CONFIG_KVM_ARM_MAX_VCPUS
> > +#if defined(CONFIG_KVM_MAX_VCPUS)
> > +#define KVM_MAX_VCPUS CONFIG_KVM_MAX_VCPUS
> >  #else
> >  #define KVM_MAX_VCPUS 0
> >  #endif
> > diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
> > index ebf5015508b52..8e56ccf45edce 100644
> > --- a/arch/arm/kvm/Kconfig
> > +++ b/arch/arm/kvm/Kconfig
> > @@ -40,16 +40,17 @@ config KVM_ARM_HOST
> >  	---help---
> >  	  Provides host support for ARM processors.
> >  
> > -config KVM_ARM_MAX_VCPUS
> > +config KVM_MAX_VCPUS
> >  	int "Number maximum supported virtual CPUs per VM"
> >  	depends on KVM_ARM_HOST
> >  	default 4
> >  	help
> >  	  Static number of max supported virtual CPUs per VM.
> >  
> > -	  If you choose a high number, the vcpu structures will be quite
> > -	  large, so only choose a reasonable number that you expect to
> > -	  actually use.
> > +	  The default is set to the highest number of vcpus that
> > +	  current hardware supports. Choosing a lower number decreases
> > +	  the size of the VM data structure. This number may also be
> > +	  increased.
> >  
> Maybe I'm being forgetful, but what do you mean by "This number may also
> be increased" ?

Originally I was proposing we write 'increase for scalability testing',
as would be the purpose on the x86 side. However, you suggested it can
be increased for other purposes, although you didn't mention what. I just
dropped the 'scalability testing' to allow users to fill the blank in
themselves. If it doesn't really make sense on arm to increase this
beyond what hardware supports, then we can drop the 'increase' completely
and add a

range 1 <same-as-default>

to the Kconfig entry instead.

drew

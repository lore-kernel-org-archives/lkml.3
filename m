Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791Ab3CTK5C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 06:57:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047Ab3CTK47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 06:56:59 -0400
Date: Wed, 20 Mar 2013 12:56:58 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: let userspace inject interrupts into the local APIC
Message-ID: <20130320105657.GC3889@redhat.com>
References: <1363708273-19653-1-git-send-email-pbonzini@redhat.com>
 <20130319181323.GL19292@redhat.com>
 <5148B0DC.9000609@redhat.com>
 <20130319185025.GM19292@redhat.com>
 <5148C909.30103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5148C909.30103@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 09:22:33PM +0100, Paolo Bonzini wrote:
> Il 19/03/2013 19:50, Gleb Natapov ha scritto:
> > On Tue, Mar 19, 2013 at 07:39:24PM +0100, Paolo Bonzini wrote:
> >> Il 19/03/2013 19:13, Gleb Natapov ha scritto:
> >>>>> There is no way for userspace to inject interrupts into a VCPU's
> >>>>> local APIC, which is important in order to inject INITs coming from
> >>>>> the chipset.  KVM_INTERRUPT is currently disabled when the in-kernel
> >>>>> local APIC is used, so we can repurpose it.  The shorthand destination
> >>>>> field must contain APIC_DEST_SELF, which has a double effect: first,
> >>>>> the ICR2 register is not used and the 32-bit field of KVM_INTERRUPT is
> >>>>> enough; second, it ensures that the valid range of the irq field is
> >>>>> distinct in the userspace-APIC and kernel-APIC cases.
> >>>>>
> >>> Init coming from triggering INIT# line should not be modeled as INIT coming from
> >>> APIC.
> >>
> >> Then Jan's patch was wrong, and INIT should not have been an apic event
> >> (perhaps SIPI should).
> >>
> > If it goes through APIC it is.
> 
> Ok, I'll extract KVM_APIC_INIT handling into a separate function and
> call it synchronously from KVM_INTERRUPT, with irq = -1
> (KVM_INTERRUPT_INIT, similar to PPC's values of irq).
> KVM_INTERRUPT_INIT will be accessible even with in-kernel irqchip.
> 
Why should it be accessible with in-kernel irqchip? The only valid value
for mp_state is RUNNING with userspace irqchip. We even validate it in
kvm_arch_vcpu_ioctl_set_mpstate() now.

> >>> In fact INIT cannot be send using SELF shorthand.
> >>
> >> Where does the SDM say that?
> >>
> > Table 10-3.
> 
> Yeah, table 10-6 and 10-7 here.
> 
Hmm, somebody needs to update SDM. Mine is from January 2013.

--
			Gleb.

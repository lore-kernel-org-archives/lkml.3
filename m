Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab3CSSu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 14:50:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057Ab3CSSu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 14:50:27 -0400
Date: Tue, 19 Mar 2013 20:50:26 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: let userspace inject interrupts into the local APIC
Message-ID: <20130319185025.GM19292@redhat.com>
References: <1363708273-19653-1-git-send-email-pbonzini@redhat.com>
 <20130319181323.GL19292@redhat.com>
 <5148B0DC.9000609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5148B0DC.9000609@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 07:39:24PM +0100, Paolo Bonzini wrote:
> Il 19/03/2013 19:13, Gleb Natapov ha scritto:
> >> > There is no way for userspace to inject interrupts into a VCPU's
> >> > local APIC, which is important in order to inject INITs coming from
> >> > the chipset.  KVM_INTERRUPT is currently disabled when the in-kernel
> >> > local APIC is used, so we can repurpose it.  The shorthand destination
> >> > field must contain APIC_DEST_SELF, which has a double effect: first,
> >> > the ICR2 register is not used and the 32-bit field of KVM_INTERRUPT is
> >> > enough; second, it ensures that the valid range of the irq field is
> >> > distinct in the userspace-APIC and kernel-APIC cases.
> >> > 
> > Init coming from triggering INIT# line should not be modeled as INIT coming from
> > APIC.
> 
> Then Jan's patch was wrong, and INIT should not have been an apic event
> (perhaps SIPI should).
> 
If it goes through APIC it is. Also the problem with reusing KVM_INTERRUPT is
that it is synchronous interface but INIT# is asynchronous. Shouldn't be a big
deal though.

> > In fact INIT cannot be send using SELF shorthand.
> 
> Where does the SDM say that?
> 
Table 10-3.

--
			Gleb.

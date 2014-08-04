Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbaHDMNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:13:14 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:46281 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaHDMNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:13:12 -0400
Date: Mon, 4 Aug 2014 14:13:17 +0200
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: KVM: export current vcpu->pause state via pseudo
 regs
Message-ID: <20140804121317.GD524@cbox>
References: <1404914112-7298-1-git-send-email-alex.bennee@linaro.org>
 <20140731143538.GI11610@cbox>
 <87mwbpimgz.fsf@linaro.org>
 <20140731163805.GK11610@cbox>
 <87fvhgin6s.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87fvhgin6s.fsf@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 10:11:52AM +0100, Alex Bennée wrote:
> 
> Christoffer Dall writes:
> 
> > On Thu, Jul 31, 2014 at 04:14:51PM +0100, Alex Bennée wrote:
> >> 
> >> Christoffer Dall writes:
> >> 
> >> > On Wed, Jul 09, 2014 at 02:55:12PM +0100, Alex Bennée wrote:
> >> >> To cleanly restore an SMP VM we need to ensure that the current pause
> >> >> state of each vcpu is correctly recorded. Things could get confused if
> >> >> the CPU starts running after migration restore completes when it was
> >> >> paused before it state was captured.
> >> >> 
> >> <snip>
> >> >> +/* Power state (PSCI), not real registers */
> >> >> +#define KVM_REG_ARM_PSCI		(0x0014 << KVM_REG_ARM_COPROC_SHIFT)
> >> >> +#define KVM_REG_ARM_PSCI_REG(n) \
> >> >> +	(KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_PSCI | \
> >> >> +         (n & ~KVM_REG_ARM_COPROC_MASK))
> >> >
> >> > I don't understand this mask, why isn't this
> >> >             (n & 0xffff))
> >> 
> >> I was trying to use the existing masks, but of course if anyone changes
> >> that it would be an ABI change so probably not worth it.
> >> 
> >
> > the KVM_REG_ARM_COPROC_MASK is part of the uapi IIRC, so that's not the
> > issue, but that mask doesn't cover all the upper bits, so it feels weird
> > to use that to me.
> 
> Yeah I missed that. I could do a:
> 
> #define KVM_REG_ARM_COPROC_INDEX_MASK   ((1<<KVM_REG_ARM_COPROC_SHIFT)-1)
> 
> and use that. I'm generally try to avoid hardcoded numbers but I could
> be being a little OCD here ;-)
> 
> >> > Can you add the 32-bit counterpart as part of this patch?
> >> 
> >> Same patch? Sure.
> >
> > really up to you if you want to split it up into two patches, but I
> > think it's small enough that you can just create one patch.
> 
> Given the similarity of this code between arm and arm64 I'm wondering if
> it's worth doing a arch/arm/kvm/guest_common.c or something to reduce
> the amount of copy paste stuff?
> 
We've gotten by without it so far.  I fear we end up with a bunch of
complications due to differences in sizeof(unsigned long) etc., but I
may be wrong.

The amount of code that is copied should be trivial boilerplate stuff,
but if you think it's worth unifying, then I'd be happy to review the
patch.

Thanks,
-Christoffer

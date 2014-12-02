Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110AbaLBNW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 08:22:56 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:57735 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbaLBNWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 08:22:54 -0500
Date: Tue, 2 Dec 2014 14:23:37 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com,
        peter.maydell@linaro.org, agraf@suse.de, jan.kiszka@siemens.com,
        dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de,
        pbonzini@redhat.com, Gleb Natapov <gleb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] KVM: arm64: re-factor hyp.S debug register code
Message-ID: <20141202132337.GD545@cbox>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
 <1416931805-23223-7-git-send-email-alex.bennee@linaro.org>
 <20141130102546.GI23653@cbox>
 <87ppc31t9v.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ppc31t9v.fsf@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 11:52:44AM +0000, Alex Bennée wrote:
> 
> Christoffer Dall <christoffer.dall@linaro.org> writes:
> 
> > On Tue, Nov 25, 2014 at 04:10:04PM +0000, Alex Bennée wrote:
> >> This is a pre-cursor to sharing the code with the guest debug support.
> >> This replaces the big macro that fishes data out of a fixed location
> >> with a more general helper macro to restore a set of debug registers. It
> >> uses macro substitution so it can be re-used for debug control and value
> >> registers. It does however rely on the debug registers being 64 bit
> >> aligned (as they happen to be in the hyp ABI).
> >
> > can you enforce that somewhere?
> 
> There is a comment in kvm_asm.h:
> 
> /*
>  * 0 is reserved as an invalid value.
>  * Order *must* be kept in sync with the hyp switch code.
>  */
> 
> But I'm not sure how to enforce it in assembly. Is there a #pragma or
> something I can use?
> 

You can add a BUG_ON somewhere at runtime, but I wouldn't bother, you
can stick a note in that existing comment just so people don't change
the declaration of the registers to be 32-bit aligned or something else.

-Christoffer

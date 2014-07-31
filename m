Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaGaRoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:44:32 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61778 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752339AbaGaRo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:44:29 -0400
Date: Thu, 31 Jul 2014 18:44:00 +0100
From: Will Deacon <will.deacon@arm.com>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        kvm-devel <kvm@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@kernel.org>
Subject: Re: [PATCH] arm64: KVM: export current vcpu->pause state via pseudo
 regs
Message-ID: <20140731174359.GI26853@arm.com>
References: <1404914112-7298-1-git-send-email-alex.bennee@linaro.org>
 <53DA7583.2030504@redhat.com>
 <CAFEAcA9cT617t8JqOXtuO-wQ5xg5T3Sw_DUHB1fpPD6g3SSNaQ@mail.gmail.com>
 <53DA7B28.701@redhat.com>
 <CAFEAcA8RjmjoaEpjoDE5YJdKagtZYZe9TpCdsRPf86W=WCxCsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA8RjmjoaEpjoDE5YJdKagtZYZe9TpCdsRPf86W=WCxCsA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 06:36:35PM +0100, Peter Maydell wrote:
> On 31 July 2014 18:21, Paolo Bonzini <pbonzini@redhat.com> wrote:
> > What does ARM do if you have a WFI while interrupts are disabled?  On
> > x86 after "cli;hlt" only an NMI will wake you up.  With spurious
> > wakeups, it's pretty much guaranteed that you will break such "cli;hlt"
> > sequences.
> 
> The architecture mandates some things that *must* wake you from
> a WFI, but it also allows wakeups for other reasons not listed, or
> for no reason at all. It's perfectly valid to implement WFI as a NOP
> (though it would not be very good for power efficiency, obviously).
> Guests which don't surround WFI with a "check whether we should
> just go back to WFI" loop are buggy.

(and in case that wasn't clear, local_irq_disable() doesn't prevent an
interrupt from waking you up from wfi, otherwise our idle code would be
broken).

Will

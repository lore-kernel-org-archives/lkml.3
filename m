Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaHDMQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:16:52 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:50691 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaHDMQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:16:50 -0400
Date: Mon, 4 Aug 2014 14:16:55 +0200
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Alex Bennee <alex@bennee.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm-devel <kvm@vger.kernel.org>,
        Gleb Natapov <gleb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] arm64: KVM: export current vcpu->pause state via pseudo
 regs
Message-ID: <20140804121655.GE524@cbox>
References: <1404914112-7298-1-git-send-email-alex.bennee@linaro.org>
 <53DA7583.2030504@redhat.com>
 <CAFEAcA9cT617t8JqOXtuO-wQ5xg5T3Sw_DUHB1fpPD6g3SSNaQ@mail.gmail.com>
 <53DA7B28.701@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53DA7B28.701@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 07:21:44PM +0200, Paolo Bonzini wrote:
> Il 31/07/2014 19:04, Peter Maydell ha scritto:
> > On 31 July 2014 17:57, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >> Il 09/07/2014 15:55, Alex Bennée ha scritto:
> >>> To cleanly restore an SMP VM we need to ensure that the current pause
> >>> state of each vcpu is correctly recorded. Things could get confused if
> >>> the CPU starts running after migration restore completes when it was
> >>> paused before it state was captured.
> >>>
> >>> I've done this by exposing a register (currently only 1 bit used) via
> >>> the GET/SET_ONE_REG logic to pass the state between KVM and the VM
> >>> controller (e.g. QEMU).
> >>>
> >>> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> >>> ---
> >>>  arch/arm64/include/uapi/asm/kvm.h |  8 +++++
> >>>  arch/arm64/kvm/guest.c            | 61 ++++++++++++++++++++++++++++++++++++++-
> >>>  2 files changed, 68 insertions(+), 1 deletion(-)
> >>
> >> Since it's a pseudo register anyway, would it make sense to use the
> >> existing KVM_GET/SET_MP_STATE ioctl interface?
> > 
> > That appears to be an x86-specific thing relating to
> > IRQ chips.
> 
> No, it's not.  It's just the state of the CPU, s390 will be using it too.
> 
> On x86 the states are uninitialized (UNINITIALIZED), stopped
> (INIT_RECEIVED), running (RUNNABLE), halted (HALTED).  CPU 0 starts in
> RUNNABLE state, other CPUs start in UNINITIALIZED state.  There are
> x86-specific cases (uninitialized) and x86-isms (the INIT_RECEIVED
> name), but the idea is widely applicable.
> 
Alex, I think it makes perfect sense to use GET/SET_MP_STATE, will you
revise the patch?

(Don't forget to update the documentation to reflect it is now supported
on ARM, and which states are used to represent what there.)

Thanks,
-Christoffer

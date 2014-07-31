Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbaGaQyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:54:20 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:55529 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaGaQyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:54:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140731165006.GL11610@cbox>
References: <1404914112-7298-1-git-send-email-alex.bennee@linaro.org>
 <20140731143538.GI11610@cbox> <87mwbpimgz.fsf@linaro.org> <20140731163805.GK11610@cbox>
 <CAFEAcA91efUg3MVpLScNBkxZSEgDP0zNnmxxr055fAz5=vDCoA@mail.gmail.com> <20140731165006.GL11610@cbox>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 31 Jul 2014 17:53:56 +0100
Message-ID: <CAFEAcA-6dEBcOZYOP69G8z+6hxCTBdhV9Tv9vBA1C6kSc7UkJg@mail.gmail.com>
Subject: Re: [PATCH] arm64: KVM: export current vcpu->pause state via pseudo regs
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 July 2014 17:50, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> On Thu, Jul 31, 2014 at 05:45:28PM +0100, Peter Maydell wrote:
>> Consider the case where the reset state of the system is
>> "CPU 0 running, CPUs 1..N stopped", and we're doing an
>> incoming migration to a state where all CPUs are running.
>> In that case we'll be using this ioctl to clear the pause flag,
>> right? (We'll also obviously need to set the PC and other
>> register state correctly before resuming the guest.)
>>
> Doh, you're right, I somehow had it in my mind that when you send the
> thread a signal, the pause flag would be cleared, but that goes against
> the whole idea of a CPU being turned off for KVM.
>
> But wouldn't we then have to also wake up the thread when clearing the
> pause flag?  It feels strange that the ioctl can clear the pause flag,
> but keep the thread on a wake-queue, and then userspace has to send the
> thread a signal of some sort to wake it up?

I have no idea about the implementation, I just know what
the user-facing ABI ought to look like. In particular userspace
definitely shouldn't have to send the thread any kind of
signal, it should just use KVM_RUN as usual and that should
cause the vCPU to either remain powered-down or start
executing code, as appropriate for the state we've just set.

-- PMM

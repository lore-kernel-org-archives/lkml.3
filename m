Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbaGaQpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:45:53 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:42342 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaGaQpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:45:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140731163805.GK11610@cbox>
References: <1404914112-7298-1-git-send-email-alex.bennee@linaro.org>
 <20140731143538.GI11610@cbox> <87mwbpimgz.fsf@linaro.org> <20140731163805.GK11610@cbox>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 31 Jul 2014 17:45:28 +0100
Message-ID: <CAFEAcA91efUg3MVpLScNBkxZSEgDP0zNnmxxr055fAz5=vDCoA@mail.gmail.com>
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

On 31 July 2014 17:38, Christoffer Dall <christoffer.dall@linaro.org> wrote:
>> > If we are not complaining when setting the pause value to false if it
>> > was true before, then we probably also need to wake up the thread in
>> > case this is called from another thread, right?
>> >
>> > or perhaps we should just return an error if you're trying to un-pause a
>> > CPU through this interface, hmmmm.
>>
>> Wouldn't it be an error to mess with any register when the system is not
>> in a quiescent state? I was assuming that the wake state is dealt with
>> when the run loop finally restarts.
>>
>
> The ABI doesn't really define it as an error (the ABI doesn't enforce
> anything right now) so the question is, does it ever make sense to clear
> the pause flag through this ioctl?  If not, I think we should just err
> on the side of caution and specify in the docs that this is not
> supported and return an error.

Consider the case where the reset state of the system is
"CPU 0 running, CPUs 1..N stopped", and we're doing an
incoming migration to a state where all CPUs are running.
In that case we'll be using this ioctl to clear the pause flag,
right? (We'll also obviously need to set the PC and other
register state correctly before resuming the guest.)

thanks
-- PMM

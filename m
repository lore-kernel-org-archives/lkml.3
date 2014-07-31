Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaGaRg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:36:58 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:39626 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaGaRg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:36:56 -0400
MIME-Version: 1.0
In-Reply-To: <53DA7B28.701@redhat.com>
References: <1404914112-7298-1-git-send-email-alex.bennee@linaro.org>
 <53DA7583.2030504@redhat.com> <CAFEAcA9cT617t8JqOXtuO-wQ5xg5T3Sw_DUHB1fpPD6g3SSNaQ@mail.gmail.com>
 <53DA7B28.701@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 31 Jul 2014 18:36:35 +0100
Message-ID: <CAFEAcA8RjmjoaEpjoDE5YJdKagtZYZe9TpCdsRPf86W=WCxCsA@mail.gmail.com>
Subject: Re: [PATCH] arm64: KVM: export current vcpu->pause state via pseudo regs
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        kvm-devel <kvm@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 July 2014 18:21, Paolo Bonzini <pbonzini@redhat.com> wrote:
> What does ARM do if you have a WFI while interrupts are disabled?  On
> x86 after "cli;hlt" only an NMI will wake you up.  With spurious
> wakeups, it's pretty much guaranteed that you will break such "cli;hlt"
> sequences.

The architecture mandates some things that *must* wake you from
a WFI, but it also allows wakeups for other reasons not listed, or
for no reason at all. It's perfectly valid to implement WFI as a NOP
(though it would not be very good for power efficiency, obviously).
Guests which don't surround WFI with a "check whether we should
just go back to WFI" loop are buggy.

thanks
-- PMM

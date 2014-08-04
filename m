Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaHDMgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:36:45 -0400
Received: from static.88-198-71-155.clients.your-server.de ([88.198.71.155]:59287
	"EHLO socrates.bennee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaHDMgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:36:43 -0400
References: <1404914112-7298-1-git-send-email-alex.bennee@linaro.org> <53DA7583.2030504@redhat.com> <CAFEAcA9cT617t8JqOXtuO-wQ5xg5T3Sw_DUHB1fpPD6g3SSNaQ@mail.gmail.com> <53DA7B28.701@redhat.com> <20140804121655.GE524@cbox>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Alex Bennee <alex@bennee.com>, Peter Maydell <peter.maydell@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>, Gleb Natapov <gleb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        "kvmarm\@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] arm64: KVM: export current vcpu->pause state via pseudo regs
Date: Mon, 04 Aug 2014 13:35:15 +0100
In-reply-to: <20140804121655.GE524@cbox>
Message-ID: <877g2ol9dh.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: alex.bennee@linaro.org
X-SA-Exim-Scanned: No (on socrates.bennee.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Christoffer Dall writes:

> On Thu, Jul 31, 2014 at 07:21:44PM +0200, Paolo Bonzini wrote:
>> Il 31/07/2014 19:04, Peter Maydell ha scritto:
>> > On 31 July 2014 17:57, Paolo Bonzini <pbonzini@redhat.com> wrote:
>> >> Il 09/07/2014 15:55, Alex Bennée ha scritto:
<snip>
>> 
>> No, it's not.  It's just the state of the CPU, s390 will be using it too.
>> 
>> On x86 the states are uninitialized (UNINITIALIZED), stopped
>> (INIT_RECEIVED), running (RUNNABLE), halted (HALTED).  CPU 0 starts in
>> RUNNABLE state, other CPUs start in UNINITIALIZED state.  There are
>> x86-specific cases (uninitialized) and x86-isms (the INIT_RECEIVED
>> name), but the idea is widely applicable.
>> 
> Alex, I think it makes perfect sense to use GET/SET_MP_STATE, will you
> revise the patch?

I agree we should use the API that is explicitly for this so I'm looking
at re-doing the patch now.

>
> (Don't forget to update the documentation to reflect it is now supported
> on ARM, and which states are used to represent what there.)
>
> Thanks,
> -Christoffer

-- 
Alex Bennée

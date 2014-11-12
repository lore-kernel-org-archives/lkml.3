Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaKLLUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:20:20 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:51301 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbaKLLUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:20:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: Will Deacon <will.deacon@arm.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "roland@hack.frob.com" <roland@hack.frob.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC] ptrace: add generic SET_SYSCALL request
Date: Wed, 12 Nov 2014 12:19:26 +0100
Message-ID: <6358312.yt5WU3kBm9@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141112111352.GC26437@arm.com>
References: <1415346443-28915-1-git-send-email-takahiro.akashi@linaro.org> <54633F53.8020507@linaro.org> <20141112111352.GC26437@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:2K745KOIfs1V7svF3zE0cSeOZRxce34AF3Pgneqg4Rg
 o4cJf8HcGs3Fp8gFN8+WstGxOTwjddH0Z6H5YCno7NMM0n7PGF
 amRv5rMrInXpnhzVQ+VyfNe3qBLbCbrPgYMD3aoxEDfxl6+rPM
 5iur9YFX2GrZKgQFMheV0zqIHkwRGobLaNc+bBQAoKUjta6EV3
 8l7ZKa6LflSqBH+TJdYWcuwaK9cxsZpPpdetr2A7yuXbnvHmrN
 RFvWq3jhmzdJTVwM4AMMzQCAbzAL7JVttkXjIEwCBhNQQYDJwl
 Z51Vx8JH+WjJ2+kEOaqHpOYq2T/lPsZtQt2uQEiE5el3qcjtMl
 HgGFgZXP8/TC96WrioC8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 November 2014 11:13:52 Will Deacon wrote:
> On Wed, Nov 12, 2014 at 11:06:59AM +0000, AKASHI Takahiro wrote:
> > On 11/12/2014 08:00 PM, Will Deacon wrote:
> > > On Wed, Nov 12, 2014 at 10:46:01AM +0000, AKASHI Takahiro wrote:
> > >> On 11/07/2014 11:04 PM, Oleg Nesterov wrote:
> > >>> To me the fact that PTRACE_SET_SYSCALL can be undefined and syscall_set_nr()
> > >>> is very much arch-dependant (but most probably trivial) means that this  code
> > >>> should live in arch_ptrace().
> > >>
> > >> Thinking of Oleg's comment above, it doesn't make sense neither to define generic
> > >> NT_SYSTEM_CALL (user_regset) in uapi/linux/elf.h and implement it in ptrace_regset()
> > >> in kernel/ptrace.c with arch-defined syscall_(g)set_nr().
> > >>
> > >> Since we should have the same interface on arm and arm64, we'd better implement
> > >> ptrace(PTRACE_SET_SYSCALL) locally on arm64 for now (as I originally submitted).
> > >
> > > I think the regset approach is cleaner. We already do something similar for
> > > TLS. That would be implemented under arch/arm64/ with it's own NT type.
> > 
> > Okey, so arm64 goes its own way 
> > Or do you want to have a similar regset on arm, too?
> > (In this case, NT_ARM_SYSTEM_CALL can be shared in uapi/linux/elf.h)
> 
> Just do arm64. We already have the dedicated request for arch/arm/.

I wonder if we should define NT_ARM64_SYSTEM_CALL to the same value
as NT_S390_SYSTEM_CALL (0x307), or even define it as an architecture-
independent NT_SYSTEM_CALL number with that value, so other architectures
don't have to introduce new types when they also want to implement it.

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab3GONzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 09:55:08 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63905 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756323Ab3GONzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 09:55:05 -0400
Date: Mon, 15 Jul 2013 14:54:20 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jed Davis <jld@mozilla.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Robert Richter <rric@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>
Subject: Re: [PATCH] ARM: Fix r7/r11 confusion when CONFIG_THUMB2_KERNEL=y
Message-ID: <20130715135420.GG10000@mudshark.cambridge.arm.com>
References: <1373685501-1620-1-git-send-email-jld@mozilla.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373685501-1620-1-git-send-email-jld@mozilla.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jed,

On Sat, Jul 13, 2013 at 04:18:20AM +0100, Jed Davis wrote:
> There is currently some inconsistency about the "frame pointer" on ARM.
> r11 is the register with assemblers recognize and disassemblers often
> print as "fp", and which is sufficient for stack unwinding when using
> the APCS frame pointer option; but when unwinding with the Exception
> Handling ABI, the register GCC uses when a constant offset won't suffice
> (or when -fno-omit-frame-pointer is used; see kernel/sched/Makefile in
> particular) is r11 on ARM and r7 on Thumb.
> 
> Correspondingly, arch/arm/include/uapi/arm/ptrace.h defines ARM_fp to
> refer to r11, but arch/arm/kernel/unwind.c uses "FP" to mean either r11
> or r7 depending on Thumbness, and it is unclear what other cases such as
> the "fp" in struct stackframe should be doing.
> 
> Effects of this are probably limited to failure of EHABI unwinding when
> starting from a function that uses r7 to restore its stack pointer, but
> the possibility for further breakage (which would be invisible on
> non-Thumb kernels) is worrying.
> 
> With this change, it is hoped, r7 is consistently referred to as "r7",
> and "fp" always means r11; this costs a few extra ifdefs, but it should
> help prevent future issues.

I'm struggling to understand exactly the problem that this patch is trying
to address. If it's just a code consistency issue, I don't think it's worth
it (I actually find it less confusing the way we currently have things) but
if there is a real bug, perhaps you could provide a testcase?

Cheers,

Will

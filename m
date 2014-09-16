Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbaIPNWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 09:22:35 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:61709 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbaIPNWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 09:22:34 -0400
Date: Tue, 16 Sep 2014 15:22:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Nadav Amit <namit@cs.technion.ac.il>
Cc: pbonzini@redhat.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        x86@kernel.org, kvm@vger.kernel.org, nadav.amit@gmail.com,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 0/3] x86: structs for cpuid info in x86
Message-ID: <20140916132226.GA13726@gmail.com>
References: <1410870160-28845-1-git-send-email-namit@cs.technion.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410870160-28845-1-git-send-email-namit@cs.technion.ac.il>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nadav Amit <namit@cs.technion.ac.il> wrote:

> The code that deals with x86 cpuid fields is hard to follow since it performs
> many bit operations and does not refer to cpuid field explicitly.  To
> eliminate the need of openning a spec whenever dealing with cpuid fields, this
> patch-set introduces structs that reflect the various cpuid functions.
> 
> Thanks for reviewing the patch-set.
> 
> Nadav Amit (3):
>   x86: Adding structs to reflect cpuid fields
>   x86: Use new cpuid structs in cpuid functions
>   KVM: x86: Using cpuid structs in KVM
> 
>  arch/x86/include/asm/cpuid_def.h | 163 +++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/common.c     |  56 ++++++++------
>  arch/x86/kvm/cpuid.c             |  36 +++++----
>  3 files changed, 219 insertions(+), 36 deletions(-)
>  create mode 100644 arch/x86/include/asm/cpuid_def.h

I personally like bitfields in theory (they provide type clarity 
and abstract robustness, compared to open-coded bitmask numeric 
literals that are often used in cpuid using code, obfuscating 
cpuid usage), with the big caveat that for many years I didn't 
like bitfields in practice: older versions of GCC did a really 
poor job of optimizing them.

So such a series would only be acceptable if it's demonstrated 
that both 'latest' and 'reasonably old' GCC versions do a good 
job in that department, compared to the old open-coded bitmask 
ops ...

Comparing the 'size vmlinux' output of before/after kernels would 
probably be a good start in seeing the impact of such a change.

If those results are positive then this technique could be 
propagated to all cpuid using code in arch/x86/, of which
there's plenty.

Thanks,

	Ingo

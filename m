Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394AbaJPLtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 07:49:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36612 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbaJPLtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 07:49:22 -0400
Date: Thu, 16 Oct 2014 13:49:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Subject: Re: [RFC 2/5] x86: Store a per-cpu shadow copy of CR4
Message-ID: <20141016114917.GD25025@nazgul.tnic>
References: <cover.1413323611.git.luto@amacapital.net>
 <808fa43ef6e24d1df47c2666174d997105b9582d.1413323611.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <808fa43ef6e24d1df47c2666174d997105b9582d.1413323611.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 03:57:36PM -0700, Andy Lutomirski wrote:
> Context switches and TLB flushes can change individual bits of CR4.
> CR4 reads take several cycles, so store a shadow copy of CR4 in a
> per-cpu variable.
> 
> To avoid wasting a cache line, I added the CR4 shadow to
> cpu_tlbstate, which is already touched during context switches.

So does this even show in any workloads as any improvement?

Also, what's the rule with reading the shadow CR4? kvm only? Because
svm_set_cr4() in svm.c reads the host CR4 too.

Should we make all code access the shadow CR4 maybe...

-- 
Regards/Gruss,
    Boris.
--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300AbaKAT4d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 15:56:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:47410 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758469AbaKAT4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 15:56:30 -0400
Date: Sat, 1 Nov 2014 20:56:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Vince Weaver <vince@deater.net>, "hillf.zj" <hillf.zj@alibaba-inc.com>,
        x86@kernel.org
Subject: Re: [PATCH v2 3/8] x86: Store a per-cpu shadow copy of CR4
In-Reply-To: <3a54dd3353fffbf84804398e00dfdc5b7c1afd7d.1414190806.git.luto@amacapital.net>
Message-ID: <alpine.DEB.2.11.1411012056080.5308@nanos>
References: <cover.1414190806.git.luto@amacapital.net> <3a54dd3353fffbf84804398e00dfdc5b7c1afd7d.1414190806.git.luto@amacapital.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014, Andy Lutomirski wrote:

> Context switches and TLB flushes can change individual bits of CR4.
> CR4 reads take several cycles, so store a shadow copy of CR4 in a
> per-cpu variable.
> 
> To avoid wasting a cache line, I added the CR4 shadow to
> cpu_tlbstate, which is already touched in switch_mm.  The heaviest
> users of the cr4 shadow will be switch_mm and __switch_to_xtra, and
> __switch_to_xtra is called shortly after switch_mm during context
> switch, so the cacheline is likely to be hot.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280AbaDABJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 21:09:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:4230 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbaDABJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 21:09:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,769,1389772800"; 
   d="scan'208";a="511478269"
Date: Mon, 31 Mar 2014 18:09:01 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Gleb Natapov <gleb@redhat.com>,
        Peter Anvin <hpa@zytor.com>, hubicka@ucw.cz,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86 LTO changes for v3.15
Message-ID: <20140401010901.GJ32556@tassilo.jf.intel.com>
References: <201403312105.s2VL5AqX010173@terminus.zytor.com>
 <CA+55aFwccMZNgHA_xS_+cLNPqEjAt4qm2LYK_WLU0XbeDOoa=g@mail.gmail.com>
 <20140331230347.GH32556@tassilo.jf.intel.com>
 <CA+55aFyOPkCO7Cpf7pG1wD3QL0CVwKrcf+zKVka51ROABFGn-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyOPkCO7Cpf7pG1wD3QL0CVwKrcf+zKVka51ROABFGn-w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  - don't do the __visible as part of asmlinkage, because it really is
> conceptually wrong

Ok.

> 
>  - add the visible to the SYSCALL_DEFINEx() macros

I think SYSCALL_DEFINE actually doesn't need it, as the syscall
tables are visible in C. Only the syscall table itself
needs to be visible.


> and after that I strongly suspect that there will be only a handful of
> cases left that are called from assembly language and that aren't
> system calls. Things like "printk()" and friends that are really
> special. They'd need a few manual "__visible" annotations.

Ok. I think it's more than a handful though.

I'll cook up a patch.

> See above: I can pretty much guarantee that you should *not* need do
> any crazy automated sweeps.  Because you shouldn't need "__visible" at
> the declarations in the header files, only at the definition of the
> function, right? 

Yes that's right.

-Andi

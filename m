Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaDATFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 15:05:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:36990 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbaDATFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 15:05:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,774,1389772800"; 
   d="scan'208";a="512088067"
Message-ID: <533B0B5F.2040907@linux.intel.com>
Date: Tue, 01 Apr 2014 11:54:23 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>
CC: Gleb Natapov <gleb@redhat.com>, Peter Anvin <hpa@zytor.com>,
        Jan Hubicka <hubicka@ucw.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86 LTO changes for v3.15
References: <201403312105.s2VL5AqX010173@terminus.zytor.com>	<CA+55aFwccMZNgHA_xS_+cLNPqEjAt4qm2LYK_WLU0XbeDOoa=g@mail.gmail.com>	<20140331230347.GH32556@tassilo.jf.intel.com>	<CA+55aFyOPkCO7Cpf7pG1wD3QL0CVwKrcf+zKVka51ROABFGn-w@mail.gmail.com> <CA+55aFxCCOASxhgRfGmNRPgHwZQJ2Q0Oa9-vwpMdmTqx99m26g@mail.gmail.com>
In-Reply-To: <CA+55aFxCCOASxhgRfGmNRPgHwZQJ2Q0Oa9-vwpMdmTqx99m26g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 05:33 PM, Linus Torvalds wrote:
> 
> I notice that there seems to be a handful of x86 system calls that
> don't use the SYSCALL_DEFINEx() macros to define the system call, some
> grepping finds at least ioperm(), modify_ldt(), sigreturn() and
> rt_sigreturn(). There are probably others. They should just be
> converted to SYSCALL_DEFINEx() while at it. No, x86 doesn't need the
> typecasting, but it won't hurt either, and it's good to be consistent.
> 
> I'm not sure why those system calls didn't get converted (other
> x86-specific ones like vm86() _have_ gotten converted), maybe there's
> some reason for it. But I *think* the reason is "nobody noticed".
> 

Pretty much.  If nothing else, it breaks tracing.

	-hpa



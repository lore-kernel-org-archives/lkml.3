Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab3GUVkV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 17:40:21 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36150 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751413Ab3GUVkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 17:40:20 -0400
Date: Sun, 21 Jul 2013 22:39:37 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jed Davis <jld@mozilla.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: perf: Implement perf_arch_fetch_caller_regs
Message-ID: <20130721213937.GB29879@mudshark.cambridge.arm.com>
References: <1373685434-1581-1-git-send-email-jld@mozilla.com>
 <20130715135342.GF10000@mudshark.cambridge.arm.com>
 <20130720034321.GB9433@mozilla.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130720034321.GB9433@mozilla.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 04:43:21AM +0100, Jed Davis wrote:
> On Mon, Jul 15, 2013 at 02:53:42PM +0100, Will Deacon wrote:
> > > +				     "mov %[_pc],  r15\n\t"		\
> > > +				     "mrs %[_cpsr], cpsr\n\t"		\
> > > +				     : [_cpsr] "=r" (_cpsr),		\
> > > +				       [_pc] "=r" (_pc)			\
> > > +				     : [_regs] "r" (&(regs)->uregs)	\
> > 
> > It would be cleaner to pass a separate argument for each register, using the
> > ARM_rN macros rather than calculating the offset by hand.
> 
> I'll do that.  If there were more arguments there might be a problem
> at -O0, because the naive translation can run out of registers in
> some cases, but that shouldn't be a problem here.  (Nor if someone
> later extends this to all the core registers, because {r0-r13} can and
> presumably should use a store-multiple.)

We already rely on compiler optimisation for things like tlbflush.h, so we
don't need to worry about building with -O0.

Please send a v2 when you get a chance!

Will

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab3EJKpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:45:32 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58452
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752399Ab3EJKpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:45:31 -0400
Date: Fri, 10 May 2013 12:43:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Neuling <mikey@neuling.org>
Cc: eranian@google.com, Linux PPC dev <linuxppc-dev@ozlabs.org>,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au,
        Anshuman Khandual <anshuman.khandual@in.ibm.com>
Subject: Re: Invalid perf_branch_entry.to entries question
Message-ID: <20130510104352.GF31235@dyad.programming.kicks-ass.net>
References: <25394.1367890528@ale.ozlabs.ibm.com>
 <20130508155929.GA8459@dyad.programming.kicks-ass.net>
 <14691.1368052755@ale.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14691.1368052755@ale.ozlabs.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 08:39:15AM +1000, Michael Neuling wrote:
> > Just because I'm curious.. however does that happen? Surely the CPU
> > knows where next to fetch instructions?
> 
> For computed gotos (ie. branch to a register value), the hardware gives
> you the from and to address in the branch history buffer.
> 
> For branches where the branch target address is an immediate encoded in
> the instruction, the hardware only logs the from address.  It assumes
> that software (perf irq handler in this case) can read this branch
> instruction, calculate the corresponding offset and hence the
> to/target address.
> 
> It's entirely possible that when the perf IRQ handler happens, the
> instruction in question is not readable or is no longer a branch (self
> modifying code).  Hence we aren't able to calculate a valid to address.

Ohh how cute! You've gotta love lazy hardware :-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab3EHQBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:01:12 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:48273
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756213Ab3EHQBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:01:09 -0400
Date: Wed, 8 May 2013 17:59:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Neuling <mikey@neuling.org>
Cc: eranian@google.com, Linux PPC dev <linuxppc-dev@ozlabs.org>,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au,
        Anshuman Khandual <anshuman.khandual@in.ibm.com>
Subject: Re: Invalid perf_branch_entry.to entries question
Message-ID: <20130508155929.GA8459@dyad.programming.kicks-ass.net>
References: <25394.1367890528@ale.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25394.1367890528@ale.ozlabs.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 11:35:28AM +1000, Michael Neuling wrote:
> Peter & Stephane,
> 
> We are plumbing the POWER8 Branch History Rolling Buffer (BHRB) into
> struct perf_branch_entry.
> 
> Sometimes on POWER8 we may not be able to fill out the "to" address.  

Just because I'm curious.. however does that happen? Surely the CPU knows where
next to fetch instructions?

> We
> initially thought of just making this 0, but it's feasible that this
> could be a valid address to branch to. 

Right, while highly unlikely, x86 actually has some cases where 0 address is
valid *shudder*..

> The other logical value to indicate an invalid entry would be all 1s
> which is not possible (on POWER at least).
> 
> Do you guys have a preference as to what we should use as an invalid
> entry?  This would have some consequences for the userspace tool also.
> 
> The alternative would be to add a flag alongside mispred/predicted to
> indicate the validity of the "to" address.

Either would work with me I suppose.. Stephane do you have any preference?

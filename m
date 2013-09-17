Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab3IQXYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 19:24:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:55552 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab3IQXYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 19:24:02 -0400
Date: Wed, 18 Sep 2013 01:23:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
        ak@linux.intel.com, hpa@zytor.com, bitbucket@online.de,
        arjan@linux.intel.com, fweisbec@gmail.com
Subject: Re: [patch 5/6] sparc: Use preempt_schedule_irq
In-Reply-To: <20130917.185428.2155214782234196428.davem@davemloft.net>
Message-ID: <alpine.DEB.2.02.1309180120570.4089@ionos.tec.linutronix.de>
References: <20130917082838.218329307@infradead.org> <20130917182350.449685712@linutronix.de> <20130917183628.966769884@linutronix.de> <20130917.185428.2155214782234196428.davem@davemloft.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Sep 2013, David Miller wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Tue, 17 Sep 2013 18:53:08 -0000
> 
> >  		bne,pn			%xcc, kern_fpucheck
> > -		 sethi			%hi(PREEMPT_ACTIVE), %l6
> > -		stw			%l6, [%g6 + TI_PRE_COUNT]
> > -		call			schedule
> > +		call			preempt_schedule_irq
> >  		 nop
> 
> You've put the function call into the delay slot of the branch,
> which you don't want to do.
> 
> That's, btw, why we indent instructions with an extra space like
> that, to emphasize that it's a delay slot of the preceeding
> branch.

I knew that I'd get it wrong :) So is adding another nop the right
thing to do ?

 		bne,pn			%xcc, kern_fpucheck
-		 sethi			%hi(PREEMPT_ACTIVE), %l6
-		stw			%l6, [%g6 + TI_PRE_COUNT]
-		call			schedule
+  		 nop
+		call			preempt_schedule_irq
  		 nop
 
Thanks,

	tglx

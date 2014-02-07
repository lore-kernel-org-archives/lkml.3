Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbaBGM5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:57:00 -0500
Received: from verein.lst.de ([213.95.11.211]:43542 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715AbaBGLtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:49:55 -0500
Date: Fri, 7 Feb 2014 12:49:49 +0100
From: Torsten Duwe <duwe@lst.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Scott Wood <scottwood@freescale.com>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Tom Musta <tommusta@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] Convert powerpc simple spinlocks into ticket locks
Message-ID: <20140207114949.GA2107@lst.de>
References: <20140206103736.GA18054@lst.de> <20140206163837.GT2936@laptop.programming.kicks-ass.net> <20140206173727.GA13048@lst.de> <1391717992.6733.232.camel@snotra.buserror.net> <20140207090248.GB26811@lst.de> <20140207103139.GP5002@laptop.programming.kicks-ass.net> <20140207104530.GG5126@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207104530.GG5126@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 11:45:30AM +0100, Peter Zijlstra wrote:
> 
> That might need to be lhz too, I'm confused on all the load variants.

;-)

> > unlock:
> > 	lhz	%0, 0, &tail
> > 	addic	%0, %0, 1

No carry with this one, I'd say.
Besides, unlock increments the head.

> > 	lwsync
> > 	sth	%0, 0, &tail
> > 

Given the beauty and simplicity of this, may I ask Ingo:
you signed off 314cdbefd1fd0a7acf3780e9628465b77ea6a836;
can you explain why head and tail must live on the same cache
line? Or is it just a space saver? I just ported it to ppc,
I didn't think about alternatives.

What about

atomic_t tail;
volatile int head; ?

Admittedly, that's usually 8 bytes instead of 4...

	Torsten


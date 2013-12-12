Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab3LLPov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 10:44:51 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:56397 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751674Ab3LLPou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 10:44:50 -0500
Date: Thu, 12 Dec 2013 10:44:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] wait-simple: Introduce the simple waitqueue
 implementation
Message-ID: <20131212104446.40b616c3@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.02.1312121600020.28330@ionos.tec.linutronix.de>
References: <1386810399-8973-1-git-send-email-paul.gortmaker@windriver.com>
	<1386810399-8973-2-git-send-email-paul.gortmaker@windriver.com>
	<20131212080314.GA25783@infradead.org>
	<alpine.DEB.2.02.1312121147130.28330@ionos.tec.linutronix.de>
	<52A9CCA6.6040806@windriver.com>
	<20131212095533.1fab411f@gandalf.local.home>
	<alpine.DEB.2.02.1312121600020.28330@ionos.tec.linutronix.de>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Dec 2013 16:25:42 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 12 Dec 2013, Steven Rostedt wrote:
> > On Thu, 12 Dec 2013 09:48:06 -0500
> > Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> >  
> > > 1) git mv wait.[ch] --- > cwait.[ch]
> > >    make an empty wait.h include cwait.h temporarily
> > > 
> > > 2) rename all existing functions in cwait.[ch] to have an added
> > >   "c" prefix (or similar)
> > >    
> > >    in wait.h, temporarily add a bunch of things like
> > >           #define wait_xyz  cwait_xyz
> > >    so that things still compile and link.
> > 
> > What about instead change all users of wait_*() to cwait_*().
> > 
> > Then the next steps would be to skip 3 and jump right to 4)
> > 
> > > 
> > > 3) track down the users who really need the extra complexity
> > >    and have them use cwait calls and include cwait.h
> > > 
> > > 4) bring in the simple wait queue support as wait.c and wait.h
> > >    and delete the defines added in step two.  This will be the
> > >    flag day commit.
> > 
> > Not a flag day commit, as no one is using it. Then start converting all
> > users back to the wait_*() functions one at a time. If something
> > breaks, we know which one it was.
> 
> I don't think its a good idea to flip the name spaces.
> 
> We should rather convert the existing stuff over to cwait or whatever
> and keep the swait for the new facility. So it breaks everything which
> is trying to use wait*
> 
>        - out of tree code
>        - students copying from ldd3
>        - ...
>        [ not that I care much about any of that ]
> 
> in a very obvious way.
> 

That still happens in my approach too, in the same step. When the
simple wait queue is added, everything will break that uses it when it
should not have. That includes, out of tree code, students copying
from ldd3, etc.

And it too will break in a very obvious way.

-- Steve

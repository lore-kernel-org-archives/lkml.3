Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaLaNTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 08:19:40 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:40185 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaLaNTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 08:19:38 -0500
Date: Wed, 31 Dec 2014 05:19:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Pranith Kumar <bobby.prani@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "supporter:S390" <linux390@de.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Scott Wood <scottwood@freescale.com>,
        Anton Blanchard <anton@samba.org>, Daniel Walter <dwalter@google.com>,
        Tiejun Chen <tiejun.chen@windriver.com>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jens Freimann <jfrei@linux.vnet.ibm.com>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:S390" <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v2] srcu: Isolate srcu sections using CONFIG_SRCU
Message-ID: <20141231131930.GQ11609@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1419918382-4758-1-git-send-email-bobby.prani@gmail.com>
 <1419918382-4758-2-git-send-email-bobby.prani@gmail.com>
 <20141230185008.GA23965@worktop.programming.kicks-ass.net>
 <CAJhHMCDsxOsBKphPrH8N5ymPgdN_OVSujQWQt5CB52TK2PO9cA@mail.gmail.com>
 <20141230190740.GC23965@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141230190740.GC23965@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14123113-0033-0000-0000-0000032BC19B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2014 at 08:07:40PM +0100, Peter Zijlstra wrote:
> On Tue, Dec 30, 2014 at 01:54:07PM -0500, Pranith Kumar wrote:
> > On Tue, Dec 30, 2014 at 1:50 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Tue, Dec 30, 2014 at 12:46:22AM -0500, Pranith Kumar wrote:
> > >> Isolate the SRCU functions and data structures within CONFIG_SRCU so that there
> > >> is a compile time failure if srcu is used when not enabled. This was decided to
> > >> be better than waiting until link time for a failure to occur.
> > >
> > > Why?
> > 
> > This is part of the kernel tinification efforts. The first patch was
> > posted here: https://lkml.org/lkml/2014/12/4/848. This patch enables a
> > compile time failure instead of a link time failure.
> 
> can't be arsed to click. again, why does it matter when it fails,
> neither stages produces a working kernel so tinification cannot be the
> purpose.

In fairness, Pranith's original submission did force the failure at
link time.  One piece of feedback was to force the failure at compile
time (can't remember from who).  But given the hassles encountered with
compile-time failure, it might well be getting to the point where it is
time to fall back to the link-time-failure approach.

							Thanx, Paul


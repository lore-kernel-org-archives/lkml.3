Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbaFJMwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:52:43 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49873 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbaFJMwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:52:40 -0400
Date: Tue, 10 Jun 2014 05:52:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
 unprotected when accessed by /proc)
Message-ID: <20140610125234.GI4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140603130233.658a6a3c@gandalf.local.home>
 <20140603172632.GA27956@redhat.com>
 <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com>
 <20140603200125.GB1105@redhat.com>
 <20140606203350.GU4581@linux.vnet.ibm.com>
 <20140608130718.GA11129@redhat.com>
 <20140609162613.GE4581@linux.vnet.ibm.com>
 <20140610083726.GY3213@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610083726.GY3213@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061012-0928-0000-0000-000002983BBA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 10:37:26AM +0200, Peter Zijlstra wrote:
> On Mon, Jun 09, 2014 at 09:26:13AM -0700, Paul E. McKenney wrote:
> > That would indeed be a bad thing, as it could potentially lead to
> > use-after-free bugs.  Though one could argue that any code that resulted
> > in use-after-free would be quite aggressive.  But still...
> 
> Let me hijack this thread for yet another issue... So I had an RCU
> related use-after-free the other day, and while Sasha was able to
> trigger it quite easily, I had a multi-day struggle to reproduce.
> 
> Once I figured out what the exact problem was it was also clear to me
> why it was so hard for me to reproduce.
> 
> So normally its easier to trigger races on bigger machines, more cpus,
> more concurrency, more races, all good.
> 
> _However_ with RCU the grace period machinery is slower the bigger the
> machine, so bigger machine, slower grace period, slower RCU free, less
> likely to hit use-after-free.
> 
> So I was thinking, and I know you all will go kick me for this because
> the very last thing we need is what I'm about to propose: more RCU
> flavours :-).
> 
> How about an rcu_read_unlock() reference counted RCU variant that's
> ultra aggressive in doing the callbacks in order to better trigger such
> issues?

If you are using synchronize_rcu() for the update side, then I suggest
rcutorture.gp_exp=1 to force use expediting throughout.

							Thanx, Paul


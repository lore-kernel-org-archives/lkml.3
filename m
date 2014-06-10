Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbaFJUF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:05:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:55078 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbaFJUF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:05:27 -0400
Date: Tue, 10 Jun 2014 22:05:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand unprotected
 when accessed by /proc)
In-Reply-To: <20140610141306.04a4bcf3@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1406102203430.5170@nanos>
References: <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com> <20140603200125.GB1105@redhat.com> <20140606203350.GU4581@linux.vnet.ibm.com> <20140608130718.GA11129@redhat.com> <20140609162613.GE4581@linux.vnet.ibm.com> <20140609181553.GA13681@redhat.com>
 <20140609142956.3d79e9d1@gandalf.local.home> <CA+55aFyO8bb7fS3AaQzfMq7geERQ1JpSdcRZ9Fbs5-tZP0oRXg@mail.gmail.com> <20140609154114.20585056@gandalf.local.home> <alpine.DEB.2.10.1406101051210.3830@nanos> <20140610165704.GA3110@redhat.com>
 <alpine.DEB.2.10.1406101959420.5170@nanos> <20140610141306.04a4bcf3@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Steven Rostedt wrote:
> On Tue, 10 Jun 2014 20:08:37 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> 
> > > Perhaps it could simply do ->owner = RT_MUTEX_HAS_WAITERS to make this more
> > > clear...
> > 
> > Good point. The new owner can cleanup the mess.
> >  
> 
> I thought about this too. It should work with the added overhead that
> every time we go into the unlock slow path, we guarantee that the next
> lock will go into the lock slowpath.
> 
> As long as the new acquired lock does a fast unlock, then we get out of
> this spiral.

The alternative solution is to document WHY this is safe. I think I
prefer that one :)

Thanks,

	tglx



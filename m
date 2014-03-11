Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbaCKLCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 07:02:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49240 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364AbaCKLCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 07:02:23 -0400
Date: Tue, 11 Mar 2014 12:02:02 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Waiman Long <waiman.long@hp.com>, arnd@arndb.de,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, walken@google.com, andi@firstfloor.org,
        riel@redhat.com, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, oleg@redhat.com
Subject: Re: [RFC][PATCH 0/7] locking: qspinlock
Message-ID: <20140311110202.GT27965@twins.programming.kicks-ass.net>
References: <20140310154236.038181843@infradead.org>
 <20140311104503.GA10916@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140311104503.GA10916@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 11:45:03AM +0100, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Hi Waiman,
> > 
> > I promised you this series a number of days ago; sorry for the delay 
> > I've been somewhat unwell :/
> > 
> > That said, these few patches start with a (hopefully) simple and 
> > correct form of the queue spinlock, and then gradually build upon 
> > it, explaining each optimization as we go.
> > 
> > Having these optimizations as separate patches helps twofold; 
> > firstly it makes one aware of which exact optimizations were done, 
> > and secondly it allows one to proove or disprove any one step; 
> > seeing how they should be mostly identity transforms.
> > 
> > The resulting code is near to what you posted I think; however it 
> > has one atomic op less in the pending wait-acquire case for NR_CPUS 
> > != huge. It also doesn't do lock stealing; its still perfectly fair 
> > afaict.
> > 
> > Have I missed any tricks from your code?
> 
> Waiman, you indicated in the other thread that these look good to you, 
> right? If so then I can queue them up so that they form a base for 
> further work.

Ah, no that was on the qrwlock; I think we managed to cross wires
somewhere.

I've got this entire pile waiting for something:

  lkml.kernel.org/r/20140210195820.834693028@infradead.org

That's 5 mutex patches and the 2 qrwlock patches. Not sure what to do
with them. To merge or not, that is the question.

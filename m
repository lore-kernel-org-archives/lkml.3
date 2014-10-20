Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaJTQrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 12:47:22 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:4096 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751331AbaJTQrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 12:47:20 -0400
Date: Mon, 20 Oct 2014 12:47:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>, <linux-rt-users@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/7] wait.[ch]: Introduce the simple waitqueue (swait)
 implementation
Message-ID: <20141020124716.465dce45@gandalf.local.home>
In-Reply-To: <20141020160542.GG24595@windriver.com>
References: <1413591782-23453-1-git-send-email-paul.gortmaker@windriver.com>
	<1413591782-23453-4-git-send-email-paul.gortmaker@windriver.com>
	<20141018213417.GE23531@worktop.programming.kicks-ass.net>
	<1413673519.30326.11.camel@pippen.local.home>
	<20141020152144.GF24595@windriver.com>
	<20141020114013.31e5137c@gandalf.local.home>
	<20141020160542.GG24595@windriver.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2014 12:05:42 -0400
Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
 
> > No. You move the items off the main list head and add it to the local
> > list and they never go back. Just start processing that local list.
> > Anything added to the main list after that will not get woken up by
> > that current wake_all call. It will need to be woken by another wake_up.
> 
> OK.  But we may not run all of the wakeups, because of:
> 
> +                       if (++woken == nr_exclusive)
> +                               break;
> 
> > 
> > > 
> > > What would need to be done as an unwind at the end of processing the
> > > local list head before it disappears from existence?  Anything?
> > 
> > Not sure what you mean here.
> 
> Per above -- can't there be "orphaned" entries that only exist on the
> local list head that didn't get processed?  What happens to those?
> 

Why not just take off nr_exclusive tasks off the main list and add
those to the local list, and then wake up all on the local list?

-- Steve

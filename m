Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab3HLOPC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 10:15:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56613 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670Ab3HLOO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 10:14:59 -0400
Date: Mon, 12 Aug 2013 16:14:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/8] rcu: eliminate deadlock for rcu read site
Message-ID: <20130812141449.GI27162@twins.programming.kicks-ass.net>
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
 <1375871104-10688-6-git-send-email-laijs@cn.fujitsu.com>
 <20130808204020.GA31127@linux.vnet.ibm.com>
 <5205B6FF.7060502@cn.fujitsu.com>
 <20130812135309.GF27162@twins.programming.kicks-ass.net>
 <20130812101008.27048d83@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130812101008.27048d83@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 10:10:08AM -0400, Steven Rostedt wrote:
> On Mon, 12 Aug 2013 15:53:10 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Sat, Aug 10, 2013 at 11:43:59AM +0800, Lai Jiangshan wrote:
> > > Hi, Steven
> > > 
> > > I was considering rtmutex's lock->wait_lock is a scheduler lock,
> > > But it is not, and it is just a spinlock of process context.
> > > I hope you change it to a spinlock of irq context.
> > 
> > rwmutex::wait_lock is irq-safe; it had better be because its taken under
> > task_struct::pi_lock. 
> 
> It is? I thought it was the other way around. That is, pi_lock is taken
> under wait_lock.

Urgh, right you are. 

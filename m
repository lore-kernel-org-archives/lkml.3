Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab3HLNx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:53:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56193 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab3HLNx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:53:26 -0400
Date: Mon, 12 Aug 2013 15:53:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH 5/8] rcu: eliminate deadlock for rcu read site
Message-ID: <20130812135309.GF27162@twins.programming.kicks-ass.net>
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
 <1375871104-10688-6-git-send-email-laijs@cn.fujitsu.com>
 <20130808204020.GA31127@linux.vnet.ibm.com>
 <5205B6FF.7060502@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5205B6FF.7060502@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 10, 2013 at 11:43:59AM +0800, Lai Jiangshan wrote:
> Hi, Steven
> 
> I was considering rtmutex's lock->wait_lock is a scheduler lock,
> But it is not, and it is just a spinlock of process context.
> I hope you change it to a spinlock of irq context.

rwmutex::wait_lock is irq-safe; it had better be because its taken under
task_struct::pi_lock. 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab3FYXBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 19:01:34 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:48827 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab3FYXBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 19:01:33 -0400
Date: Tue, 25 Jun 2013 16:01:29 -0700
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clark@redhat.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: question about disabling interrupts for workqueue pool?
Message-ID: <20130625230129.GA30407@mtj.dyndns.org>
References: <1372200754.18733.236.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372200754.18733.236.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Steven.

On Tue, Jun 25, 2013 at 06:52:34PM -0400, Steven Rostedt wrote:
> Now my question is, are those local_irq_*() calls just for synchronizing
> with sched RCU? If so, can you use rcu_read_lock_sched() instead?

Hmmm... using local_irq_disable/enable() is more consistent as
irq-safe locks are used widely in workqueue.  Also, using
rcu_read_lock_sched() would mean that we'll have
spin_lock_irq_save/restore() nested inside preempt_disable/enable(),
which is a bit silly in upstream kernel.

That said, both paths you pointed out are rather cold, so I don't
think it'd matter.  Please feel free to send a patch with comment
explaining why local irq flipping, which fits better there, isn't
being used.

Thanks.

-- 
tejun

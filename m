Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab3GAPeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 11:34:16 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39862 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab3GAPeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 11:34:15 -0400
X-Originating-IP: 50.43.39.152
Date: Mon, 1 Jul 2013 08:33:59 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full v2 3/7] nohz_full: Add per-CPU idle-state
 tracking
Message-ID: <20130701153359.GC2923@leaf>
References: <20130628200949.GA17458@linux.vnet.ibm.com>
 <1372450222-19420-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1372450222-19420-3-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372450222-19420-3-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 01:10:18PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> This commit adds the code that updates the rcu_dyntick structure's
> new fields to track the per-CPU idle state based on interrupts and
> transitions into and out of the idle loop (NMIs are ignored because NMI
> handlers cannot cleanly read out the time anyway).  This code is similar
> to the code that maintains RCU's idea of per-CPU idleness, but differs
> in that RCU treats CPUs running in user mode as idle, where this new
> code does not.
[...]
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -2380,6 +2380,76 @@ static void rcu_kick_nohz_cpu(int cpu)
>  #ifdef CONFIG_NO_HZ_FULL_SYSIDLE
>  
>  /*
> + * Invoked to note exit from irq or task transition to idle.  Note that
> + * usermode execution does -not- count as idle here!  The caller must
> + * have disabled interrupts.

Can you explain in the comments why this code doesn't treat userspace as
idle/quiesced?

- Josh Triplett

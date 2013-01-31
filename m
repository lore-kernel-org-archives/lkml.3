Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab3AaUXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 15:23:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3AaUXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 15:23:44 -0500
Date: Thu, 31 Jan 2013 12:23:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 00/40] CPU hotplug rework - episode I
Message-Id: <20130131122342.31b28664.akpm@linux-foundation.org>
In-Reply-To: <20130131120348.372374706@linutronix.de>
References: <20130131120348.372374706@linutronix.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013 15:44:10 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> At the end hotplug should run through an array of callbacks on both
> sides with explicit core synchronization points. The ordering should
> look like this:
> 
> CPUHP_OFFLINE                   // Start state.
> CPUHP_PREP_<hardware>           // Kick CPU into life / let it die
> CPUHP_PREP_<datastructures>     // Get datastructures set up / freed.
> CPUHP_PREP_<threads>            // Create threads for cpu
> CPUHP_SYNC			// Synchronization point
> CPUHP_INIT_<hardware>		// Startup/teardown on the CPU (interrupts, timers ...)
> CPUHP_SCHED_<stuff on CPU>      // Unpark/park per cpu local threads on the CPU.
> CPUHP_ENABLE_<stuff_on_CPU>	// Enable/disable facilities 
> CPUHP_SYNC			// Synchronization point
> CPUHP_SCHED                     // Expose/remove CPU from general scheduler.
> CPUHP_ONLINE                    // Final state

What does CPUHP_SYNC do?

Methinks Tejun needed a cc on this lot ;)

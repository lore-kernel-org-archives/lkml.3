Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab3GAU4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:56:03 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63563 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab3GAU4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:56:01 -0400
Date: Mon, 1 Jul 2013 22:55:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full v2 6/7] nohz_full: Add full-system-idle
 state machine
Message-ID: <20130701205554.GQ7246@somewhere.redhat.com>
References: <20130628200949.GA17458@linux.vnet.ibm.com>
 <1372450222-19420-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1372450222-19420-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130701163529.GO7246@somewhere.redhat.com>
 <20130701181040.GO3773@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130701181040.GO3773@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 11:10:40AM -0700, Paul E. McKenney wrote:
> On Mon, Jul 01, 2013 at 06:35:31PM +0200, Frederic Weisbecker wrote:
> > What makes sure that we are not reading a stale value of rdtp->dynticks_idle
> > in the following scenario:
> > 
> >     CPU 0                          CPU 1
> >     
> >                                    //CPU 1 idle
> >                                    //rdtp(1)->dynticks_idle == 0
> > 
> > sysidle_check_cpu(CPU 1) {
> >     rdtp(1)->dynticks_idle == 0
> > }
> > cmpxchg(full_sysidle_state, 
> >         ...RCU_SYSIDLE_SHORT)
> >                                    rcu_irq_exit() {
> 
> rcu_irq_enter(), right?
>

Woops, I meant rcu_idle_exit(). But yeah rcu_irq_enter() as well.

Thanks.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab3JARoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 13:44:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55896 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab3JARo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 13:44:28 -0400
Date: Tue, 1 Oct 2013 19:44:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] introduce prepare_to_wait_event()
Message-ID: <20131001174422.GP15690@laptop.programming.kicks-ass.net>
References: <20130930152242.207382649@infradead.org>
 <20131001170137.GA8560@redhat.com>
 <20131001172504.GV3657@laptop.programming.kicks-ass.net>
 <20131001173337.GA16890@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001173337.GA16890@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 07:33:37PM +0200, Oleg Nesterov wrote:
> > > 			if (___wait_is_interruptible(state) && intr) {		\
> > > 				__ret = intr;					\
> 
> Since typeof(__ret) == typeof(intr) gcc can (likely) simply do "mov r1, r2",
> so "long intr" make the code better.

ok, fair enough; keep it long.

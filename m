Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaDZLEm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 07:04:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:45968 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaDZLEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 07:04:40 -0400
Date: Sat, 26 Apr 2014 13:04:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH] rtmutex: Do not prio boost when timeout is used
Message-ID: <20140426110437.GK26782@laptop.programming.kicks-ass.net>
References: <20140425162848.0e1deed8@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425162848.0e1deed8@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 04:28:48PM -0400, Steven Rostedt wrote:
> I've been discussing an issue on IRC with deadlock checking and found
> something wrong with it. Mainly, if any of the locks have a timeout,
> then even if the chain loops, there is no real deadlock. If one of the
> locks in the chain times out, then things will move forward again.


POSIX (opengroup):

 http://pubs.opengroup.org/onlinepubs/009695399/functions/pthread_mutex_timedlock.html

Explicitly states that pthread_mutex_timedlock() should participate in
the PI chain, it also states that its perfectly valid for this function
to return -EDEADLK.

Therefore, there's nothing wrong. If this behaviour breaks userspace,
its already broken for not actually expecting the right thing.

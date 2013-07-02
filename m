Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab3GBIDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 04:03:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39799 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab3GBIDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 04:03:47 -0400
Date: Tue, 2 Jul 2013 10:03:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Baron <jbaron@akamai.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] static keys: fix test/set races
Message-ID: <20130702080306.GD21726@dyad.programming.kicks-ass.net>
References: <cover.1372457176.git.jbaron@akamai.com>
 <20130629072016.GA14746@gmail.com>
 <51D1019B.1020406@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D1019B.1020406@akamai.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 12:12:11AM -0400, Jason Baron wrote:
> 
> Yes, I agree that 'higher' level locking may be required for some callers of
> the newly proposed interface. However, I do think that the
> static_key_slow_set_true()/false() provides a nice abstraction for some
> callers, while addressing test/set() races, by making that sequence atomic.
> 
> I view the proposed inteface of set_true()/set_false() as somewhat analogous
> to an atomic_set() call. In the same way, the current
> static_key_slow_inc()/dec() are analogous to atomic_inc()/dec().
> 
> It arguably makes the code code a bit more readable, transforming sequences
> such as:
> 
> if (!static_key_enabled(&control_var))
>         static_key_slow_inc(&control_var);
> 
> into:
> 
>         static_key_slow_set_true(&control_var);
> 
> 
> I see at least 3 users of static_keys in the tree which I think would
> benefit  from this transformation. The 2 attached with this series, and the
> usage in kernel/tracepoint.c.

I tend to agree with Jason here. I also dont' think the scheduler needs this;
but the new API is more usable for binary switches as opposed to the refcount
thing.



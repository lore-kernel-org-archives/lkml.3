Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab3CSKOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 06:14:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41039 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab3CSKOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 06:14:38 -0400
Message-ID: <1363688074.22553.14.camel@laptop>
Subject: Re: [PATCH] scheduler: convert BUG_ON()s in try_to_wake_up_local()
 to WARN_ON_ONCE()s
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 19 Mar 2013 11:14:34 +0100
In-Reply-To: <20130318192234.GD3042@htj.dyndns.org>
References: <20130318192234.GD3042@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 12:22 -0700, Tejun Heo wrote:
> try_to_wake_up_local() should only be invoked to wake up another task
> in the same runqueue and BUG_ON()s are used to enforce the rule.
> Missing try_to_wake_up_local() can stall workqueue execution but such
> stalls are likely to be finite either by another work item being
> queued or the one blocked getting unblocked.  There's no reason to
> trigger BUG while holding rq lock crashing the whole system.
> 
> Convert BUG_ON()s in try_to_wake_up_local() to WARN_ON_ONCE()s.

Doesn't really matter either way, the printk()s triggered by either
will very likely kill the system anyhow ;-)


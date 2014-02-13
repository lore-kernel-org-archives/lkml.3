Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbaBMQAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 11:00:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46266 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaBMQAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 11:00:17 -0500
Date: Thu, 13 Feb 2014 17:00:13 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        tkhai@yandex.ru
Subject: Re: [PATCH] sched/core: Create new task with twice disabled
 preemption
Message-ID: <20140213160013.GE6835@laptop.programming.kicks-ass.net>
References: <1392306716.5384.3.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392306716.5384.3.camel@tkhai>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 07:51:56PM +0400, Kirill Tkhai wrote:
> For archs without __ARCH_WANT_UNLOCKED_CTXSW set this means
> that all newly created tasks execute finish_arch_post_lock_switch()
> and post_schedule() with preemption enabled.

That's IA64 and MIPS; do they have a 'good' reason to use this?

That is; the alternative is to fix those two archs and remove the
__ARCH_WANT_UNLOCKED_CTXSW clutter alltogether; which seems like a big
win to me.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266AbaGYMpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 08:45:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49615 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbaGYMpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 08:45:02 -0400
Date: Fri, 25 Jul 2014 14:44:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kaushal Kumar <kaushalk@codeaurora.org>
Cc: Ingo Molnar <mingo@kernel.org>, Michael Wang <wangyun@linux.vnet.ibm.com>,
        Arun Bharadwaj <abharadw@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] sched: Remove synchronize rcu/sched calls from _cpu_down
Message-ID: <20140725124459.GM20603@laptop.programming.kicks-ass.net>
References: <1406289368-11332-1-git-send-email-kaushalk@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406289368-11332-1-git-send-email-kaushalk@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 05:26:08PM +0530, Kaushal Kumar wrote:
> synchronize_rcu calls fail hot-unplug latency tests since
> wait_rcu_gp can have very high latency, at times up to few
> hundred of millisecs.

So bloody what?

> These calls were earlier removed for the same reason by the
> commit 9ee349ad6d326df3633d43f54202427295999c47, but got added
> back as part of commit c4575f83b9fe87bb57b737bc8a667f746a20320a.

fatal: bad object c4575f83b9fe87bb57b737bc8a667f746a20320

> Moreover there should be no need for sync_sched() in _cpu_down
> as stop_machine() provides that barrier implicitly.

We should not rely on that, but also you've removed synchronize_rcu()
and this is not at all provided by stop_machine().

So NAK.

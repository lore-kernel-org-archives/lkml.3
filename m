Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbbA0PE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:04:57 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:51079 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbbA0PEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:04:55 -0500
Date: Tue, 27 Jan 2015 16:04:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Xunlei Pang <pang.xunlei@linaro.org>
Cc: linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH 2/5] sched/deadline: Remove cpu_active_mask from
 cpudl_find()
Message-ID: <20150127150446.GF21418@twins.programming.kicks-ass.net>
References: <1421642980-10045-1-git-send-email-pang.xunlei@linaro.org>
 <1421642980-10045-2-git-send-email-pang.xunlei@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421642980-10045-2-git-send-email-pang.xunlei@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 04:49:37AM +0000, Xunlei Pang wrote:
> cpu_active_mask is rarely changeable, so remove this operation
> to gain a little performance.
> 
> If there is a change in cpu_active_mask, rq_online_dl() and
> rq_offline_dl() should take care of it normally, so cpudl::
> free_cpus carries enough information for us.
> 
> For the rare case(causing a task put onto a dying cpu) which
> rq_offline_dl() can't handle timely, then it can be handled
> through _cpu_down()->...->multi_cpu_stop()->migration_call()
> ->migrate_tasks(), preventing the task from hanging on the
> dead cpu.

Maybe; I'll need to go crawl through the long and twisted history of
active_mask here :/

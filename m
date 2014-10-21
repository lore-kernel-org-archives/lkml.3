Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519AbaJVHkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:40:45 -0400
Received: from mga03.intel.com ([134.134.136.65]:10235 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbaJVHko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:40:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,767,1406617200"; 
   d="scan'208";a="623021693"
Date: Wed, 22 Oct 2014 07:39:33 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, pjt@google.com,
        bsegall@google.com, arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Subject: Re: [RESEND PATCH 2/3 v5] sched: Rewrite per entity runnable load
 average tracking
Message-ID: <20141021233933.GB2577@intel.com>
References: <1412907717-2871-1-git-send-email-yuyang.du@intel.com>
 <1412907717-2871-3-git-send-email-yuyang.du@intel.com>
 <20141021145435.GA23531@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141021145435.GA23531@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 04:54:35PM +0200, Peter Zijlstra wrote:
> 
> In the thread here: lkml.kernel.org/r/1409094682.29189.23.camel@j-VirtualBox
> there are concerns about the error bounds of such constructs. We can
> basically 'leak' nr_cpus * threshold, which is potentially a very large
> number.
> 
> Do we want to introduce the force updated to combat this?

So introduce a force update here like:

+static inline void update_tg_load_avg(struct cfs_rq *cfs_rq, int force)
...
+	if (force || abs(delta) > cfs_rq->tg_load_avg_contrib / 64) {

That is good. In general, I have been lacking a theory about what threshold
should be concerning overhead vs. accuracy. But I think adding a force here
provides us an option to better comply with the theory if we have it.

Thanks,
Yuyang

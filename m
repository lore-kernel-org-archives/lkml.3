Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaGKH3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:29:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:62325 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbaGKH3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:29:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,642,1400050800"; 
   d="scan'208";a="541881083"
Date: Fri, 11 Jul 2014 07:22:07 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: bsegall@google.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com, arjan.van.de.ven@intel.com,
        len.brown@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        pjt@google.com, fengguang.wu@intel.com
Subject: Re: [PATCH 2/2] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140710232207.GC12984@intel.com>
References: <1404268256-3019-1-git-send-email-yuyang.du@intel.com>
 <1404268256-3019-2-git-send-email-yuyang.du@intel.com>
 <20140707104646.GK6758@twins.programming.kicks-ass.net>
 <xm26r41wyfgc.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140708000840.GB25653@intel.com>
 <xm26k37nye7d.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140709010753.GD25653@intel.com>
 <20140709184543.GI9918@twins.programming.kicks-ass.net>
 <xm26bnsyxsf7.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140710100859.GW3935@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140710100859.GW3935@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 12:08:59PM +0200, Peter Zijlstra wrote:
> 
> Since clock_task is the regular clock minus some local amount, the
> difference between two regular clock reads is always a strict upper
> bound on clock_task differences.
> 
This is inspiring. Regarding the clock source in load avg tracking,
should we simply use rq_clock_task instead of cfs_rq_clock_task.

For the bandwidth control case, just update/increase the last_update_time when
unthrottled by this throttled time, so the time would look like freezed. Am I
understanding right?

Not sure how much bandwidth control is used, but even not used, every time
we read cfs_rq_clock_task, will burn useless cycles here.

Thanks,
Yuyang

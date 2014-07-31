Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaHADSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 23:18:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:45850 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbaHADSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 23:18:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,777,1400050800"; 
   d="scan'208";a="552170856"
Date: Fri, 1 Aug 2014 03:16:38 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org,
        pjt@google.com, bsegall@google.com, arjan.van.de.ven@intel.com,
        len.brown@intel.com, rafael.j.wysocki@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, fengguang.wu@intel.com, morten.rasmussen@arm.com
Subject: Re: [PATCH 2/2 v4] sched: Rewrite per entity runnable load average
Message-ID: <20140731191638.GG28673@intel.com>
References: <20140729015344.GF5203@intel.com>
 <1406800573-9692-1-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406800573-9692-1-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

On Thu, Jul 31, 2014 at 11:56:13AM +0200, Vincent Guittot wrote:
> 
> load_sum is now the average runnable time before being weighted
 
So when weight changes, load_avg will completely use new weight. I have
some cents:

1) Task does not change weight much, so it is practically ok

2) Group entity does change weight much, and very likely back and forth,
   so I really think keeping the intact history will make everything
   more predictable/stable, prevent thrashing, etc.

3) If you do the same for cfs_rq->load.weight, then we simply abandoned
   blocked entities, and all states won't compute. So we then need to
   maintain blocked load average again, and we just can't do cfs_rq load
   average as a whole anymore, but must update at the granularity of an
   entity...

Anyway, it does not seem to me you really need to change load_sum, no? So
could you please not change it?

> The sum of usage_sum of the tasks that are on a rq, is used to detect
> the overload of a rq.

I think you only need usage_sum for task and rq, but not cfs_rq. Others
are ok.
 
> Does something like the patch below to be applied of top of your patchset, seem
> reasonable add-on?
> 

If you only add running statistics, I am all good, and indeed reasonable if
you can make good use of it. I am not at all against adding anything or
adding running average or unweighted anything...

Thanks,
Yuyang

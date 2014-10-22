Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbaJVIW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:22:59 -0400
Received: from mga03.intel.com ([134.134.136.65]:18249 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbaJVIW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:22:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,767,1406617200"; 
   d="scan'208";a="593611973"
Date: Wed, 22 Oct 2014 08:23:11 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Cc: cebbert.lkml@gmail.com, pjt@google.com, bsegall@google.com,
        arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Subject: Re: [RESEND PATCH 1/3 v5] sched: Remove update_rq_runnable_avg
Message-ID: <20141022002311.GD2577@intel.com>
References: <1412907717-2871-1-git-send-email-yuyang.du@intel.com>
 <1412907717-2871-2-git-send-email-yuyang.du@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412907717-2871-2-git-send-email-yuyang.du@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 10:21:55AM +0800, Yuyang Du wrote:
>  
> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c index 627b3c3..da0b7d5 100644
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c

> -	if (!se) {
> -		struct sched_avg *avg = &cpu_rq(cpu)->avg;
> -		P(avg->runnable_avg_sum);
> -		P(avg->runnable_avg_period);
> -		return;
> -	}

This is a bug. Should be:

-	if (!se)
-		return;

Thanks to 0Day, and good improvement as previously this bug was not found.
Also thanks to Chuck Ebbert.

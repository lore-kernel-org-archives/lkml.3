Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbaGJCmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 22:42:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:50423 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203AbaGJCmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 22:42:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,636,1400050800"; 
   d="scan'208";a="570918497"
Date: Thu, 10 Jul 2014 02:39:00 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: bsegall@google.com
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com,
        arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, pjt@google.com, fengguang.wu@intel.com
Subject: Re: [PATCH 2/2] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140709183900.GA32291@intel.com>
References: <1404268256-3019-1-git-send-email-yuyang.du@intel.com>
 <1404268256-3019-2-git-send-email-yuyang.du@intel.com>
 <20140707104646.GK6758@twins.programming.kicks-ass.net>
 <xm26r41wyfgc.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140708000840.GB25653@intel.com>
 <xm26k37nye7d.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140709010753.GD25653@intel.com>
 <xm26fviaxxwl.fsf@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xm26fviaxxwl.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 10:08:42AM -0700, bsegall@google.com wrote:

> > That I believe is not a problem. It is a matter of when cfs_rq->load.weight
> > changes and when we look at it to contribute to the cfs_rq's load_avg.
> > Fortunately, we will not miss any change of cfs_rq->load.weight, always
> > contributing to the load_avg the right amount. Put another way, we always
> > use the right cfs_rq->load.weight.
> 
> You always call __update_load_avg with every needed load.weight, but if
> now - sa->last_update_time < 1024, then it will not do anything with
> that weight, and the next actual update may be with a different weight.
 
Oh, yes, I finally understand, :) You are right. That is the matter of 1ms period.
Within period boundary, everything will be lost.

Thanks,
Yuyang

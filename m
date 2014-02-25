Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaBYNQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 08:16:53 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:56394 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbaBYNQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 08:16:52 -0500
Date: Tue, 25 Feb 2014 18:46:42 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ben Segall <bsegall@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: put rq's sched_avg under CONFIG_FAIR_GROUP_SCHED
Message-ID: <20140225131642.GA3265@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1393328862-19997-1-git-send-email-dietmar.eggemann@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1393328862-19997-1-git-send-email-dietmar.eggemann@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022513-0260-0000-0000-0000046B829F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The struct sched_avg of struct rq is only used in case group
> scheduling is enabled inside __update_tg_runnable_avg() to update
> per-cpu representation of a task group.  I.e. that there is no need to
> maintain the runnable avg of a rq in the !CONFIG_FAIR_GROUP_SCHED case.
> 
> This patch guards struct sched_avg of struct rq and
> update_rq_runnable_avg() with CONFIG_FAIR_GROUP_SCHED.
> 

While this patch looks good, I see fields in sched_avg viz decay_count,
last_runnable_update, load_avg_contrib  only relevant to sched_entity.
i.e they don't seem to be updated or used for rq->avg. Should we look at
splitting sched_avg so that rq->avg doesn't have unwanted fields?

--
Thanks and Regards
Srikar Dronamraju


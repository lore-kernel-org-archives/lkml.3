Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbaIVRJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:09:50 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:37917 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbaIVRJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:09:45 -0400
From: bsegall@google.com
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: peterz@infradead.org, mingo@redhat.com, dietmar.eggemann@arm.com,
        pjt@google.com, vincent.guittot@linaro.org, nicolas.pitre@linaro.org,
        mturquette@linaro.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] sched: Track sched_entity usage contributions
References: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
	<1411403047-32010-8-git-send-email-morten.rasmussen@arm.com>
Date: Mon, 22 Sep 2014 10:09:42 -0700
In-Reply-To: <1411403047-32010-8-git-send-email-morten.rasmussen@arm.com>
	(Morten Rasmussen's message of "Mon, 22 Sep 2014 17:24:07 +0100")
Message-ID: <xm267g0vlgyx.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Morten Rasmussen <morten.rasmussen@arm.com> writes:

> Adds usage contribution tracking for both task and group entities.
> Maintains a non-priority scaled se->avg.usage_avg_contrib for each
> sched_entity and cfs_rq.usage_util_avg sum of all entity contributions.
> The latter provides a more accurate estimate of the true cpu utilization
> than the existing cfs_rq.runnable_load_avg (+blocked_load_avg).
>
> Unlike se->avg.load_avg_contrib, se->avg.usage_avg_contrib for group
> entities is the sum of se->avg.usage_avg_contrib for all entities on the
> group runqueue. It is _not_ influenced in any way by the task group
> h_load. Hence it is representing the actual cpu usage of the group, not
> its intended load contribution which may differ significantly from the
> usage on lightly utilized systems.
>
> The cpu usage tracking is available as cpu_rq(cpu)->cfs.usage_util_avg.
> No tracking of blocked usage has been implemented.

Isn't cfs_rq->usage_util_avg basically just
se->avg.usage_avg_sum * 1024 / se->avg.runnable_avg_period, where
se->group_cfs_rq == cfs_rq? (and for the rq as a whole, rq->avg)

The fact that usage_util_avg doesn't track blocked usage seems more
likely to be a problem than an advantage, but maybe not?

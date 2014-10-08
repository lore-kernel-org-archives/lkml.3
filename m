Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbaJHLNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:13:30 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:42394 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbaJHLN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:13:29 -0400
Date: Wed, 8 Oct 2014 12:13:26 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: "bsegall@google.com" <bsegall@google.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "kamalesh@linux.vnet.ibm.com" <kamalesh@linux.vnet.ibm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>, "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "pjt@google.com" <pjt@google.com>
Subject: Re: [PATCH 4/7] sched: Track group sched_entity usage contributions
Message-ID: <20141008111326.GB1788@e105550-lin.cambridge.arm.com>
References: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org>
 <1412684017-16595-5-git-send-email-vincent.guittot@linaro.org>
 <xm26oatnk55g.fsf@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xm26oatnk55g.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 09:15:39PM +0100, bsegall@google.com wrote:
> Vincent Guittot <vincent.guittot@linaro.org> writes:
> 
> > From: Morten Rasmussen <morten.rasmussen@arm.com>
> >
> > Adds usage contribution tracking for group entities. Unlike
> > se->avg.load_avg_contrib, se->avg.utilization_avg_contrib for group
> > entities is the sum of se->avg.utilization_avg_contrib for all entities on the
> > group runqueue. It is _not_ influenced in any way by the task group
> > h_load. Hence it is representing the actual cpu usage of the group, not
> > its intended load contribution which may differ significantly from the
> > utilization on lightly utilized systems.
> 
> 
> Just noting that this version also has usage disappear immediately when
> a task blocks, although it does what you probably want on migration.

Yes, as it was discussed at Ksummit, we should include blocked
usage. It gives a much more stable metric.

> Also, group-ses don't ever use their running_avg_sum so it's kinda a
> waste, but I'm not sure it's worth doing anything about.

Yeah, but since we still have to maintain runnable_avg_sum for group-ses
it isn't much that can be saved I think. Maybe avoid calling
update_entity_load_avg() from set_next_entity() for group-ses, but I'm
not sure how much it helps.

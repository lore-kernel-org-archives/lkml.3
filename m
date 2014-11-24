Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbaKXRdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:33:55 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:38328 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbaKXRdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:33:54 -0500
Date: Mon, 24 Nov 2014 17:34:46 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "kamalesh@linux.vnet.ibm.com" <kamalesh@linux.vnet.ibm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>, "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Paul Turner <pjt@google.com>, Ben Segall <bsegall@google.com>
Subject: Re: [PATCH v9 01/10] sched: add utilization_avg_contrib
Message-ID: <20141124173446.GN23177@e105550-lin.cambridge.arm.com>
References: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
 <1415033687-23294-2-git-send-email-vincent.guittot@linaro.org>
 <20141121123453.GB23177@e105550-lin.cambridge.arm.com>
 <CAKfTPtBDd6JXuK4THkqs4eoEHG+-VYfhFR6nUe2vrqvGWG08Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtBDd6JXuK4THkqs4eoEHG+-VYfhFR6nUe2vrqvGWG08Yw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 02:04:15PM +0000, Vincent Guittot wrote:
> On 21 November 2014 at 13:34, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> > Should the subject mention that the patch adds utilization tracking?
> > Maybe: 'sched: Add utilization tracking' ?
> >
> >
> > On Mon, Nov 03, 2014 at 04:54:38PM +0000, Vincent Guittot wrote:
> >> Add new statistics which reflect the average time a task is running on the CPU
> >> and the sum of these running time of the tasks on a runqueue. The latter is
> >> named utilization_load_avg.
> >>
> >> This patch is based on the usage metric that was proposed in the 1st
> >> versions of the per-entity load tracking patchset by Paul Turner
> >
> > Should we do ourselves and anybody else who feels like going through the
> > pain of understanding the load-tracking code a favor and drop the use of
> > the term 'usage' and use 'utilization' everywhere instead? 'usage' isn't
> > clearly defined anywhere.
> >
> > Referring to 'usage' here in the reference to original patch is fine,
> > but I suggest that we remove it from the code and comment on subsequent
> > patches unless there is a very good reason to keep it.
> 
> As discussed with Peter, we use usage when the task's utilization has
> been scaled by the capacity.
> 
> IIRC from one of our discussion, dietmar should prepare a patchset to
> rename and aligned variables and field.

I read this as we stick with usage while utilization is scaled by
capacity and potentially drop it again when adding uarch invariance so
the scaling goes away. Or rename it before if we find a better name for
it.

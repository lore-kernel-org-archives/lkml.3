Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751047AbaAQDgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 22:36:23 -0500
Received: from mout.gmx.net ([212.227.17.22]:52802 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbaAQDgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 22:36:21 -0500
Message-ID: <1389929776.5409.27.camel@marge.simpson.net>
Subject: Re: [RFC PATCH] sched: select_idle_sibling macro optimize
From: Mike Galbraith <efault@gmx.de>
To: Alex Shi <alex.shi@linaro.org>
Cc: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Fri, 17 Jan 2014 04:36:16 +0100
In-Reply-To: <52D891FB.9020308@linaro.org>
References: <1389795808-32013-1-git-send-email-alex.shi@linaro.org>
	 <52D7DAF5.4020506@linaro.org> <1389880335.5418.46.camel@marge.simpson.net>
	 <52D891FB.9020308@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V03:K0:dbebbF/bgBY32PFRA9PCWrYcqAicujAfAs5XiydL37NcXRJ/SpU
 bI/0KVbneot60519PtXKHap+siQvra91RfEh0HOKNuTvNzW0AzpsILg80AQFue8hdSdCDfM
 91Ym1aChsO5f0SkMHfrr2BCy5rAsc+pvESg0mpt3xEnDs6gv2HNLB0V7som/9d/79T7PW0v
 k96ZT6/qQax82Yao+zI+A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-17 at 10:14 +0800, Alex Shi wrote: 
> On 01/16/2014 09:52 PM, Mike Galbraith wrote:
> > On Thu, 2014-01-16 at 21:13 +0800, Alex Shi wrote: 
> >> Add Mike Galbraith.
> >>
> >> Any one like to give some comments?
> >>
> >> On 01/15/2014 10:23 PM, Alex Shi wrote:
> >>> If the sd domain just has one group, then we must be caught the
> >>> 	i == target later, and then goes to deeper level domain.
> >>> So just skip this domain checking to save some instructions.
> >>>
> >>> Signed-off-by: Alex Shi <alex.shi@linaro.org>
> >>> ---
> >>>  kernel/sched/fair.c | 5 +++++
> >>>  1 file changed, 5 insertions(+)
> >>>
> >>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> >>> index c7395d9..3265fbc 100644
> >>> --- a/kernel/sched/fair.c
> >>> +++ b/kernel/sched/fair.c
> >>> @@ -4196,6 +4196,11 @@ static int select_idle_sibling(struct task_struct *p, int target)
> >>>  	sd = rcu_dereference(per_cpu(sd_llc, target));
> >>>  	for_each_lower_domain(sd) {
> >>>  		sg = sd->groups;
> >>> +
> >>> +		/* skip single group domain */
> >>> +		if (sg == sg->next)
> >>> +			continue;
> > 
> > When is that gonna happen?
> 
> I had seen this in a Intel platform, you may have both CPU domain and MC
> domain layer, because the domain flag is different, then they can not be
> merged. and then the CPU domain just has one group.

But sd starts at MC.

-Mike


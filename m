Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaAPNwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:52:21 -0500
Received: from mout.gmx.net ([212.227.17.20]:58480 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbaAPNwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:52:20 -0500
Message-ID: <1389880335.5418.46.camel@marge.simpson.net>
Subject: Re: [RFC PATCH] sched: select_idle_sibling macro optimize
From: Mike Galbraith <efault@gmx.de>
To: Alex Shi <alex.shi@linaro.org>
Cc: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Thu, 16 Jan 2014 14:52:15 +0100
In-Reply-To: <52D7DAF5.4020506@linaro.org>
References: <1389795808-32013-1-git-send-email-alex.shi@linaro.org>
	 <52D7DAF5.4020506@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V03:K0:ZdaO/pMVrSukLMwLbp+pA15I9OONjKUuKXMlwMYEgEfKGWoJxSH
 4msAQHLL/IUS/8+oypv1rL+YzkZgcp0Se3f42hb2GLlDqt6zKePqkgUaatMCjrXDhZBl9fK
 z4jKt0Z2MCEnBoLoEDPgTBBp4dPK3ArR0ap7sobFZQ2P1V0/nvbK+ZYqNBDRuNjYvEdnEBx
 WttlspDHWTUg5FAZxNZGg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-16 at 21:13 +0800, Alex Shi wrote: 
> Add Mike Galbraith.
> 
> Any one like to give some comments?
> 
> On 01/15/2014 10:23 PM, Alex Shi wrote:
> > If the sd domain just has one group, then we must be caught the
> > 	i == target later, and then goes to deeper level domain.
> > So just skip this domain checking to save some instructions.
> > 
> > Signed-off-by: Alex Shi <alex.shi@linaro.org>
> > ---
> >  kernel/sched/fair.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index c7395d9..3265fbc 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -4196,6 +4196,11 @@ static int select_idle_sibling(struct task_struct *p, int target)
> >  	sd = rcu_dereference(per_cpu(sd_llc, target));
> >  	for_each_lower_domain(sd) {
> >  		sg = sd->groups;
> > +
> > +		/* skip single group domain */
> > +		if (sg == sg->next)
> > +			continue;

When is that gonna happen?

-Mike



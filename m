Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaKXRPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:15:44 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:38291 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbaKXRPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:15:43 -0500
Date: Mon, 24 Nov 2014 17:16:35 +0000
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
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v9 08/10] sched: replace capacity_factor by usage
Message-ID: <20141124171635.GL23177@e105550-lin.cambridge.arm.com>
References: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
 <1415033687-23294-9-git-send-email-vincent.guittot@linaro.org>
 <20141121123719.GH23177@e105550-lin.cambridge.arm.com>
 <CAKfTPtBtdnHUYjbrUiqED7Mr2d4HGB1YcyARED6Zx+rskZRsBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtBtdnHUYjbrUiqED7Mr2d4HGB1YcyARED6Zx+rskZRsBw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 02:41:28PM +0000, Vincent Guittot wrote:
> On 21 November 2014 at 13:37, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> > On Mon, Nov 03, 2014 at 04:54:45PM +0000, Vincent Guittot wrote:
> 
> [snip]
> 
> >>                  */
> >>                 if (prefer_sibling && sds->local &&
> >> -                   sds->local_stat.group_has_free_capacity)
> >> -                       sgs->group_capacity_factor = min(sgs->group_capacity_factor, 1U);
> >> +                   group_has_capacity(env, &sds->local_stat) &&
> >> +                   (sgs->sum_nr_running > 1)) {
> >> +                       sgs->group_no_capacity = 1;
> >> +                       sgs->group_type = group_overloaded;
> >> +               }
> >
> > I'm still a bit confused about SD_PREFER_SIBLING. What is the flag
> > supposed to do and why?
> 
> The goal is to spread tasks across the group even if the the latter is
> not overloaded. for SMT level, the goal is to have 1 task per core
> before 1 task per HW thread

That makes more sense and is in line with how I understand SMT
scheduling. So we try to have at least one task per group. Where each
group is a domain with SD_PREFER_SIBLING.

Anyway, you don't change the prefer-sibling behaviour in this patch set.
I was just wondering how it would work for SMT balancing.

Thanks,
Morten

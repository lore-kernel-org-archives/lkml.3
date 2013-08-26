Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab3HZMJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:09:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35463 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab3HZMJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:09:33 -0400
Date: Mon, 26 Aug 2013 14:09:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Rik van Riel <riel@surriel.com>, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 09/10] sched, fair: Fix the sd_parent_degenerate() code
Message-ID: <20130826120919.GL31370@twins.programming.kicks-ass.net>
References: <20130819160058.539049611@infradead.org>
 <20130819160425.672255367@infradead.org>
 <CAPM31RLOX9NSaHK9+ysC6yDXvAj2swaoXmg6hHHpMdOJjWBFrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM31RLOX9NSaHK9+ysC6yDXvAj2swaoXmg6hHHpMdOJjWBFrQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 03:45:57AM -0700, Paul Turner wrote:
> > @@ -5157,6 +5158,13 @@ cpu_attach_domain(struct sched_domain *s
> >                         tmp->parent = parent->parent;
> >                         if (parent->parent)
> >                                 parent->parent->child = tmp;
> > +                       /*
> > +                        * Transfer SD_PREFER_SIBLING down in case of a
> > +                        * degenerate parent; the spans match for this
> > +                        * so the property transfers.
> > +                        */
> > +                       if (parent->flags & SD_PREFER_SIBLING)
> > +                               tmp->flags |= SD_PREFER_SIBLING;
> >                         destroy_sched_domain(parent, cpu);
> >                 } else
> >                         tmp = tmp->parent;
> >
> 
> Reviewed-by: Paul Turner <pjt@google.com>

BTW, did that comment make sense to you or would you suggest something
different? I had/am having a hard time with that comment. Somehow it
leaves me wanting. I know I understand the issue now, but I'll doubt the
comment will suffice in a years time :/

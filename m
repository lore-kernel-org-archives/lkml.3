Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab3CTLQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 07:16:59 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60227
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087Ab3CTLQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 07:16:58 -0400
Message-ID: <1363778201.3724.1.camel@laptop>
Subject: Re: [PATCH 4/8] sched: clean up move_task() and move_one_task()
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 12:16:41 +0100
In-Reply-To: <20130320073355.GC11672@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <1360820921-2513-5-git-send-email-iamjoonsoo.kim@lge.com>
	 <1363703415.22553.54.camel@laptop> <20130320073355.GC11672@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2013-03-20 at 16:33 +0900, Joonsoo Kim wrote:

> > Right, so I'm not so taken with this one. The whole load stuff really
> > is a balance heuristic that's part of move_tasks(), move_one_task()
> > really doesn't care about that.
> > 
> > So why did you include it? Purely so you didn't have to re-order the
> > tests? I don't see any reason not to flip a tests around.
> 
> I think that I'm not fully understand what you are concerning, because of
> my poor English. If possible, please elaborate on a problem in more detail.

OK, so your initial Changelog said it wanted to remove some code
duplication between move_tasks() and move_one_task(); but then you put
in the load heuristics and add a boolean argument to only enable those
for move_tasks() -- so clearly that wasn't duplicated.

So why move that code.. I proposed that this was due a reluctance to
re-arrange the various tests that stop the migration from happening.

Now you say:

> ... Just moving up can_migrate_task() above
> load evaluation code may raise side effect, because can_migrate_task() have
> other checking which is 'cache hottness'. I don't want a side effect. So
> embedding load evaluation to can_migrate_task() and re-order checking and
> makes load evaluation disabled for move_one_task().

Which pretty much affirms this. However I also said that I don't think
the order really matters that much; each test will cancel the migration
of this task; the order of these tests seem immaterial.

> If your recommandation is to move up can_mirate_task() above
> load evaluation code, yes, I can, and will do that. :)

I would actually propose 



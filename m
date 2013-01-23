Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab3AWSCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 13:02:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50297 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab3AWSCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 13:02:34 -0500
Date: Wed, 23 Jan 2013 19:02:31 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, "mingo@elte.hu" <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 16/29] perf, tools: Add support for weight v7
Message-ID: <20130123180231.GA30577@one.firstfloor.org>
References: <1358455012-12287-1-git-send-email-andi@firstfloor.org> <1358455012-12287-17-git-send-email-andi@firstfloor.org> <CABPqkBQNXUfC9VwyZAA-OyhKJ6JL8Sr__Rq=sZPAzSL6cP+E6Q@mail.gmail.com> <CABPqkBT+wKBKVt30OJ4mhMGGq1711r51tdWsxyyHAmEy3rYfyw@mail.gmail.com> <CABPqkBSBWsx50Pupc5nh6yqvkgLBa4BSCQN==6=SPp1Z_iQUYA@mail.gmail.com> <20130123171351.GZ30577@one.firstfloor.org> <CABPqkBQvh5R32mxvLsaN2+YmBhxcoRmUYUZeQju4kBDnHB4s5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQvh5R32mxvLsaN2+YmBhxcoRmUYUZeQju4kBDnHB4s5A@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As for the hack, I did not put in in my hist__add_mem_entry() but
> rather in the caller.
> For PEBS-LL, the period is not important. I think it counts the number
> of loads/stores
> and not just the qualifying ones. For loads, that means it counts all
> loads and not just
> the ones above the threshold, but I may be wrong.

Users should just specify the right keys, with a sensible default
for the event.

> 
> > I had a similar thing in a really old version of my patches,
> > but I gave it up because it was too unintuitive.
> >
> Well, but then it does not present a sensible view of the samples when weight is
> more important than period.

Right now weight is not sorted. So you can see the information, but it's
not really nice. Longer term should fix sort.c to actually sort properly,
then it'll work ok and be intuitive.

I don't think hacks like making weight look like period are the right
way to do it. I had those originally, but discarded them.

sort.c just needs to sort properly on all keys.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

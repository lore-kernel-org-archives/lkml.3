Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab3AWRNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 12:13:54 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50236 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab3AWRNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 12:13:52 -0500
Date: Wed, 23 Jan 2013 18:13:51 +0100
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
Message-ID: <20130123171351.GZ30577@one.firstfloor.org>
References: <1358455012-12287-1-git-send-email-andi@firstfloor.org> <1358455012-12287-17-git-send-email-andi@firstfloor.org> <CABPqkBQNXUfC9VwyZAA-OyhKJ6JL8Sr__Rq=sZPAzSL6cP+E6Q@mail.gmail.com> <CABPqkBT+wKBKVt30OJ4mhMGGq1711r51tdWsxyyHAmEy3rYfyw@mail.gmail.com> <CABPqkBSBWsx50Pupc5nh6yqvkgLBa4BSCQN==6=SPp1Z_iQUYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSBWsx50Pupc5nh6yqvkgLBa4BSCQN==6=SPp1Z_iQUYA@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For PEBS-LL and possibly other special cases, it is important to remember
> that perf report always end up sorting by period (hist_collapse_resort). But
> for PEBS-LL we want to sort on nr_events * weight. Thus, with your patch,
> the only way, I found, to achieve this is by passing:
> 
>        add_hist_entry(self, &entry, al, weight, weight);

Seems like a hack. IMHO it should always sort by all the keys 
i specified with --sort in exactly that order I specified

I had a similar thing in a really old version of my patches,
but I gave it up because it was too unintuitive.

-Andi

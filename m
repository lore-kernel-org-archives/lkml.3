Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936882Ab3DJW2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:28:31 -0400
Received: from rydia.net ([69.46.88.68]:52834 "EHLO mail.rydia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935439Ab3DJW2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:28:30 -0400
Date: Wed, 10 Apr 2013 15:28:32 -0700 (PDT)
From: dormando <dormando@rydia.net>
X-X-Sender: dormando@dtop
To: Mel Gorman <mgorman@suse.de>
cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/10] Reduce system disruption due to kswapd V2
In-Reply-To: <20130410141445.GD3710@suse.de>
Message-ID: <alpine.DEB.2.02.1304101524120.7738@dtop>
References: <1365505625-9460-1-git-send-email-mgorman@suse.de> <0000013defd666bf-213d70fc-dfbd-4a50-82ed-e9f4f7391b55-000000@email.amazonses.com> <20130410141445.GD3710@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Apr 09, 2013 at 05:27:18PM +0000, Christoph Lameter wrote:
> > One additional measure that may be useful is to make kswapd prefer one
> > specific processor on a socket. Two benefits arise from that:
> >
> > 1. Better use of cpu caches and therefore higher speed, less
> > serialization.
> >
>
> Considering the volume of pages that kswapd can scan when it's active
> I would expect that it trashes its cache anyway. The L1 cache would be
> flushed after scanning struct pages for just a few MB of memory.
>
> > 2. Reduction of the disturbances to one processor.
> >
>
> I've never checked it but I would have expected kswapd to stay on the
> same processor for significant periods of time. Have you experienced
> problems where kswapd bounces around on CPUs within a node causing
> workload disruption?

When kswapd shares the same CPU as our main process it causes a measurable
drop in response time (graphs show tiny spikes at the same time memory is
freed). Would be nice to be able to ensure it runs on a different core
than our latency sensitive processes at least. We can pin processes to
subsets of cores but I don't think there's a way to keep kswapd from
waking up on any of them?

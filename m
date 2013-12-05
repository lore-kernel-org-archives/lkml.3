Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab3LEImO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 03:42:14 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:64222 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab3LEImI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 03:42:08 -0500
X-AuditID: 9c930179-b7ce4ae000000e86-6f-52a03c5e79d6
Date: Thu, 5 Dec 2013 17:44:41 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        azurIt <azurit@pobox.sk>,
        Linux Memory Management List <linux-mm@kvack.org>,
        cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Christian Casteyde <casteyde.christian@free.fr>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [patch 2/2] fs: buffer: move allocation failure loop into the
 allocator
Message-ID: <20131205084441.GA5561@lge.com>
References: <1381265890-11333-1-git-send-email-hannes@cmpxchg.org>
 <1381265890-11333-2-git-send-email-hannes@cmpxchg.org>
 <20131203165910.54d6b4724a1f3e329af52ac6@linux-foundation.org>
 <20131204015218.GA19709@lge.com>
 <20131203180717.94c013d1.akpm@linux-foundation.org>
 <00000142be2f1de0-764bb035-adbc-4367-b2b4-bf05498510a6-000000@email.amazonses.com>
 <CAAmzW4PwLhMd61ksOktdg=rkj0xHsSGt2Wm_za2Adjh4+tss-g@mail.gmail.com>
 <00000142be753b07-aa0e2354-6704-41f8-8e11-3c856a186af5-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000142be753b07-aa0e2354-6704-41f8-8e11-3c856a186af5-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 04:33:43PM +0000, Christoph Lameter wrote:
> On Thu, 5 Dec 2013, Joonsoo Kim wrote:
> 
> > Now we have cpu partial slabs facility, so I think that slowpath isn't really
> > slow. And it doesn't much increase the management overhead in the node
> > partial lists, because of cpu partial slabs.
> 
> Well yes that may address some of the issues here.
> 
> > And larger frame may cause more slab_lock contention or cmpxchg contention
> > if there are parallel freeings.
> >
> > But, I don't know which one is better. Is larger frame still better? :)
> 
> Could you run some tests to figure this one out? There are also
> some situations in which we disable the per cpu partial pages though.
> F.e. for low latency/realtime. I posted in kernel synthetic
> benchmarks for slab a while back. That maybe something to start with.

I could try. But my trial would not figure this out, since my machine has
just 4 cores which normally cannot produce heavy contention.
Anyway, could you tell me where I can find your synthetic benchmarks for slab?

Thanks.

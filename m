Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985Ab3LDQqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:46:09 -0500
Received: from a9-50.smtp-out.amazonses.com ([54.240.9.50]:55450 "EHLO
	a9-50.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932508Ab3LDQqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:46:06 -0500
X-Greylist: delayed 741 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Dec 2013 11:46:06 EST
Date: Wed, 4 Dec 2013 16:33:43 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <js1304@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        azurIt <azurit@pobox.sk>,
        Linux Memory Management List <linux-mm@kvack.org>,
        cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Christian Casteyde <casteyde.christian@free.fr>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [patch 2/2] fs: buffer: move allocation failure loop into the
 allocator
In-Reply-To: <CAAmzW4PwLhMd61ksOktdg=rkj0xHsSGt2Wm_za2Adjh4+tss-g@mail.gmail.com>
Message-ID: <00000142be753b07-aa0e2354-6704-41f8-8e11-3c856a186af5-000000@email.amazonses.com>
References: <1381265890-11333-1-git-send-email-hannes@cmpxchg.org> <1381265890-11333-2-git-send-email-hannes@cmpxchg.org> <20131203165910.54d6b4724a1f3e329af52ac6@linux-foundation.org> <20131204015218.GA19709@lge.com> <20131203180717.94c013d1.akpm@linux-foundation.org>
 <00000142be2f1de0-764bb035-adbc-4367-b2b4-bf05498510a6-000000@email.amazonses.com> <CAAmzW4PwLhMd61ksOktdg=rkj0xHsSGt2Wm_za2Adjh4+tss-g@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.04-54.240.9.50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Dec 2013, Joonsoo Kim wrote:

> Now we have cpu partial slabs facility, so I think that slowpath isn't really
> slow. And it doesn't much increase the management overhead in the node
> partial lists, because of cpu partial slabs.

Well yes that may address some of the issues here.

> And larger frame may cause more slab_lock contention or cmpxchg contention
> if there are parallel freeings.
>
> But, I don't know which one is better. Is larger frame still better? :)

Could you run some tests to figure this one out? There are also
some situations in which we disable the per cpu partial pages though.
F.e. for low latency/realtime. I posted in kernel synthetic
benchmarks for slab a while back. That maybe something to start with.



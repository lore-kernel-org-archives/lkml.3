Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab3FEOJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:09:23 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:18468 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751476Ab3FEOJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:09:22 -0400
Date: Wed, 5 Jun 2013 14:09:21 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: JoonSoo Kim <js1304@gmail.com>
cc: Steven Rostedt <rostedt@goodmis.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [RT LATENCY] 249 microsecond latency caused by slub's
 unfreeze_partials() code.
In-Reply-To: <CAAmzW4MakOx_SA6eA=BYP4rq76np4yOS6RANpNObQP6dDDqYQg@mail.gmail.com>
Message-ID: <0000013f14aba791-b53199dd-c805-4644-9777-3916950e83e4-000000@email.amazonses.com>
References: <1364010673.6345.156.camel@gandalf.local.home> <0000013da2ace21a-9e87fe8a-75c2-4b7c-b5e1-37ad196ce012-000000@email.amazonses.com> <1364234613.6345.184.camel@gandalf.local.home> <0000013da2ce20f8-0e3a64ef-67ed-4ab4-9f20-b77980c876c3-000000@email.amazonses.com>
 <1364236355.6345.185.camel@gandalf.local.home> <20130327025957.GA17125@lge.com> <1364355032.6345.200.camel@gandalf.local.home> <20130327061351.GB17125@lge.com> <alpine.DEB.2.02.1303281227520.16200@gentwo.org> <0000013db20ca149-0064fbb8-2f81-4323-9095-a38f6abb79c5-000000@email.amazonses.com>
 <1369751967.15552.12.camel@gandalf.local.home> <alpine.DEB.2.02.1305281121420.1627@gentwo.org> <0000013eec62261a-77052f34-f1cb-41b2-ae90-7575a2d0472c-000000@email.amazonses.com> <CAAmzW4M8rX9WGo_FYeyBQ8=Ht-mRnQz1TGhLfbFuKhm3r8grGA@mail.gmail.com>
 <0000013f0b7b993c-35844ed2-81be-4146-ab3c-6c803006576b-000000@email.amazonses.com> <CAAmzW4MakOx_SA6eA=BYP4rq76np4yOS6RANpNObQP6dDDqYQg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jun 2013, JoonSoo Kim wrote:

> @@ -2495,7 +2495,8 @@ static void __slab_free(struct kmem_cache *s,
> struct page *page,
>                 new.inuse--;
>                 if ((!new.inuse || !prior) && !was_frozen) {
>
> -                       if (!kmem_cache_debug(s) && !prior)
> +                       if (!kmem_cache_debug(s) && !prior &&
> +                               node_match(page,
> cpu_to_node(smp_processor_id())))
>

Would increase the overhead of the free path. cpu_to_node? Use
numa_node_id().

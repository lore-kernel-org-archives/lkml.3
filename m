Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbaFINw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:52:29 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:37435 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750956AbaFINw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:52:27 -0400
Date: Mon, 9 Jun 2014 08:52:24 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, rientjes@google.com,
        penberg@kernel.org, hannes@cmpxchg.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm v2 5/8] slub: make slab_free non-preemptable
In-Reply-To: <20140609125211.GA32192@esperanza>
Message-ID: <alpine.DEB.2.10.1406090850070.22191@gentwo.org>
References: <cover.1402060096.git.vdavydov@parallels.com> <7cd6784a36ed997cc6631615d98e11e02e811b1b.1402060096.git.vdavydov@parallels.com> <alpine.DEB.2.10.1406060942160.32229@gentwo.org> <20140609125211.GA32192@esperanza>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014, Vladimir Davydov wrote:

> The whole function (unfreeze_partials) is currently called with irqs
> off, so this is effectively a no-op. I guess we can restore irqs here
> though.

We could move the local_irq_save from put_cpu_partial() into
unfreeze_partials().

> If we just freed the last slab of the cache and then get preempted
> (suppose we restored irqs above), nothing will prevent the cache from
> destruction, which may result in use-after-free below. We need to be
> more cautious if we want to call for page allocator with preemption and
> irqs on.

Hmmm. Ok.
>
> However, I still don't understand what's the point in it. We *already*
> call discard_slab with irqs disabled, which is harder, and it haven't
> caused any problems AFAIK. Moreover, even if we enabled preemption/irqs,
> it wouldn't guarantee that discard_slab would always be called with
> preemption/irqs on, because the whole function - I mean kmem_cache_free
> - can be called with preemption/irqs disabled.
>
> So my point it would only complicate the code.

Ok.

Acked-by: Christoph Lameter <cl@linux.com>


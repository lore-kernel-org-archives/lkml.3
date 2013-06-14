Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab3FNOcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:32:14 -0400
Received: from a9-58.smtp-out.amazonses.com ([54.240.9.58]:33738 "EHLO
	a9-58.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259Ab3FNOcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:32:13 -0400
Date: Fri, 14 Jun 2013 14:32:11 +0000
From: Christoph Lameter <cl@gentwo.org>
To: Roman Gushchin <klamm@yandex-team.ru>
cc: penberg@kernel.org, mpm@selenic.com, akpm@linux-foundation.org,
        mgorman@suse.de, rientjes@google.com, glommer@parallels.com,
        hannes@cmpxchg.org, minchan@kernel.org, jiang.liu@huawei.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: Avoid direct compaction if possible
In-Reply-To: <51BB1802.8050108@yandex-team.ru>
Message-ID: <0000013f4319cb46-a5a3de58-1207-4037-ae39-574b58135ea2-000000@email.amazonses.com>
References: <51BB1802.8050108@yandex-team.ru>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.06.14-54.240.9.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jun 2013, Roman Gushchin wrote:

> Slub tries to allocate contiguous pages even if memory is fragmented and
> there are no free contiguous pages. In this case it calls direct compaction
> to allocate contiguous page. Compaction requires the taking of some heavily
> contended locks (e.g. zone locks). So, running compaction (direct and using
> kswapd) simultaneously on several processors can cause serious performance
> issues.

The main thing that this patch does is to add a nocompact flag to the page
allocator. That needs to be a separate patch. Also fix the description.
Slub does not invoke compaction. The page allocator initiates compaction
under certain conditions.

> It's possible to avoid such problems (or at least to make them less probable)
> by avoiding direct compaction. If it's not possible to allocate a contiguous
> page without compaction, slub will fall back to order 0 page(s). In this case
> kswapd will be woken to perform asynchronous compaction. So, slub can return
> to default order allocations as soon as memory will be de-fragmented.

Sounds like a good idea. Do you have some numbers to show the effect of
this patch?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3FNQIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:08:06 -0400
Received: from a9-50.smtp-out.amazonses.com ([54.240.9.50]:45346 "EHLO
	a9-50.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751864Ab3FNQIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:08:05 -0400
Date: Fri, 14 Jun 2013 16:08:02 +0000
From: Christoph Lameter <cl@gentwo.org>
To: Roman Gushchin <klamm@yandex-team.ru>
cc: Pekka Enberg <penberg@kernel.org>, mpm@selenic.com,
        akpm@linux-foundation.org, mgorman@suse.de,
        David Rientjes <rientjes@google.com>, glommer@gmail.com,
        hannes@cmpxchg.org, minchan@kernel.org, jiang.liu@huawei.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: Avoid direct compaction if possible
In-Reply-To: <51BB33FE.1020403@yandex-team.ru>
Message-ID: <0000013f43718d4d-7bb260e7-8115-4891-bb26-6febacb7169d-000000@email.amazonses.com>
References: <51BB1802.8050108@yandex-team.ru> <0000013f4319cb46-a5a3de58-1207-4037-ae39-574b58135ea2-000000@email.amazonses.com> <51BB33FE.1020403@yandex-team.ru>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.06.14-54.240.9.50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jun 2013, Roman Gushchin wrote:

> But there is an actual problem, that this patch solves.
> Sometimes I saw the following issue on some machines:
> all CPUs are performing compaction, system time is about 80%,
> system is completely unreliable. It occurs only on machines
> with specific workload (distributed data storage system, so,
> intensive disk i/o is performed). A system can fall into
> this state fast and unexpectedly or by progressive degradation.

Well that is not a slab allocator specific issue but related to compaction
concurrency. Likely cache line contention is causing a severe slowday. But
that issue could be triggered by any subsystem that does lots of memory
allocations. I would suggest that we try to address the problem in the
compaction logic rather than modifying allocators.

Mel?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066AbaGAWZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 18:25:08 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:41313 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaGAWZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 18:25:07 -0400
Date: Tue, 1 Jul 2014 15:25:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH v3 3/9] slab: defer slab_destroy in free_block()
In-Reply-To: <1404203258-8923-4-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.02.1407011524210.4004@chino.kir.corp.google.com>
References: <1404203258-8923-1-git-send-email-iamjoonsoo.kim@lge.com> <1404203258-8923-4-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2014, Joonsoo Kim wrote:

> In free_block(), if freeing object makes new free slab and number of
> free_objects exceeds free_limit, we start to destroy this new free slab
> with holding the kmem_cache node lock. Holding the lock is useless and,
> generally, holding a lock as least as possible is good thing. I never
> measure performance effect of this, but we'd be better not to hold the lock
> as much as possible.
> 
> Commented by Christoph:
>   This is also good because kmem_cache_free is no longer called while
>   holding the node lock. So we avoid one case of recursion.
> 
> Acked-by: Christoph Lameter <cl@linux.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Not sure what happened to my

Acked-by: David Rientjes <rientjes@google.com>

from http://marc.info/?l=linux-kernel&m=139951092124314, and for the 
record, I still think the free_block() "list" formal should be commented.

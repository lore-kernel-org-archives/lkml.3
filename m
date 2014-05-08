Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaEHBB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 21:01:57 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:63438 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaEHBBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 21:01:53 -0400
Date: Wed, 7 May 2014 18:01:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v2 04/10] slab: defer slab_destroy in free_block()
In-Reply-To: <1399442780-28748-5-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.02.1405071801040.1128@chino.kir.corp.google.com>
References: <1399442780-28748-1-git-send-email-iamjoonsoo.kim@lge.com> <1399442780-28748-5-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014, Joonsoo Kim wrote:

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

Acked-by: David Rientjes <rientjes@google.com>

Nice optimization.  I think it could have benefited from a comment 
describing what the free_block() list formal is, though.

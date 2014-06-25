Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaFYBDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 21:03:25 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:50951 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaFYBDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 21:03:24 -0400
Date: Tue, 24 Jun 2014 18:03:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH] slub: fix off by one in number of slab tests
In-Reply-To: <1403595842-28270-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.02.1406241801240.22030@chino.kir.corp.google.com>
References: <1403595842-28270-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014, Joonsoo Kim wrote:

> min_partial means minimum number of slab cached in node partial
> list. So, if nr_partial is less than it, we keep newly empty slab
> on node partial list rather than freeing it. But if nr_partial is
> equal or greater than it, it means that we have enough partial slabs
> so should free newly empty slab. Current implementation missed
> the equal case so if we set min_partial is 0, then, at least one slab
> could be cached. This is critical problem to kmemcg destroying logic
> because it doesn't works properly if some slabs is cached. This patch
> fixes this problem.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: David Rientjes <rientjes@google.com>

Needed for 3.16 to fix commit 91cb69620284 ("slub: make dead memcg caches 
discard free slabs immediately").

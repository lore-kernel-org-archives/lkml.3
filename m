Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbaFBMKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:10:47 -0400
Received: from mx2.parallels.com ([199.115.105.18]:34495 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbaFBMKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:10:46 -0400
Date: Mon, 2 Jun 2014 16:10:36 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: <akpm@linux-foundation.org>, <cl@linux.com>, <hannes@cmpxchg.org>,
        <mhocko@suse.cz>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH -mm 8/8] slab: reap dead memcg caches aggressively
Message-ID: <20140602121034.GB1039@esperanza>
References: <cover.1401457502.git.vdavydov@parallels.com>
 <23a736c90a81e13a2252d35d9fc3dc04a9ed7d7c.1401457502.git.vdavydov@parallels.com>
 <20140602044154.GB17964@js1304-P5Q-DELUXE>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140602044154.GB17964@js1304-P5Q-DELUXE>
X-Originating-IP: [109.195.248.178]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 01:41:55PM +0900, Joonsoo Kim wrote:
> According to my code reading, slabs_to_free() doesn't return number of
> free slabs. This bug is introduced by 0fa8103b. I think that it is
> better to fix it before applyting this patch. Otherwise, use n->free_objects
> instead of slabs_tofree() to achieve your purpose correctly.

Hmm, I don't think slab_tofree() computes the number of free slabs
wrong. If we have N free objects, there may be
DIV_ROUND_UP(N,objs_per_slab) empty slabs at max, and that's exactly
what slab_tofree() does, no?

Thanks.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbaGWKxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:53:25 -0400
Received: from mx2.parallels.com ([199.115.105.18]:41131 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbaGWKxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:53:22 -0400
Date: Wed, 23 Jul 2014 14:53:12 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <mhocko@suse.cz>, <hannes@cmpxchg.org>, <cl@linux.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 0/6] memcg: release memcg_cache_id on css offline
Message-ID: <20140723105312.GC30850@esperanza>
References: <cover.1405941342.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1405941342.git.vdavydov@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 03:47:10PM +0400, Vladimir Davydov wrote:
> This patch set makes memcg release memcg_cache_id on css offline. This
> way the memcg_caches arrays size will be limited by the number of alive
> kmem-active memory cgroups, which is much better.

Hi Andrew,

While preparing the per-memcg slab shrinkers patch set, I realized that
releasing memcg_cache_id on css offline is incorrect, because after css
offline there still can be elements on per-memcg list_lrus, which are
indexed by memcg_cache_id. We could re-parent them, but this is what we
decided to avoid in order to keep things clean and simple. So it seems
there's nothing we can do except keeping memcg_cache_ids till css free.

I wonder if we could reclaim memory from per memcg arrays (per memcg
list_lrus, kmem_caches) on memory pressure. May be, we could use
flex_array to achieve that.

Anyway, could you please drop the following patches from the mmotm tree
(all this set except patch 1, which is a mere cleanup)?

  memcg-release-memcg_cache_id-on-css-offline
  memcg-keep-all-children-of-each-root-cache-on-a-list
  memcg-add-pointer-to-owner-cache-to-memcg_cache_params
  memcg-make-memcg_cache_id-static
  slab-use-mem_cgroup_id-for-per-memcg-cache-naming

Sorry about the noise.

Thank you.

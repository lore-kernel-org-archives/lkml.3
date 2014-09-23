Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbaIWHbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 03:31:22 -0400
Received: from mx2.parallels.com ([199.115.105.18]:53778 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaIWHbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 03:31:21 -0400
Date: Tue, 23 Sep 2014 11:31:11 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.cz>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 1/2] memcg: move memcg_{alloc,free}_cache_params to
 slab_common.c
Message-ID: <20140923073111.GC3588@esperanza>
References: <e768785511927d65bd3e6d9f65ab2a9851a3d73d.1411054735.git.vdavydov@parallels.com>
 <20140922200825.GA5373@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140922200825.GA5373@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 04:08:25PM -0400, Johannes Weiner wrote:
> On Thu, Sep 18, 2014 at 07:50:19PM +0400, Vladimir Davydov wrote:
> > The only reason why they live in memcontrol.c is that we get/put css
> > reference to the owner memory cgroup in them. However, we can do that in
> > memcg_{un,}register_cache.
> > 
> > So let's move them to slab_common.c and make them static.
> > 
> > Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Michal Hocko <mhocko@suse.cz>
> > Cc: Christoph Lameter <cl@linux.com>
> 
> Cool, so you get rid of the back-and-forth between memcg and slab, and
> thereby also shrink the public memcg interface.

It should be mentioned that we still call memcg_update_array_size()
(defined at memcontrol.c) from memcg_update_all_caches()
(slab_common.c), because we must hold the slab_mutex while updating
memcg_limited_groups_array_size. However, I'm going to remove this
requirement and get rid of memcg_update_array_size() too. This is what
"[PATCH -mm 10/14] memcg: add rwsem to sync against memcg_caches arrays
relocation", which is a part of my "Per memcg slab shrinkers" patch set,
does.

Thanks,
Vladimir

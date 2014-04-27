Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaD0I4p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 04:56:45 -0400
Received: from mx2.parallels.com ([199.115.105.18]:60186 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbaD0I4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 04:56:40 -0400
Date: Sun, 27 Apr 2014 12:56:08 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <mhocko@suse.cz>, <hannes@cmpxchg.org>, <glommer@gmail.com>,
        <cl@linux-foundation.org>, <penberg@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>
Subject: Re: [PATCH -mm 0/6] memcg/kmem: cleanup naming and callflows
Message-ID: <20140427085606.GA4183@esperanza>
References: <cover.1398428532.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1398428532.git.vdavydov@parallels.com>
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore this set - I found that something can be improved, will
send v2 soon. Sorry for the noise.

Thanks.

On Fri, Apr 25, 2014 at 04:33:06PM +0400, Vladimir Davydov wrote:
> Hi,
> 
> In reply to "[PATCH RFC -mm v2 3/3] memcg, slab: simplify
> synchronization scheme" Johannes wrote:
> 
> > I like this patch, but the API names are confusing. Could we fix up
> > that whole thing by any chance?
> 
> (see https://lkml.org/lkml/2014/4/18/317)
> 
> So this patch set is about cleaning up memcg/kmem naming.
> 
> While preparing it I found that some of the ugly-named functions
> constituting interface between memcontrol.c and slab_common.c can be
> neatly got rid of w/o complicating the code. Quite the contrary, w/o
> them call-flows look much simpler, IMO. So the first four patches do not
> rename anything actually - they just rework call-flows in kmem cache
> creation/destruction and memcg_caches arrays relocations paths. Finally,
> patches 5 and 6 clean up the naming.
> 
> Reviews are appreciated.
> 
> Thanks,
> 
> Vladimir Davydov (6):
>   memcg: get rid of memcg_create_cache_name
>   memcg: allocate memcg_caches array on first per memcg cache creation
>   memcg: cleanup memcg_caches arrays relocation path
>   memcg: get rid of memcg_{alloc,free}_cache_params
>   memcg: cleanup kmem cache creation/destruction functions naming
>   memcg: cleanup kmem_id-related naming
> 
>  include/linux/memcontrol.h |   40 +----
>  include/linux/slab.h       |   12 +-
>  mm/memcontrol.c            |  420 ++++++++++++++++++++------------------------
>  mm/slab.c                  |    4 +-
>  mm/slab.h                  |   24 ++-
>  mm/slab_common.c           |  127 ++++++++++----
>  mm/slub.c                  |   10 +-
>  7 files changed, 320 insertions(+), 317 deletions(-)
> 
> -- 
> 1.7.10.4
> 

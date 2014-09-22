Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbaIVUId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 16:08:33 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:48282 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402AbaIVUIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 16:08:32 -0400
Date: Mon, 22 Sep 2014 16:08:25 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 1/2] memcg: move memcg_{alloc,free}_cache_params to
 slab_common.c
Message-ID: <20140922200825.GA5373@cmpxchg.org>
References: <e768785511927d65bd3e6d9f65ab2a9851a3d73d.1411054735.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e768785511927d65bd3e6d9f65ab2a9851a3d73d.1411054735.git.vdavydov@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 07:50:19PM +0400, Vladimir Davydov wrote:
> The only reason why they live in memcontrol.c is that we get/put css
> reference to the owner memory cgroup in them. However, we can do that in
> memcg_{un,}register_cache.
> 
> So let's move them to slab_common.c and make them static.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Christoph Lameter <cl@linux.com>

Cool, so you get rid of the back-and-forth between memcg and slab, and
thereby also shrink the public memcg interface.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

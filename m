Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbaIZQbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 12:31:34 -0400
Received: from resqmta-po-06v.sys.comcast.net ([96.114.154.165]:54779 "EHLO
	resqmta-po-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755153AbaIZQbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 12:31:33 -0400
Date: Fri, 26 Sep 2014 11:31:31 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] slab: fix cpuset check in fallback_alloc
In-Reply-To: <5ccdd901946feaf88fd6d2441b18a6845cc56571.1411741632.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.11.1409261130550.3870@gentwo.org>
References: <cover.1411741632.git.vdavydov@parallels.com> <5ccdd901946feaf88fd6d2441b18a6845cc56571.1411741632.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2014, Vladimir Davydov wrote:

> To avoid this we should use softwall cpuset check in fallback_alloc.

Its weird that softwall checking occurs by setting __GFP_HARDWALL.
>
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> ---
>  mm/slab.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/slab.c b/mm/slab.c
> index eb6f0cf6875c..e35822d07821 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3051,7 +3051,7 @@ retry:
>  	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
>  		nid = zone_to_nid(zone);
>
> -		if (cpuset_zone_allowed(zone, flags | __GFP_HARDWALL) &&
> +		if (cpuset_zone_allowed(zone, flags) &&
>  			get_node(cache, nid) &&
>  			get_node(cache, nid)->free_objects) {
>  				obj = ____cache_alloc_node(cache,
>

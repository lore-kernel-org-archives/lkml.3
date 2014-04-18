Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbaDRQIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 12:08:22 -0400
Received: from relay.parallels.com ([195.214.232.42]:55887 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaDRQIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 12:08:19 -0400
Message-ID: <53514DF1.804@parallels.com>
Date: Fri, 18 Apr 2014 20:08:17 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: <mhocko@suse.cz>, <akpm@linux-foundation.org>, <glommer@gmail.com>,
        <cl@linux-foundation.org>, <penberg@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>
Subject: Re: [PATCH RFC -mm v2 3/3] memcg, slab: simplify synchronization
 scheme
References: <cover.1397804745.git.vdavydov@parallels.com> <c3c36df83d582f8fac94bb716b82406e24229cad.1397804745.git.vdavydov@parallels.com> <20140418141734.GD26283@cmpxchg.org>
In-Reply-To: <20140418141734.GD26283@cmpxchg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2014 06:17 PM, Johannes Weiner wrote:
> I like this patch, but the API names are confusing.  Could we fix up
> that whole thing by any chance?  Some suggestions below, but they
> might only be marginally better...

Yeah, names are inconsistent in kmemcg and desperately want improvement:

mem_cgroup_destroy_all_caches
kmem_cgroup_css_offline
memcg_kmem_get_cache
memcg_charge_kmem
memcg_create_cache_name

I've been thinking on cleaning this up for some time, but couldn't make
up my mind to do this. I think it cannot wait any more now, so my next
patch set will rework kmemcg naming.

Can we apply this patch as is for now? It'd be more convenient for me to
rework naming on top of the end picture.

Thanks.

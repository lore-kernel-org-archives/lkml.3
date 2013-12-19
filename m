Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab3LSIst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:48:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44024 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024Ab3LSIsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:48:47 -0500
Date: Thu, 19 Dec 2013 09:48:45 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
        devel@openvz.org, Johannes Weiner <hannes@cmpxchg.org>,
        Glauber Costa <glommer@gmail.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/6] memcg, slab: kmem_cache_create_memcg(): free memcg
 params on error
Message-ID: <20131219084845.GB9331@dhcp22.suse.cz>
References: <6f02b2d079ffd0990ae335339c803337b13ecd8c.1387372122.git.vdavydov@parallels.com>
 <9420ad797a2cfa14c23ad1ba6db615a2a51ffee0.1387372122.git.vdavydov@parallels.com>
 <20131218170649.GC31080@dhcp22.suse.cz>
 <52B292FD.8040603@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B292FD.8040603@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 19-12-13 10:32:29, Vladimir Davydov wrote:
> On 12/18/2013 09:06 PM, Michal Hocko wrote:
> > On Wed 18-12-13 17:16:53, Vladimir Davydov wrote:
> >> Plus, rename memcg_register_cache() to memcg_init_cache_params(),
> >> because it actually does not register the cache anywhere, but simply
> >> initialize kmem_cache::memcg_params.
> > I've almost missed this is a memory leak fix.
> 
> Yeah, the comment is poor, sorry about that. Will fix it.
> 
> > I do not mind renaming and the name but wouldn't
> > memcg_alloc_cache_params suit better?
> 
> As you wish. I don't have a strong preference for memcg_init_cache_params.

I really hate naming... but it seems that alloc is a better fit. _init_
would expect an already allocated object.

Btw. memcg_free_cache_params is called only once which sounds
suspicious. The regular destroy path should use it as well?
[...]
-- 
Michal Hocko
SUSE Labs

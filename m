Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbaC0Un0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 16:43:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757215AbaC0UnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 16:43:25 -0400
Date: Thu, 27 Mar 2014 13:43:20 -0700
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Greg Thelen <gthelen@google.com>, akpm@linux-foundation.org,
        hannes@cmpxchg.org, glommer@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, devel@openvz.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH -mm 1/4] sl[au]b: do not charge large allocations to memcg
Message-ID: <20140327204320.GC28590@dhcp22.suse.cz>
References: <cover.1395846845.git.vdavydov@parallels.com>
 <5a5b09d4cb9a15fc120b4bec8be168630a3b43c2.1395846845.git.vdavydov@parallels.com>
 <xr93fvm42rew.fsf@gthelen.mtv.corp.google.com>
 <5333D527.2060208@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5333D527.2060208@parallels.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 27-03-14 11:37:11, Vladimir Davydov wrote:
[...]
> In fact, do we actually need to charge every random kmem allocation? I
> guess not. For instance, filesystems often allocate data shared among
> all the FS users. It's wrong to charge such allocations to a particular
> memcg, IMO. That said the next step is going to be adding a per kmem
> cache flag specifying if allocations from this cache should be charged
> so that accounting will work only for those caches that are marked so
> explicitly.

How do you select which caches to track?

-- 
Michal Hocko
SUSE Labs

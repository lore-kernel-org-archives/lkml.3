Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbbASOaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:30:09 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:64197 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbbASOaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:30:05 -0500
Date: Mon, 19 Jan 2015 09:30:01 -0500
From: Tejun Heo <tj@kernel.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm v2 3/7] cgroup: release css->id after css_free
Message-ID: <20150119143001.GH8140@htj.dyndns.org>
References: <cover.1421664712.git.vdavydov@parallels.com>
 <4d7447a920522c1085ff96c08b2be71e0eb5d896.1421664712.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d7447a920522c1085ff96c08b2be71e0eb5d896.1421664712.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 02:23:21PM +0300, Vladimir Davydov wrote:
> Currently, we release css->id in css_release_work_fn, right before
> calling css_free callback, so that when css_free is called, the id may
> have already been reused for a new cgroup.
> 
> I am going to use css->id to create unique names for per memcg kmem
> caches. Since kmem caches are destroyed only on css_free, I need css->id
> to be freed after css_free was called to avoid name clashes. This patch
> therefore moves css->id removal to css_free_work_fn. To prevent
> css_from_id from returning a pointer to a stale css, it makes
> css_release_work_fn replace the css ptr at css_idr:css->id with NULL.

I think it'd be better if you create a separate id for this purpose.
The requirement is pretty unusual and likely contradictory with other
usages.

Thanks.

-- 
tejun

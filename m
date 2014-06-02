Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbaFBPN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:13:58 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:56235
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751918AbaFBPN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:13:57 -0400
Date: Mon, 2 Jun 2014 10:13:54 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm 4/8] slub: never fail kmem_cache_shrink
In-Reply-To: <20140531101819.GA25076@esperanza>
Message-ID: <alpine.DEB.2.10.1406021012040.2987@gentwo.org>
References: <cover.1401457502.git.vdavydov@parallels.com> <ac8907cace921c3209aa821649349106f4f70b34.1401457502.git.vdavydov@parallels.com> <alpine.DEB.2.10.1405300937560.11943@gentwo.org> <20140531101819.GA25076@esperanza>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2014, Vladimir Davydov wrote:

> ... which means more async workers, more complication to kmemcg code :-(
>
> Sorry, but I just don't get why we can't make kmem_cache_shrink never
> fail? Is failing de-fragmentation, which is even not implied by the
> function declaration, so critical that should be noted? If so, we can
> return an error while still shrinking empty slabs...

There could be other reasons for failure in the future as
kmem_cache_shrink is updated. Requiring kmem_cache_shrink to never fail
may cause problems for future modifications.

> If you just don't like the code after the patch, here is another, less
> intrusive version doing practically the same. Would it be better?

That looks acceptable.

Acked-by: Christoph Lameter <cl@linux.com>

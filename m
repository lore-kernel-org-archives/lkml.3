Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaFJKDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 06:03:33 -0400
Received: from mx2.parallels.com ([199.115.105.18]:35600 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaFJKDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 06:03:31 -0400
Date: Tue, 10 Jun 2014 14:03:15 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: <akpm@linux-foundation.org>, <cl@linux.com>, <rientjes@google.com>,
        <penberg@kernel.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH -mm v2 8/8] slab: make dead memcg caches discard free
 slabs immediately
Message-ID: <20140610100313.GA6293@esperanza>
References: <cover.1402060096.git.vdavydov@parallels.com>
 <27a202c6084d6bb19cc3e417793f05104b908ded.1402060096.git.vdavydov@parallels.com>
 <20140610074317.GE19036@js1304-P5Q-DELUXE>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140610074317.GE19036@js1304-P5Q-DELUXE>
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 10, 2014 at 04:43:17PM +0900, Joonsoo Kim wrote:
> You mentioned that disabling per cpu arrays would degrade performance.
> But, this patch is implemented to disable per cpu arrays. Is there any
> reason to do like this? How about not disabling per cpu arrays and
> others? Leaving it as is makes the patch less intrusive and has low
> impact on performance. I guess that amount of reclaimed memory has no
> big difference between both approaches.

Frankly, I incline to shrinking dead SLAB caches periodically from
cache_reap too, because it looks neater and less intrusive to me. Also
it has zero performance impact, which is nice.

However, Christoph proposed to disable per cpu arrays for dead caches,
similarly to SLUB, and I decided to give it a try, just to see the end
code we'd have with it.

I'm still not quite sure which way we should choose though...

Thanks.

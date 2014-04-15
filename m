Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbaDOTcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:32:24 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:33253
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074AbaDOTcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:32:21 -0400
Date: Tue, 15 Apr 2014 14:32:17 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org,
        mhocko@suse.cz, glommer@gmail.com, penberg@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, devel@openvz.org
Subject: Re: [PATCH -mm 1/4] memcg, slab: do not schedule cache destruction
 when last page goes away
In-Reply-To: <534D83AB.6040107@parallels.com>
Message-ID: <alpine.DEB.2.10.1404151431400.29234@gentwo.org>
References: <cover.1397054470.git.vdavydov@parallels.com> <8ea8b57d5264f16ee33497a4317240648645704a.1397054470.git.vdavydov@parallels.com> <20140415021614.GC7969@cmpxchg.org> <534CD08F.30702@parallels.com> <alpine.DEB.2.10.1404151016400.11231@gentwo.org>
 <534D83AB.6040107@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014, Vladimir Davydov wrote:

> > There is already logic in both slub and slab that does that on cache
> > close.
>
> Yeah, but here the question is when we should close caches left after memcg
> offline. Obviously we should do it after all objects of such a cache have
> gone, but when exactly? Do it immediately after the last kfree (have to count
> objects per cache then AFAIU) or may be check periodically (or on vmpressure)
> that the cache is empty by issuing kmem_cache_shrink and looking if
> memcg_params::nr_pages = 0?

Guess check once in a while if you have no other way to determine this. A
hook in kfree() would impact all users.


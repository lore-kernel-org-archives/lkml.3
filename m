Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbbAZTzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 14:55:19 -0500
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:44605 "EHLO
	resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753818AbbAZTzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:55:16 -0500
Date: Mon, 26 Jan 2015 13:55:14 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/3] slab: zap kmem_cache_shrink return value
In-Reply-To: <20150126194838.GB2660@esperanza>
Message-ID: <alpine.DEB.2.11.1501261353480.16786@gentwo.org>
References: <cover.1422275084.git.vdavydov@parallels.com> <b89d28384f8ec7865c3fefc2f025955d55798b78.1422275084.git.vdavydov@parallels.com> <alpine.DEB.2.11.1501260949150.15849@gentwo.org> <20150126170418.GC28978@esperanza> <alpine.DEB.2.11.1501261226250.16638@gentwo.org>
 <20150126194838.GB2660@esperanza>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015, Vladimir Davydov wrote:

> Hmm, why? The return value has existed since this function was
> introduced, but nobody seems to have ever used it outside the slab core.
> Besides, this check is racy, so IMO we shouldn't encourage users of the
> API to rely on it. That said, I believe we should drop the return value
> for now. If anybody ever needs it, we can reintroduce it.

The check is only racy if you have concurrent users. It is not racy if a
subsystem shuts down access to the slabs and then checks if everything is
clean before closing the cache.

Slab creation and destruction are not serialized. It is the responsibility
of the subsystem to make sure that there are no concurrent users and that
there are no objects remaining before destroying a slab.


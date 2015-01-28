Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbbA1Uyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:54:43 -0500
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:38798 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753743AbbA1Uyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:54:40 -0500
Date: Wed, 28 Jan 2015 10:37:09 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm v2 1/3] slub: never fail to shrink cache
In-Reply-To: <012683fc3a0f9fb20a288986fd63fe9f6d25e8ee.1422461573.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.11.1501281034290.32147@gentwo.org>
References: <cover.1422461573.git.vdavydov@parallels.com> <012683fc3a0f9fb20a288986fd63fe9f6d25e8ee.1422461573.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2015, Vladimir Davydov wrote:

> +			/* We do not keep full slabs on the list */
> +			BUG_ON(free <= 0);

Well sorry we do actually keep a number of empty slabs on the partial
lists. See the min_partial field in struct kmem_cache.


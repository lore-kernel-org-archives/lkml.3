Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbbAZTxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 14:53:37 -0500
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:35367 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753818AbbAZTxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:53:35 -0500
Date: Mon, 26 Jan 2015 13:53:32 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/3] slub: don't fail kmem_cache_shrink if slab
 placement optimization fails
In-Reply-To: <20150126193629.GA2660@esperanza>
Message-ID: <alpine.DEB.2.11.1501261353020.16786@gentwo.org>
References: <cover.1422275084.git.vdavydov@parallels.com> <3804a429071f939e6b4f654b6c6426c1fdd95f7e.1422275084.git.vdavydov@parallels.com> <alpine.DEB.2.11.1501260944550.15849@gentwo.org> <20150126170147.GB28978@esperanza> <alpine.DEB.2.11.1501261216120.16638@gentwo.org>
 <20150126193629.GA2660@esperanza>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015, Vladimir Davydov wrote:

> We could do that, but IMO that would only complicate the code w/o
> yielding any real benefits. This function is slow and called rarely
> anyway, so I don't think there is any point to optimize out a page
> allocation here.

I think you already have the code there. Simply allow the sizeing of the
empty_page[] array. And rename it.


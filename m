Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbaFBPQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:16:11 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:60293 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755409AbaFBPQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:16:08 -0400
Date: Mon, 2 Jun 2014 10:16:03 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm 5/8] slab: remove kmem_cache_shrink retval
In-Reply-To: <20140531102740.GB25076@esperanza>
Message-ID: <alpine.DEB.2.10.1406021014140.2987@gentwo.org>
References: <cover.1401457502.git.vdavydov@parallels.com> <d2bbd28ae0f0c1807f9fe72d0443eccb739b8aa6.1401457502.git.vdavydov@parallels.com> <alpine.DEB.2.10.1405300947170.11943@gentwo.org> <20140531102740.GB25076@esperanza>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2014, Vladimir Davydov wrote:

> > Well slub returns an error code if it fails
>
> ... to sort slabs by the nubmer of objects in use, which is not even
> implied by the function declaration. Why can *shrinking*, which is what
> kmem_cache_shrink must do at first place, ever fail?

Because there is a memory allocation failure. Or there may be other
processes going on that prevent shrinking. F.e. We may want to merge a
patchset that does defragmentation of slabs at some point.


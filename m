Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab3HWOCC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 10:02:02 -0400
Received: from a10-51.smtp-out.amazonses.com ([54.240.10.51]:41597 "EHLO
	a10-51.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755205Ab3HWOCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 10:02:00 -0400
X-Greylist: delayed 1140 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Aug 2013 10:02:00 EDT
Date: Fri, 23 Aug 2013 13:42:59 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/16] slab: remove cachep in struct slab_rcu
In-Reply-To: <20130823065315.GG22605@lge.com>
Message-ID: <00000140ab69e6be-3b2999b6-93b4-4b22-a91f-8929aee5238f-000000@email.amazonses.com>
References: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com> <1377161065-30552-6-git-send-email-iamjoonsoo.kim@lge.com> <00000140a72870a6-f7c87696-ecbc-432c-9f41-93f414c0c623-000000@email.amazonses.com> <20130823065315.GG22605@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.23-54.240.10.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Aug 2013, Joonsoo Kim wrote:

> On Thu, Aug 22, 2013 at 05:53:00PM +0000, Christoph Lameter wrote:
> > On Thu, 22 Aug 2013, Joonsoo Kim wrote:
> >
> > > We can get cachep using page in struct slab_rcu, so remove it.
> >
> > Ok but this means that we need to touch struct page. Additional cacheline
> > in cache footprint.
>
> In following patch, we overload RCU_HEAD to LRU of struct page and
> also overload struct slab to struct page. So there is no
> additional cacheline footprint at final stage.

If you do not use rcu (standard case) then you have an additional
cacheline.


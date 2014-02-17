Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaBQG0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 01:26:53 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:60718 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaBQG0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 01:26:52 -0500
X-Original-SENDERIP: 10.177.220.200
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 17 Feb 2014 15:12:01 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] slab: remove a useless lockdep annotation
Message-ID: <20140217061201.GA3468@lge.com>
References: <1392361043-22420-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1392361043-22420-10-git-send-email-iamjoonsoo.kim@lge.com>
 <alpine.DEB.2.10.1402141248560.12887@nuc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1402141248560.12887@nuc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 12:49:57PM -0600, Christoph Lameter wrote:
> On Fri, 14 Feb 2014, Joonsoo Kim wrote:
> 
> > @@ -921,7 +784,7 @@ static int transfer_objects(struct array_cache *to,
> >  static inline struct alien_cache **alloc_alien_cache(int node,
> >  						int limit, gfp_t gfp)
> >  {
> > -	return (struct alien_cache **)BAD_ALIEN_MAGIC;
> > +	return NULL;
> >  }
> >
> 
> Why change the BAD_ALIEN_MAGIC?

Hello, Christoph.

BAD_ALIEN_MAGIC is only checked by slab_set_lock_classes(). We remove this
function in this patch, so returning BAD_ALIEN_MAGIC is useless.
And, in fact, BAD_ALIEN_MAGIC is already useless, because alloc_alien_cache()
can't be called on !CONFIG_NUMA. This function is called if use_alien_caches
is positive, but on !CONFIG_NUMA, use_alien_caches is always 0. So we don't
have any chance to meet this BAD_ALIEN_MAGIC in runtime.

Thanks.

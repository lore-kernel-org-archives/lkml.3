Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933802AbaHZCXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 22:23:47 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:37177 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaHZCXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 22:23:46 -0400
X-Original-SENDERIP: 10.177.222.131
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 26 Aug 2014 11:23:59 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/slab_common: commonize slab merge logic
Message-ID: <20140826022359.GB1035@js1304-P5Q-DELUXE>
References: <1408608675-20420-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1408608675-20420-2-git-send-email-iamjoonsoo.kim@lge.com>
 <alpine.DEB.2.11.1408251026110.27302@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1408251026110.27302@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 10:27:58AM -0500, Christoph Lameter wrote:
> On Thu, 21 Aug 2014, Joonsoo Kim wrote:
> 
> > +static int __init setup_slab_nomerge(char *str)
> > +{
> > +	slab_nomerge = 1;
> > +	return 1;
> > +}
> > +__setup("slub_nomerge", setup_slab_nomerge);
> 
> Uhh.. You would have to specify "slub_nomerge" to get slab to not merge
> slab caches?

Should fix it. How about following change?

#ifdef CONFIG_SLUB
__setup("slub_nomerge", setup_slab_nomerge);
#endif

__setup("slab_nomerge", setup_slab_nomerge);

This makes "slab_nomerge" works for all SL[aou]B.

Thanks.

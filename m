Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbaHYI0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:26:09 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42710 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009AbaHYI0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:26:06 -0400
X-Original-SENDERIP: 10.177.222.131
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 25 Aug 2014 17:26:15 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/slab: use percpu allocator for cpu cache
Message-ID: <20140825082615.GA13475@js1304-P5Q-DELUXE>
References: <1408608675-20420-1-git-send-email-iamjoonsoo.kim@lge.com>
 <alpine.DEB.2.11.1408210918050.32524@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1408210918050.32524@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 09:21:30AM -0500, Christoph Lameter wrote:
> On Thu, 21 Aug 2014, Joonsoo Kim wrote:
> 
> > So, this patch try to use percpu allocator in SLAB. This simplify
> > initialization step in SLAB so that we could maintain SLAB code more
> > easily.
> 
> I thought about this a couple of times but the amount of memory used for
> the per cpu arrays can be huge. In contrast to slub which needs just a
> few pointers, slab requires one pointer per object that can be in the
> local cache. CC Tj.
> 
> Lets say we have 300 caches and we allow 1000 objects to be cached per
> cpu. That is 300k pointers per cpu. 1.2M on 32 bit. 2.4M per cpu on
> 64bit.

Hello, Christoph.

Amount of memory we need to keep pointers for object is same in any case.
I know that percpu allocator occupy vmalloc space, so maybe we could
exhaust vmalloc space on 32 bit. 64 bit has no problem on it.
How many cores does largest 32 bit system have? Is it possible
to exhaust vmalloc space if we use percpu allocator?

Thanks.

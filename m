Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaAOCbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:31:37 -0500
Received: from mail-gg0-f174.google.com ([209.85.161.174]:33954 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaAOCbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:31:35 -0500
Date: Tue, 14 Jan 2014 18:31:31 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@sr71.net>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC][PATCH 1/9] mm: slab/slub: use page->list consistently
 instead of page->lru
In-Reply-To: <20140114180044.1E401C47@viggo.jf.intel.com>
Message-ID: <alpine.DEB.2.02.1401141829530.32645@chino.kir.corp.google.com>
References: <20140114180042.C1C33F78@viggo.jf.intel.com> <20140114180044.1E401C47@viggo.jf.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-685474905-1389753093=:32645"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-685474905-1389753093=:32645
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 14 Jan 2014, Dave Hansen wrote:

> diff -puN include/linux/mm_types.h~make-slab-use-page-lru-vs-list-consistently include/linux/mm_types.h
> --- a/include/linux/mm_types.h~make-slab-use-page-lru-vs-list-consistently	2014-01-14 09:57:56.099621967 -0800
> +++ b/include/linux/mm_types.h	2014-01-14 09:57:56.106622281 -0800
> @@ -124,6 +124,8 @@ struct page {
>  	union {
>  		struct list_head lru;	/* Pageout list, eg. active_list
>  					 * protected by zone->lru_lock !
> +					 * Can be used as a generic list
> +					 * by the page owner.
>  					 */
>  		struct {		/* slub per cpu partial pages */
>  			struct page *next;	/* Next partial slab */
> @@ -136,7 +138,6 @@ struct page {
>  #endif
>  		};
>  
> -		struct list_head list;	/* slobs list of pages */
>  		struct slab *slab_page; /* slab fields */
>  		struct rcu_head rcu_head;	/* Used by SLAB
>  						 * when destroying via RCU

Did you try with a CONFIG_BLOCK config?

block/blk-mq.c: In function ‘blk_mq_free_rq_map’:
block/blk-mq.c:1094:10: error: ‘struct page’ has no member named ‘list’
block/blk-mq.c:1094:10: warning: initialization from incompatible pointer type [enabled by default]
block/blk-mq.c:1094:10: error: ‘struct page’ has no member named ‘list’
block/blk-mq.c:1095:22: error: ‘struct page’ has no member named ‘list’
block/blk-mq.c: In function ‘blk_mq_init_rq_map’:
block/blk-mq.c:1159:22: error: ‘struct page’ has no member named ‘list’
--531381512-685474905-1389753093=:32645--

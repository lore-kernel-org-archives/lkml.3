Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbaGXSLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:11:20 -0400
Received: from smtprelay0183.hostedemail.com ([216.40.44.183]:59782 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752666AbaGXSLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:11:19 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3870:3871:3872:4321:5007:7652:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: steam55_455bc2431cd35
X-Filterd-Recvd-Size: 1957
Message-ID: <1406225475.27221.59.camel@joe-AO725>
Subject: Re: [PATCH] gpu: drm: omapdrm: Use %pad format for values of the
 dma_addr_t type
From: Joe Perches <joe@perches.com>
To: matwey@sai.msu.ru
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-omap@vger.kernel.org,
        matwey.kornilov@gmail.com
Date: Thu, 24 Jul 2014 11:11:15 -0700
In-Reply-To: <1406224686-4857-1-git-send-email-matwey@sai.msu.ru>
References: <1406224686-4857-1-git-send-email-matwey@sai.msu.ru>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-24 at 21:58 +0400, matwey@sai.msu.ru wrote:
> The format change is to fix the following compilation issue:

Just a trivial note:

> diff --git a/drivers/gpu/drm/omapdrm/omap_gem.c b/drivers/gpu/drm/omapdrm/omap_gem.c
[]
> @@ -791,7 +791,7 @@ int omap_gem_get_paddr(struct drm_gem_object *obj,
>  			omap_obj->paddr = tiler_ssptr(block);
>  			omap_obj->block = block;
>  
> -			DBG("got paddr: %08x", omap_obj->paddr);
> +			DBG("got paddr: %pad", &(omap_obj->paddr));

&foo->bar does not need parentheses.

Most uses in the kernel do not have them.
It seems to be ~25:1 without to with.

> @@ -985,9 +985,9 @@ void omap_gem_describe(struct drm_gem_object *obj, struct seq_file *m)
>  
>  	off = drm_vma_node_start(&obj->vma_node);
>  
> -	seq_printf(m, "%08x: %2d (%2d) %08llx %08Zx (%2d) %p %4d",
> +	seq_printf(m, "%08x: %2d (%2d) %08llx %pad (%2d) %p %4d",
>  			omap_obj->flags, obj->name, obj->refcount.refcount.counter,
> -			off, omap_obj->paddr, omap_obj->paddr_cnt,
> +			off, &(omap_obj->paddr), omap_obj->paddr_cnt,

etc...



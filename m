Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab3CKOyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:54:50 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18394 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3CKOyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:54:49 -0400
Date: Mon, 11 Mar 2013 10:54:35 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
Cc: xen-devel@lists.xensource.com, jeremy@goop.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: replace kmalloc and then memcpy with kmemdup
Message-ID: <20130311145435.GB26394@phenom.dumpdata.com>
References: <1363001016-8439-1-git-send-email-mihneadb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363001016-8439-1-git-send-email-mihneadb@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 01:23:36PM +0200, Mihnea Dobrescu-Balaur wrote:

Are there performance improvements to doing it this way?

> Signed-off-by: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
> ---
>  drivers/block/xen-blkfront.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index c3dae2e..9620644 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -1203,11 +1203,10 @@ static int blkif_recover(struct blkfront_info *info)
>  	int j;
>  
>  	/* Stage 1: Make a safe copy of the shadow state. */
> -	copy = kmalloc(sizeof(info->shadow),
> +	copy = kmemdup(info->shadow, sizeof(info->shadow),
>  		       GFP_NOIO | __GFP_REPEAT | __GFP_HIGH);
>  	if (!copy)
>  		return -ENOMEM;
> -	memcpy(copy, info->shadow, sizeof(info->shadow));
>  
>  	/* Stage 2: Set up free list. */
>  	memset(&info->shadow, 0, sizeof(info->shadow));
> -- 
> 1.7.10.4
> 

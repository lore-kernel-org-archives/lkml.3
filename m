Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab3HEIwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:52:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab3HEIwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:52:46 -0400
Date: Mon, 5 Aug 2013 16:54:04 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] cma: use macro PFN_DOWN when converting size to pages
Message-ID: <20130805085404.GA22170@kroah.com>
References: <51FF62C4.9010001@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FF62C4.9010001@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 04:31:00PM +0800, Xishi Qiu wrote:
> Use "PFN_DOWN(r->size)" instead of "r->size >> PAGE_SHIFT".
> 
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> ---
>  drivers/base/dma-contiguous.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> index 0ca5442..1bcfaed 100644
> --- a/drivers/base/dma-contiguous.c
> +++ b/drivers/base/dma-contiguous.c
> @@ -201,13 +201,12 @@ static int __init cma_init_reserved_areas(void)
>  {
>  	struct cma_reserved *r = cma_reserved;
>  	unsigned i = cma_reserved_count;
> +	struct cma *cma;

Why change this?

>  
>  	pr_debug("%s()\n", __func__);
>  
>  	for (; i; --i, ++r) {
> -		struct cma *cma;
> -		cma = cma_create_area(PFN_DOWN(r->start),
> -				      r->size >> PAGE_SHIFT);
> +		cma = cma_create_area(PFN_DOWN(r->start), PFN_DOWN(r->size));

That's reasonable to clean up, but nothing major.  Care to resend this
without the cma change?

thanks,

greg k-h

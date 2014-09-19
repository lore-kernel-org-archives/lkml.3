Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbaISRBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 13:01:32 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33441 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbaISRBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 13:01:31 -0400
Message-ID: <541C6168.7030701@infradead.org>
Date: Fri, 19 Sep 2014 10:01:28 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Liu Hua <sdu.liu@huawei.com>, shuah.khan@hp.com
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        peifeiyue@huawei.com, Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] Documentation: correct parameter error for dma_mapping_error
References: <1411013728-56125-1-git-send-email-sdu.liu@huawei.com>
In-Reply-To: <1411013728-56125-1-git-send-email-sdu.liu@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/14 21:15, Liu Hua wrote:
> dma_mapping_error takes two parameters, but some of examples
> in Documentation/DMA-API-HOWTO.txt just takes one. So correct
> it.
> 
> Signed-off-by: Liu Hua <sdu.liu@huawei.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

Jiri, please apply this patch.  Thanks.

> ---
>  Documentation/DMA-API-HOWTO.txt | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
> index dcbbe36..0f7afb2 100644
> --- a/Documentation/DMA-API-HOWTO.txt
> +++ b/Documentation/DMA-API-HOWTO.txt
> @@ -531,7 +531,7 @@ To map a single region, you do:
>  	size_t size = buffer->len;
>  
>  	dma_handle = dma_map_single(dev, addr, size, direction);
> -	if (dma_mapping_error(dma_handle)) {
> +	if (dma_mapping_error(dev, dma_handle)) {
>  		/*
>  		 * reduce current DMA mapping usage,
>  		 * delay and try again later or
> @@ -588,7 +588,7 @@ Specifically:
>  	size_t size = buffer->len;
>  
>  	dma_handle = dma_map_page(dev, page, offset, size, direction);
> -	if (dma_mapping_error(dma_handle)) {
> +	if (dma_mapping_error(dev, dma_handle)) {
>  		/*
>  		 * reduce current DMA mapping usage,
>  		 * delay and try again later or
> @@ -689,7 +689,7 @@ to use the dma_sync_*() interfaces.
>  		dma_addr_t mapping;
>  
>  		mapping = dma_map_single(cp->dev, buffer, len, DMA_FROM_DEVICE);
> -		if (dma_mapping_error(dma_handle)) {
> +		if (dma_mapping_error(cp->dev, dma_handle)) {
>  			/*
>  			 * reduce current DMA mapping usage,
>  			 * delay and try again later or
> 


-- 
~Randy

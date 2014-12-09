Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbaLIB30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 20:29:26 -0500
Received: from smtprelay0240.hostedemail.com ([216.40.44.240]:51869 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751103AbaLIB3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 20:29:25 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:966:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:2914:3138:3139:3140:3141:3142:3352:3622:3865:3867:3872:4321:4385:5007:6261:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: jeans73_51c7bb03d0c61
X-Filterd-Recvd-Size: 1861
Message-ID: <1418088558.15957.5.camel@perches.com>
Subject: Re: [PATCH] staging: ion: ion_cma_heap: remove ion_cma_get_sgtable
From: Joe Perches <joe@perches.com>
To: Zeng Tao <prime.zeng@huawei.com>
Cc: gregkh@linuxfoundation.org, john.stultz@linaro.org, ccross@android.com,
        rebecca@android.com, fabio.estevam@freescale.com,
        tranmanphong@gmail.com, benjamin.gaignard@linaro.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 08 Dec 2014 17:29:18 -0800
In-Reply-To: <1418087980-221566-1-git-send-email-prime.zeng@huawei.com>
References: <1418087980-221566-1-git-send-email-prime.zeng@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-09 at 09:19 +0800, Zeng Tao wrote:
> Remove the temporary code ion_cma_get_sgtable,
> use dma_common_get_sgtable instead
[]
> diff --git a/drivers/staging/android/ion/ion_cma_heap.c b/drivers/staging/android/ion/ion_cma_heap.c
[]
> @@ -91,7 +73,7 @@ static int ion_cma_allocate(struct ion_heap *heap, struct ion_buffer *buffer,
>  	if (!info->table)
>  		goto free_mem;
>  
> -	if (ion_cma_get_sgtable
> +	if (dma_common_get_sgtable
>  	    (dev, info->table, info->cpu_addr, info->handle, len))
>  		goto free_table;
>  	/* keep this for memory release */

somewhat unrelated trivia:

It'd conform a bit more to kernel style to
write this with at least one argument on the
same line as the function like:

	if (dma_common_get_sgtable(dev, info->table, info->cpu_addr,
				   info->handle, len))
		goto  free_table;


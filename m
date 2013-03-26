Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204Ab3CZBW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 21:22:29 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60805
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759024Ab3CZBW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 21:22:28 -0400
Date: Mon, 25 Mar 2013 19:22:24 -0600
From: Jens Axboe <axboe@kernel.dk>
To: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com
Subject: Re: [PATCH] block: removes dynamic allocation on stack
Message-ID: <20130326012224.GO19488@kernel.dk>
References: <20130325221046.GB7136@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130325221046.GB7136@oc6784271780.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25 2013, Philip J. Kelleher wrote:
> From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> 
> This patch removes dynamic allocation on the stack error.
> 
> Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> -------------------------------------------------------------------------------
> 
> 
> diff -uprN -X linux-block/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dma.c linux-block/drivers/block/rsxx/dma.c
> --- linux-block-vanilla/drivers/block/rsxx/dma.c	2013-03-25 14:44:40.898978713 -0500
> +++ linux-block/drivers/block/rsxx/dma.c	2013-03-25 14:50:48.054969658 -0500
> @@ -986,7 +986,10 @@ void rsxx_eeh_save_issued_dmas(struct rs
>  	int j;
>  	int cnt;
>  	struct rsxx_dma *dma;
> -	struct list_head issued_dmas[card->n_targets];
> +	struct list_head *issued_dmas;

Ahem - thanks, applied :-)

-- 
Jens Axboe


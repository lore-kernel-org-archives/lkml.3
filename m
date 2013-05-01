Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155Ab3EALnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 07:43:49 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35346
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755730Ab3EALnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 07:43:41 -0400
Date: Wed, 1 May 2013 13:43:26 +0200
From: Jens Axboe <axboe@kernel.dk>
To: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com
Subject: Re: [PATCH 9/9] rsxx: Disallows DMA transfer during format.
Message-ID: <20130501114326.GW7800@kernel.dk>
References: <20130430200158.GB15930@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430200158.GB15930@oc6784271780.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30 2013, Philip J. Kelleher wrote:
> From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> 
> Verifies the card is not formatting before DMAs are
> transferred.
> 
> Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> -------------------------------------------------------------------------------
> 
> 
> diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dma.c linux-block/drivers/block/rsxx/dma.c
> --- linux-block-vanilla/drivers/block/rsxx/dma.c	2013-04-29 16:06:49.997249172 -0500
> +++ linux-block/drivers/block/rsxx/dma.c	2013-04-29 16:10:46.960184429 -0500
> @@ -721,7 +721,8 @@ int rsxx_dma_queue_bio(struct rsxx_cardi
>  		}
>  	}
>  
> -	if (unlikely(card->halt))
> +	if (unlikely(card->halt) ||
> +	    unlikely(card->state == CARD_STATE_FORMATTING))
>  		goto bvec_err;
>  
>  	for (i = 0; i < card->n_targets; i++) {

What happens if card->state is set to formatting right after this check?

-- 
Jens Axboe


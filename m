Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab3EAOOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 10:14:11 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40224 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab3EAOOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 10:14:07 -0400
Date: Wed, 1 May 2013 09:13:53 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com
Subject: Re: [PATCH 9/9] rsxx: Disallows DMA transfer during format.
Message-ID: <20130501141353.GA17546@oc6784271780.ibm.com>
References: <20130430200158.GB15930@oc6784271780.ibm.com>
 <20130501114326.GW7800@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130501114326.GW7800@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050114-5806-0000-0000-000020F499FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the prompt reply.

I was actually questioning myself if I should include this patch in
in my patch series.

This case really is only a solution if no data is running before
a format is issued. It is currently a know bug if data is running 
and a format is issued.

Go ahead and disregard this patch. Once I get sometime to fix
data and format for all cases is when I'll submitted it.


On Wed, May 01, 2013 at 01:43:26PM +0200, Jens Axboe wrote:
> On Tue, Apr 30 2013, Philip J. Kelleher wrote:
> > From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> > 
> > Verifies the card is not formatting before DMAs are
> > transferred.
> > 
> > Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> > -------------------------------------------------------------------------------
> > 
> > 
> > diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dma.c linux-block/drivers/block/rsxx/dma.c
> > --- linux-block-vanilla/drivers/block/rsxx/dma.c	2013-04-29 16:06:49.997249172 -0500
> > +++ linux-block/drivers/block/rsxx/dma.c	2013-04-29 16:10:46.960184429 -0500
> > @@ -721,7 +721,8 @@ int rsxx_dma_queue_bio(struct rsxx_cardi
> >  		}
> >  	}
> >  
> > -	if (unlikely(card->halt))
> > +	if (unlikely(card->halt) ||
> > +	    unlikely(card->state == CARD_STATE_FORMATTING))
> >  		goto bvec_err;
> >  
> >  	for (i = 0; i < card->n_targets; i++) {
> 
> What happens if card->state is set to formatting right after this check?
> 
> -- 
> Jens Axboe
> 


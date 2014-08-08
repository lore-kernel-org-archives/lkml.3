Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbaHHE6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 00:58:41 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:47663 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816AbaHHE6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 00:58:35 -0400
X-IronPort-AV: E=Sophos;i="5.01,822,1400018400"; 
   d="scan'208";a="88672002"
Date: Fri, 8 Aug 2014 06:58:33 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Jeff Moyer <jmoyer@redhat.com>
cc: Joshua Morris <josh.h.morris@us.ibm.com>, kernel-janitors@vger.kernel.org,
        Philip Kelleher <pjk1939@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] block: fix error return code
In-Reply-To: <x49sil89djr.fsf@segfault.boston.devel.redhat.com>
Message-ID: <alpine.DEB.2.02.1408080658040.2045@localhost6.localdomain6>
References: <1407445067-4044-1-git-send-email-Julia.Lawall@lip6.fr> <1407445067-4044-4-git-send-email-Julia.Lawall@lip6.fr> <x49sil89djr.fsf@segfault.boston.devel.redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Aug 2014, Jeff Moyer wrote:

> Julia Lawall <Julia.Lawall@lip6.fr> writes:
> 
> > diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
> > index a8de2ee..fa8077a 100644
> > --- a/drivers/block/rsxx/core.c
> > +++ b/drivers/block/rsxx/core.c
> > @@ -942,6 +942,7 @@ static int rsxx_pci_probe(struct pci_dev *dev,
> >  	card->event_wq = create_singlethread_workqueue(DRIVER_NAME"_event");
> >  	if (!card->event_wq) {
> >  		dev_err(CARD_TO_DEV(card), "Failed card event setup.\n");
> > +		st = -ENOMEM;
> >  		goto failed_event_handler;
> >  	}
> 
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
> 
> BTW, just above this there is questionable code:
> 
>         st = rsxx_get_num_targets(card, &card->n_targets);
>         if (st)
>                 dev_info(CARD_TO_DEV(card),
>                         "Failed reading the number of DMA targets\n");
> 
>         card->ctrl = kzalloc(card->n_targets * sizeof(*card->ctrl), GFP_KERNEL);
>         if (!card->ctrl) {
>                 st = -ENOMEM;
>                 goto failed_dma_setup;
>         }
> 
> From my reading of the kzalloc code, ZERO_SIZE_PTR (which is 16 cast to
> a void *) would be returned from that kzalloc call if the
> rsxx_get_num_targets call failed (since you'd be kzalloc-ing 0 bytes).
> That would lead to the !card->ctrl check not working, right?
> 
> I'd suggest not continuing after rsxx_get_num_targets fails.

Good point.  I'll fix it up.

julia

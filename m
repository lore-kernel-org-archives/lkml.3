Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbaFOXcd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 19:32:33 -0400
Received: from smtprelay0131.hostedemail.com ([216.40.44.131]:56715 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751486AbaFOXcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 19:32:32 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3872:3874:4321:5007:7652:7903:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: grade39_15df320a6f336
X-Filterd-Recvd-Size: 2093
Message-ID: <1402875148.2750.3.camel@joe-AO725>
Subject: Re: [PATCH -next 24/26] usb: Use dma_zalloc_coherent
From: Joe Perches <joe@perches.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, Paul Zimmerman <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Date: Sun, 15 Jun 2014 16:32:28 -0700
In-Reply-To: <Pine.LNX.4.44L0.1406151801421.30784-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1406151801421.30784-100000@netrider.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-06-15 at 18:02 -0400, Alan Stern wrote:
> On Sun, 15 Jun 2014, Joe Perches wrote:
> 
> > Use the zeroing function instead of dma_alloc_coherent & memset(,0,)
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> ...
> 
> > diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
> > index 27f35e8..681fc5e 100644
> > --- a/drivers/usb/host/uhci-hcd.c
> > +++ b/drivers/usb/host/uhci-hcd.c
> > @@ -589,15 +589,14 @@ static int uhci_start(struct usb_hcd *hcd)
> >  	uhci->dentry = dentry;
> >  #endif
> >  
> > -	uhci->frame = dma_alloc_coherent(uhci_dev(uhci),
> > -			UHCI_NUMFRAMES * sizeof(*uhci->frame),
> > -			&uhci->frame_dma_handle, 0);
> > +	uhci->frame = dma_zalloc_coherent(uhci_dev(uhci),
> > +					  UHCI_NUMFRAMES * sizeof(*uhci->frame),
> > +					  &uhci->frame_dma_handle, 0);
> 
> Please don't change the coding style.  This file indents continuation  
> lines by two tab stops; it doesn't align things with opening parens.

Convert it to style of your choice.

Anyway, there are a lot of instances of alignment to parens
in drivers/usb/ than not.

Also, that last argument 0 should be GFP_KERNEL



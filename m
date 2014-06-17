Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaFQAaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 20:30:22 -0400
Received: from smtprelay0082.hostedemail.com ([216.40.44.82]:42135 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750775AbaFQAaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 20:30:20 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2551:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3872:3873:3874:4321:5007:7576:7652:7903:10004:10400:10848:11026:11232:11658:11914:12043:12050:12438:12517:12519:12555:12740:13019:13069:13071:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crack88_2b37d7e3a00b
X-Filterd-Recvd-Size: 2593
Message-ID: <1402965017.11561.3.camel@joe-AO725>
Subject: Re: [PATCH -next 24/26] usb: Use dma_zalloc_coherent
From: Joe Perches <joe@perches.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Date: Mon, 16 Jun 2014 17:30:17 -0700
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844B776A@US01WEMBX2.internal.synopsys.com>
References: <cover.1402863904.git.joe@perches.com>
	 <1816dd87707535b6442e5c75fde9f799821c457a.1402863905.git.joe@perches.com>
	 <A2CA0424C0A6F04399FB9E1CD98E0304844B776A@US01WEMBX2.internal.synopsys.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-16 at 22:00 +0000, Paul Zimmerman wrote:
> > From: Joe Perches [mailto:joe@perches.com]
> > Sent: Sunday, June 15, 2014 1:38 PM
> > 
> > Use the zeroing function instead of dma_alloc_coherent & memset(,0,)
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  drivers/usb/dwc2/hcd_ddma.c | 20 +++++++-------------
> >  drivers/usb/host/uhci-hcd.c |  7 +++----
> >  2 files changed, 10 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/usb/dwc2/hcd_ddma.c b/drivers/usb/dwc2/hcd_ddma.c
> > index 3376177..ab8d7fc 100644
> > --- a/drivers/usb/dwc2/hcd_ddma.c
> > +++ b/drivers/usb/dwc2/hcd_ddma.c
> > @@ -87,17 +87,12 @@ static u16 dwc2_frame_incr_val(struct dwc2_qh *qh)
> >  static int dwc2_desc_list_alloc(struct dwc2_hsotg *hsotg, struct dwc2_qh *qh,
> >  				gfp_t flags)
> >  {
> > -	qh->desc_list = dma_alloc_coherent(hsotg->dev,
> > -				sizeof(struct dwc2_hcd_dma_desc) *
> > -				dwc2_max_desc_num(qh), &qh->desc_list_dma,
> > -				flags);
> > -
> > +	qh->desc_list = dma_zalloc_coherent(hsotg->dev,
> > +					    sizeof(struct dwc2_hcd_dma_desc) * dwc2_max_desc_num(qh),
> > +					    &qh->desc_list_dma, flags);
> 
> This will cause checkpatch to complain about a too-long line, surely?

Hi Paul.

It does and I don't care.

> If you fix that, you can add my acked-by for the dwc2 parts.

If you care that much, I can fix it for you, but I
think it's better as a long line.




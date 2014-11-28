Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbaK1Nak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:30:40 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:57812 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaK1Naj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:30:39 -0500
Date: Fri, 28 Nov 2014 14:30:34 +0100
From: Luis de Bethencourt <luis@debethencourt.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, eunb.song@samsung.com,
        aaro.koskinen@iki.fi, paul.gortmaker@windriver.com
Subject: Re: [PATCH v2] staging: octeon: Fix checkpatch warnings
Message-ID: <20141128133034.GA4635@ks395439.kimsufi.com>
References: <20141127161432.GA32577@ks395439.kimsufi.com>
 <20141128102928.GD4860@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141128102928.GD4860@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 01:29:28PM +0300, Dan Carpenter wrote:
> On Thu, Nov 27, 2014 at 05:18:10PM +0100, Luis de Bethencourt wrote:
> > Fixing 80 character limit warnings in octeon/ethernet-rx.c
> > 
> > Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
> > ---
> >  drivers/staging/octeon/ethernet-rx.c | 51 +++++++++++++++++++++++++-----------
> >  1 file changed, 35 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
> > index 1789a12..e387eb1 100644
> > --- a/drivers/staging/octeon/ethernet-rx.c
> > +++ b/drivers/staging/octeon/ethernet-rx.c
> > @@ -109,6 +109,7 @@ static inline int cvm_oct_check_rcv_error(cvmx_wqe_t *work)
> >  		int interface = cvmx_helper_get_interface_num(work->ipprt);
> >  		int index = cvmx_helper_get_interface_index_num(work->ipprt);
> >  		union cvmx_gmxx_rxx_frm_ctl gmxx_rxx_frm_ctl;
> > +
> 
> Do this in a separate patch.

Will do within the hour.

> 
> > @@ -332,8 +343,10 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
> >  				skb->protocol = eth_type_trans(skb, dev);
> >  				skb->dev = dev;
> >  
> > -				if (unlikely(work->word2.s.not_IP || work->word2.s.IP_exc ||
> > -					work->word2.s.L4_error || !work->word2.s.tcp_or_udp))
> > +				if (unlikely(work->word2.s.not_IP ||
> > +					work->word2.s.IP_exc ||
> > +					work->word2.s.L4_error ||
> > +					!work->word2.s.tcp_or_udp))
> >  					skb->ip_summed = CHECKSUM_NONE;
> 
> Your patch aligns everything with tabs but it should be slightly
> different.  Run your patch through checkpatch.pl --strict to see what I
> mean and then redo it all.  This one should look like:
> 
> 				if (unlikely(work->word2.s.not_IP ||
> 					     work->word2.s.IP_exc ||
> 					     work->word2.s.L4_error ||
> 					     !work->word2.s.tcp_or_udp))
> 					skb->ip_summed = CHECKSUM_NONE;
> 
> [tab][tab][tab][tab][tab][space][space][space][space][space]work->...
> 
> regards,
> dan carpenter
> 
> 

Fixed the aligns and resubmitting the patch as v3.

Thanks for the review!
Luis

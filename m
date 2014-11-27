Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaK0R1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:27:18 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37731 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaK0R1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:27:17 -0500
Date: Thu, 27 Nov 2014 18:27:13 +0100
From: Luis de Bethencourt <luis@debethencourt.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        paul.gortmaker@windriver.com, eunb.song@samsung.com,
        aaro.koskinen@iki.fi, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2] staging: octeon: Fix checkpatch warnings
Message-ID: <20141127172713.GA4096@ks395439.kimsufi.com>
References: <20141127161432.GA32577@ks395439.kimsufi.com>
 <1417106040.1135.1.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417106040.1135.1.camel@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 08:34:00AM -0800, Joe Perches wrote:
> On Thu, 2014-11-27 at 17:18 +0100, Luis de Bethencourt wrote:
> > Fixing 80 character limit warnings in octeon/ethernet-rx.c
> 
> Hello again Luis.
> 
> Another thing you might consider is to  align
> multiple line statements to the appropriate
> open parenthesis.

Sure :) I will do this and merge it into the patch in a few hours.

> 
> > diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
> []
> > @@ -126,13 +127,15 @@ static inline int cvm_oct_check_rcv_error(cvmx_wqe_t *work)
> >  
> >  			if (*ptr == 0xd5) {
> >  				/*
> > -				  printk_ratelimited("Port %d received 0xd5 preamble\n", work->ipprt);
> > +				  printk_ratelimited("Port %d received 0xd5 preamble\n",
> > +					  work->ipprt);
> >  				 */
> 
> This is in a commented out block, but this
> would look better like:
> 
> 		printk_ratelimited("format",
> 				   args...);
> 

I agree. Thanks for the pointer.

> 
> > @@ -212,17 +215,20 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
> >  		did_work_request = 0;
> >  		if (work == NULL) {
> >  			union cvmx_pow_wq_int wq_int;
> > +
> >  			wq_int.u64 = 0;
> >  			wq_int.s.iq_dis = 1 << pow_receive_group;
> >  			wq_int.s.wq_int = 1 << pow_receive_group;
> >  			cvmx_write_csr(CVMX_POW_WQ_INT, wq_int.u64);
> >  			break;
> >  		}
> > -		pskb = (struct sk_buff **)(cvm_oct_get_buffer_ptr(work->packet_ptr) - sizeof(void *));
> > +		pskb = (struct sk_buff **)(cvm_oct_get_buffer_ptr(work->packet_ptr) -
> > +			sizeof(void *));
> 
> cvm_oct_get_buffer_ptr returns a void pointer
> so it doesn't need a cast.
> 
> a possible fix is just to remove the cast
> 
> 		pskb = cvm_oct_get_buffer_ptr(work->packet_ptr) - sizeof(void *);
> 
> >  		prefetch(pskb);
> 
> If the cast type above to a ** is to be believed,
> maybe this should be prefetch(*pskb)
> 
> If you do these, they should be separate patches.
> 

Cool! Once I do the above I will fix this in a separate patch.

Thanks again for your time reviewing Joe,
Luis

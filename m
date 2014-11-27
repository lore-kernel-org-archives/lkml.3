Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaK0QeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:34:07 -0500
Received: from smtprelay0182.hostedemail.com ([216.40.44.182]:49911 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750852AbaK0QeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:34:05 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:3870:3871:3872:3873:4225:4321:5007:6117:6119:6261:7875:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13069:13071:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: farm73_62509aac9c42
X-Filterd-Recvd-Size: 2632
Message-ID: <1417106040.1135.1.camel@perches.com>
Subject: Re: [PATCH v2] staging: octeon: Fix checkpatch warnings
From: Joe Perches <joe@perches.com>
To: Luis de Bethencourt <luis@debethencourt.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        paul.gortmaker@windriver.com, eunb.song@samsung.com,
        aaro.koskinen@iki.fi, devel@driverdev.osuosl.org
Date: Thu, 27 Nov 2014 08:34:00 -0800
In-Reply-To: <20141127161432.GA32577@ks395439.kimsufi.com>
References: <20141127161432.GA32577@ks395439.kimsufi.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-27 at 17:18 +0100, Luis de Bethencourt wrote:
> Fixing 80 character limit warnings in octeon/ethernet-rx.c

Hello again Luis.

Another thing you might consider is to  align
multiple line statements to the appropriate
open parenthesis.

> diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
[]
> @@ -126,13 +127,15 @@ static inline int cvm_oct_check_rcv_error(cvmx_wqe_t *work)
>  
>  			if (*ptr == 0xd5) {
>  				/*
> -				  printk_ratelimited("Port %d received 0xd5 preamble\n", work->ipprt);
> +				  printk_ratelimited("Port %d received 0xd5 preamble\n",
> +					  work->ipprt);
>  				 */

This is in a commented out block, but this
would look better like:

		printk_ratelimited("format",
				   args...);


> @@ -212,17 +215,20 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
>  		did_work_request = 0;
>  		if (work == NULL) {
>  			union cvmx_pow_wq_int wq_int;
> +
>  			wq_int.u64 = 0;
>  			wq_int.s.iq_dis = 1 << pow_receive_group;
>  			wq_int.s.wq_int = 1 << pow_receive_group;
>  			cvmx_write_csr(CVMX_POW_WQ_INT, wq_int.u64);
>  			break;
>  		}
> -		pskb = (struct sk_buff **)(cvm_oct_get_buffer_ptr(work->packet_ptr) - sizeof(void *));
> +		pskb = (struct sk_buff **)(cvm_oct_get_buffer_ptr(work->packet_ptr) -
> +			sizeof(void *));

cvm_oct_get_buffer_ptr returns a void pointer
so it doesn't need a cast.

a possible fix is just to remove the cast

		pskb = cvm_oct_get_buffer_ptr(work->packet_ptr) - sizeof(void *);

>  		prefetch(pskb);

If the cast type above to a ** is to be believed,
maybe this should be prefetch(*pskb)

If you do these, they should be separate patches.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaCWRpQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 13:45:16 -0400
Received: from smtprelay0024.hostedemail.com ([216.40.44.24]:39884 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752357AbaCWRpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 13:45:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:960:966:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2196:2199:2200:2393:2559:2562:2828:2914:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3873:3874:4321:4385:4559:4605:5007:7652:8957:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12679:12740:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: quilt92_6793b932b9d17
X-Filterd-Recvd-Size: 3636
Message-ID: <1395596709.13968.30.camel@joe-AO722>
Subject: Re: [PATCH 1/1] staging: fix bcm/hostmibs.c checkpatch problems
From: Joe Perches <joe@perches.com>
To: Jake Edge <jake@edge2.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jade Bilkey <herself@thefumon.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sun, 23 Mar 2014 10:45:09 -0700
In-Reply-To: <20140322095044.5d4d5ed6@quetzal.lan>
References: <20140322095044.5d4d5ed6@quetzal.lan>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-22 at 09:50 -0600, Jake Edge wrote:
> Fix 4 checkpatch errors, many warnings in bcm/hostmibs.c

Making code checkpatch clean shouldn't be the primary goal here.

Removing uses of Hungarian-style notation, CamelCase naming, and
long variable names would be more helpful overall.

> diff --git a/drivers/staging/bcm/hostmibs.c b/drivers/staging/bcm/hostmibs.c
[]
> @@ -9,27 +9,32 @@
[]
> -INT ProcessGetHostMibs(struct bcm_mini_adapter *Adapter, struct bcm_host_stats_mibs *pstHostMibs)
> +INT ProcessGetHostMibs(struct bcm_mini_adapter *Adapter,
> +		       struct bcm_host_stats_mibs *pstHostMibs)
[]
> -	struct bcm_phs_extension *pDeviceExtension = (struct bcm_phs_extension *) &Adapter->stBCMPhsContext;
> +	struct bcm_phs_extension *pDeviceExtension =
> +			(struct bcm_phs_extension *) &Adapter->stBCMPhsContext;

btw: this cast is  unnecessary.
&Adapter->stBCMPhsContext is a (struct bcm_phs_extension *)
 
> -	UINT nClassifierIndex = 0, nPhsTableIndex = 0, nSfIndex = 0, uiIndex = 0;
> +	UINT nClassifierIndex = 0, nPhsTableIndex = 0,
> +						nSfIndex = 0, uiIndex = 0;

Using one initializer per line is generally better.
 
[]

> 	/* Copy the classifier Table */
> -	for (nClassifierIndex = 0; nClassifierIndex < MAX_CLASSIFIERS; nClassifierIndex++) {
> +	for (nClassifierIndex = 0; nClassifierIndex < MAX_CLASSIFIERS;
> +							nClassifierIndex++) {
>  		if (Adapter->astClassifierTable[nClassifierIndex].bUsed == TRUE)
> -			memcpy((PVOID) &pstHostMibs->
> +			memcpy((PVOID)&pstHostMibs->
>  			       astClassifierTable[nClassifierIndex],
> -			       (PVOID) &Adapter->
> +			       (PVOID)&Adapter->
>  			       astClassifierTable[nClassifierIndex],
>  			       sizeof(struct bcm_mibs_classifier_rule));

You could remove the (PVOID) casts here.
mem<foo> pointers don't need to be cast to void,
the compiler already does that.

> @@ -82,53 +88,70 @@ INT ProcessGetHostMibs(struct bcm_mini_adapter *Adapter, struct bcm_host_stats_m
>  	/* Copy other Host Statistics parameters */
>  	pstHostMibs->stHostInfo.GoodTransmits = Adapter->dev->stats.tx_packets;
>  	pstHostMibs->stHostInfo.GoodReceives = Adapter->dev->stats.rx_packets;
> -	pstHostMibs->stHostInfo.CurrNumFreeDesc = atomic_read(&Adapter->CurrNumFreeTxDesc);
> +	pstHostMibs->stHostInfo.CurrNumFreeDesc =
> +				atomic_read(&Adapter->CurrNumFreeTxDesc);
>  	pstHostMibs->stHostInfo.BEBucketSize = Adapter->BEBucketSize;
>  	pstHostMibs->stHostInfo.rtPSBucketSize = Adapter->rtPSBucketSize;
>  	pstHostMibs->stHostInfo.TimerActive = Adapter->TimerActive;
>  	pstHostMibs->stHostInfo.u32TotalDSD = Adapter->u32TotalDSD;

maybe use a temporary for &pst->stHostInfo and change all
of these to

	host_info-><foo> = Adapter-><bar>;



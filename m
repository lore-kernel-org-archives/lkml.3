Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaJPT2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:28:45 -0400
Received: from smtprelay0091.hostedemail.com ([216.40.44.91]:53378 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751491AbaJPT2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:28:44 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3868:4250:4321:5007:6117:6119:6261:7901:7903:8660:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12517:12519:12740:13069:13148:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pen31_68fc45277e40f
X-Filterd-Recvd-Size: 1714
Message-ID: <1413487720.15773.1.camel@perches.com>
Subject: Re: [PATCH] aic7xxx: replace kmalloc/memset by kzalloc
From: Joe Perches <joe@perches.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: hare@suse.de, JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Date: Thu, 16 Oct 2014 12:28:40 -0700
In-Reply-To: <1413486878-375-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1413486878-375-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-16 at 21:14 +0200, Michael Opdenacker wrote:
> This replaces kmalloc + memset by a call to kzalloc.
[]
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
[]
> @@ -4780,10 +4779,10 @@ ahc_init_scbdata(struct ahc_softc *ahc)
>  	SLIST_INIT(&scb_data->sg_maps);
>  
>  	/* Allocate SCB resources */
> -	scb_data->scbarray = kmalloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC, GFP_ATOMIC);
> +	scb_data->scbarray = kzalloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC,
> +				GFP_ATOMIC);
>  	if (scb_data->scbarray == NULL)
>  		return (ENOMEM);
> -	memset(scb_data->scbarray, 0, sizeof(struct scb) * AHC_SCB_MAX_ALLOC);
>  
>  	/* Determine the number of hardware SCBs and initialize them */
>  

Probably better as kcalloc.


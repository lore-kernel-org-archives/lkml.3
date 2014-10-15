Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaJOMdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 08:33:18 -0400
Received: from smtprelay0160.hostedemail.com ([216.40.44.160]:41601 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751864AbaJOMdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 08:33:17 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:152:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:4250:4321:5007:6261:8603:8957:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357:13894:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: field37_3972eaf3b8758
X-Filterd-Recvd-Size: 1891
Message-ID: <1413376393.7484.1.camel@perches.com>
Subject: Re: [PATCH] bcm/CmHost.c: Fix noisy compile warnings
From: Joe Perches <joe@perches.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        mail@beyermatthias.de, devel@driverdev.osuosl.org
Date: Wed, 15 Oct 2014 05:33:13 -0700
In-Reply-To: <1413375999-10210-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1413375999-10210-1-git-send-email-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-15 at 05:26 -0700, Jeff Kirsher wrote:
> The Beceem WIMAX was generating compile warnings on 64bit machines,
> which were:
> 
> drivers/staging/bcm/CmHost.c: In function ‘StoreCmControlResponseMessage’:
> drivers/staging/bcm/CmHost.c:1503:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>    (struct bcm_connect_mgr_params *) ntohl(
>    ^
[]
> diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c
[]
> @@ -1499,9 +1499,15 @@ ULONG StoreCmControlResponseMessage(struct bcm_mini_adapter *Adapter,
>  	}
>  
>  	/* this can't possibly be right */
> +#ifdef CONFIG_32BIT
>  	pstAddIndication->psfAuthorizedSet =
>  		(struct bcm_connect_mgr_params *) ntohl(
>  				(ULONG)pstAddIndication->psfAuthorizedSet);
> +#else
> +	pstAddIndication->psfAuthorizedSet =
> +		(struct bcm_connect_mgr_params *)(u64)ntohl(
> +				(ULONG)pstAddIndication->psfAuthorizedSet);
> +#endif

no ifdefs necessary

(void *)(unsigned long)



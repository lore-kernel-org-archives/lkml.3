Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbaCRURb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:17:31 -0400
Received: from smtprelay0104.hostedemail.com ([216.40.44.104]:56259 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755351AbaCRURa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:17:30 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3868:3870:3872:4321:5007:7652:7904:10004:10400:10848:11232:11657:11658:11914:12043:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: floor31_7b3755c18304b
X-Filterd-Recvd-Size: 1593
Message-ID: <1395173845.2812.82.camel@joe-AO722>
Subject: Re: [PATCH] staging: unisys: kmalloc/memset to kzalloc conversation
From: Joe Perches <joe@perches.com>
To: Silvio F <silvio.fricke@gmail.com>
Cc: linux-kernel@vger.kernel.org, daeseok.youn@gmail.com, silvio@port1024.net
Date: Tue, 18 Mar 2014 13:17:25 -0700
In-Reply-To: <1395173271-13190-2-git-send-email-silvio.fricke@gmail.com>
References: <4376102.svyTz8ADVT@daeseok-laptop.cloud.net>
	 <1395173271-13190-1-git-send-email-silvio.fricke@gmail.com>
	 <1395173271-13190-2-git-send-email-silvio.fricke@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-18 at 21:07 +0100, Silvio F wrote:
> This patch solves the Coccinelle warning: "kzalloc should be used
> instead of kmalloc/memset"
[]
> diff --git a/drivers/staging/unisys/include/uisutils.h b/drivers/staging/unisys/include/uisutils.h
[]
> @@ -190,10 +190,7 @@ struct chaninfo {
>  }
>  
>  #define ALLOC_CMDRSP(cmdrsp) { \
> -	cmdrsp = kmalloc(SIZEOF_CMDRSP, GFP_ATOMIC); \
> -	if (cmdrsp != NULL) { \
> -		memset(cmdrsp, 0, SIZEOF_CMDRSP); \
> -	} \
> +	cmdrsp = kzalloc(SIZEOF_CMDRSP, GFP_ATOMIC); \
>  }

It'd be nicer to get rid of this macro altogether
and substitute kzalloc in the 3 places it's used.



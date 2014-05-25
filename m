Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbaEYR65 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 13:58:57 -0400
Received: from smtprelay0130.hostedemail.com ([216.40.44.130]:53717 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751071AbaEYR6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 13:58:55 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3872:4321:4384:5007:7652:10004:10400:10848:11026:11232:11658:11914:12517:12519:12740:13019:13069:13149:13230:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: skirt95_6aba7b300d42d
X-Filterd-Recvd-Size: 1890
Message-ID: <1401040732.22191.8.camel@joe-AO725>
Subject: Re: [PATCH] wan: time_before()
From: Joe Perches <joe@perches.com>
To: Manuel =?ISO-8859-1?Q?Sch=F6lling?= <manuel.schoelling@gmx.de>
Cc: kevin.curtis@farsite.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Sun, 25 May 2014 10:58:52 -0700
In-Reply-To: <1401039163-10727-1-git-send-email-manuel.schoelling@gmx.de>
References: <1401039163-10727-1-git-send-email-manuel.schoelling@gmx.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-05-25 at 19:32 +0200, Manuel Schölling wrote:
> To be future-proof and for better readability the time comparisons are
> modified to use time_before() instead of plain, error-prone math.

Sensible change, but it seems these should be
udelay(some_constant) instead of a a rather
variable time wait based on a system/config
defined jiffies.

Kevin?

> diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
[]
> @@ -697,14 +697,14 @@ fst_cpureset(struct fst_card_info *card)
>  		 * We are delaying here to allow the 9054 to reset itself
>  		 */
>  		j = jiffies + 1;
> -		while (jiffies < j)
> +		while (time_before(jiffies, j))
>  			/* Do nothing */ ;
>  		outw(0x240f, card->pci_conf + CNTRL_9054 + 2);
>  		/*
>  		 * We are delaying here to allow the 9054 to reload its eeprom
>  		 */
>  		j = jiffies + 1;
> -		while (jiffies < j)
> +		while (time_before(jiffies, j))
>  			/* Do nothing */ ;
>  		outw(0x040f, card->pci_conf + CNTRL_9054 + 2);
>  




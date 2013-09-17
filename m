Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab3IQQfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 12:35:31 -0400
Received: from smtprelay0053.hostedemail.com ([216.40.44.53]:60503 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752969Ab3IQQfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 12:35:30 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:4321:5007:6117:7652:7903:8957:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crime77_69f73f3465459
X-Filterd-Recvd-Size: 1620
Message-ID: <1379435727.2012.10.camel@joe-AO722>
Subject: Re: [PATCH v2 21/24] Staging: winbond: wb35tx: Replace printk with
 netdev_err
From: Joe Perches <joe@perches.com>
To: Iker Pedrosa <ikerpedrosam@gmail.com>
Cc: pavel@ucw.cz, gregkh@linuxfoundation.org, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 17 Sep 2013 09:35:27 -0700
In-Reply-To: <1379339024-12157-22-git-send-email-ikerpedrosam@gmail.com>
References: <1379339024-12157-1-git-send-email-ikerpedrosam@gmail.com>
	 <1379339024-12157-22-git-send-email-ikerpedrosam@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-16 at 15:43 +0200, Iker Pedrosa wrote:
> The previously used printk lacked the warning level, now we've got a more accurate way to know the error.
[]
> diff --git a/drivers/staging/winbond/wb35tx.c b/drivers/staging/winbond/wb35tx.c
[]
> @@ -32,7 +32,7 @@ static void Wb35Tx_complete(struct urb *pUrb)
>  	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
>  	struct wb35_mds *pMds = &adapter->Mds;
>  
> -	printk("wb35: tx complete\n");
> +	netdev_err(pUrb->dev, "wb35: tx complete\n");

This one should either be removed or changed to netdev_dbg
with the "wb35: " prefix removed.


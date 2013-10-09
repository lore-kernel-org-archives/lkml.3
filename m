Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243Ab3JIEHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 00:07:33 -0400
Received: from smtprelay0246.hostedemail.com ([216.40.44.246]:36363 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750938Ab3JIEHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 00:07:32 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:966:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2196:2198:2199:2200:2393:2559:2562:2731:2828:3138:3139:3140:3141:3142:3350:3622:3865:3866:3867:3868:3870:3873:4321:4385:5007:6119:7652:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wood94_5eae8b3e40856
X-Filterd-Recvd-Size: 1507
Message-ID: <1381291649.2040.1.camel@joe-AO722>
Subject: Re: [PATCH] rtc: pl030: Use devm_kzalloc() instead of kmalloc()
From: Joe Perches <joe@perches.com>
To: Sangjung Woo <sangjung.woo@samsung.com>
Cc: Alessandro Rubini <rubini@gnudd.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Oct 2013 21:07:29 -0700
In-Reply-To: <1381291240-23727-1-git-send-email-sangjung.woo@samsung.com>
References: <1381291240-23727-1-git-send-email-sangjung.woo@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-09 at 13:00 +0900, Sangjung Woo wrote:
> In order to be free automatically and make the cleanup paths more
> simple, use devm_kzalloc() instead of kzalloc().
[]
> diff --git a/drivers/rtc/rtc-pl030.c b/drivers/rtc/rtc-pl030.c
[]
> @@ -106,7 +106,7 @@ static int pl030_probe(struct amba_device *dev, const struct amba_id *id)
>  	if (ret)
>  		goto err_req;
>  
> -	rtc = kmalloc(sizeof(*rtc), GFP_KERNEL);
> +	rtc = devm_kzalloc(&dev->dev, sizeof(*rtc), GFP_KERNEL);

You're not deleting a memset and you're
converting a kmalloc.

Why do you need the zalloc version?


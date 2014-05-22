Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaEVP7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:59:40 -0400
Received: from smtprelay0167.hostedemail.com ([216.40.44.167]:54729 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751809AbaEVP7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:59:39 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:152:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3351:3622:3865:3873:4321:4384:4605:5007:7652:10004:10400:10848:11026:11658:11914:12438:12517:12519:12740:13069:13255:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: verse98_368dd6fbfaf25
X-Filterd-Recvd-Size: 1608
Message-ID: <1400774373.21099.1.camel@joe-AO725>
Subject: Re: [PATCH] mfd: axp20x: Remove unnecessary const qualifier from
 axp20x_supplies[]
From: Joe Perches <joe@perches.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 22 May 2014 08:59:33 -0700
In-Reply-To: <1400750311-15323-2-git-send-email-lee.jones@linaro.org>
References: <1400750311-15323-1-git-send-email-lee.jones@linaro.org>
	 <1400750311-15323-2-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-22 at 10:18 +0100, Lee Jones wrote:
> drivers/mfd/axp20x.c:159:3:
>   warning: initialization discards ‘const’ qualifier from pointer target type
>    .parent_supplies = axp20x_supplies,
[]
> diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
[]
> @@ -140,7 +140,7 @@ static const struct regmap_irq_chip axp20x_regmap_irq_chip = {
>  	.init_ack_masked	= true,
>  };
>  
> -static const char * const axp20x_supplies[] = {
> +static const char * axp20x_supplies[] = {
>  	"acin",
>  	"vin2",
>  	"vin3",

Perhaps you're doing this the wrong way round.
Maybe this definition should change.

include/linux/mfd/core.h:       const char              **parent_supplies;



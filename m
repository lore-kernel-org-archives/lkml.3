Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558AbaDBQ3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 12:29:07 -0400
Received: from smtprelay0160.hostedemail.com ([216.40.44.160]:49687 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932540AbaDBQ3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 12:29:05 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: spade56_148f8562f5743
X-Filterd-Recvd-Size: 1856
Message-ID: <1396456139.32040.9.camel@joe-AO722>
Subject: Re: [PATCH] net: Micrel KSZ8864RMN 4-port managed switch support
From: Joe Perches <joe@perches.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Frederic LAMBERT <frdrc66@gmail.com>, kernel@pengutronix.de
Date: Wed, 02 Apr 2014 09:28:59 -0700
In-Reply-To: <1396453816-32348-1-git-send-email-p.zabel@pengutronix.de>
References: <1396453816-32348-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-02 at 17:50 +0200, Philipp Zabel wrote:
> This patch adds support for the Micrel KSZ8864RMN switch to the spi_ks8995
> driver. The KSZ8864RMN switch has a wider 256-byte register space.

trivia:

> diff --git a/drivers/net/phy/spi_ks8995.c b/drivers/net/phy/spi_ks8995.c
[]
> @@ -317,9 +341,14 @@ static int ks8995_probe(struct spi_device *spi)
>  		goto err_drvdata;
>  	}
>  
> -	dev_info(&spi->dev, "KS89%02X device found, Chip ID:%01x, "
> -			"Revision:%01x\n", ids[0],
> -			get_chip_id(ids[1]), get_chip_rev(ids[1]));
> +	if (get_chip_id(ids[1]) == CHIPID_M) {
> +		dev_info(&spi->dev,
> +			 "KS8995 device found, Chip ID:%01x, Revision:%01x\n",

Using %01x is kind of nonsensical.  %x seems more sensible.

> +			 get_chip_id(ids[1]), get_chip_rev(ids[1]));
> +	} else {
> +		dev_info(&spi->dev, "KSZ8864 device found, Revision:%01x\n",
> +			 get_chip_rev(ids[1]));
> +	}

here too


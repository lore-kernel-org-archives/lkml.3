Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaLDB6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 20:58:33 -0500
Received: from smtprelay0074.hostedemail.com ([216.40.44.74]:60190 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751302AbaLDB6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 20:58:32 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:355:379:541:599:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2901:3138:3139:3140:3141:3142:3352:3622:3867:3871:4250:4321:5007:6261:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:12740:13069:13311:13357:13972:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: able70_2d3614fe35757
X-Filterd-Recvd-Size: 2628
Message-ID: <1417658309.2902.29.camel@perches.com>
Subject: Re: [PATCH 1/1] Staging: ft1000: fix some coding style issues
From: Joe Perches <joe@perches.com>
To: Kevin Pietsch <kevinpietsch@gmail.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Wed, 03 Dec 2014 17:58:29 -0800
In-Reply-To: <1417657773-29027-1-git-send-email-kevinpietsch@gmail.com>
References: <1417657773-29027-1-git-send-email-kevinpietsch@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 20:49 -0500, Kevin Pietsch wrote:
> Removed braces from two single line if-else statements

Another perhaps better option is to use ?: like:
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 0038a3a..8743516 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -172,11 +172,8 @@ u16 ft1000_read_dpram_mag_16(struct net_device *dev, int offset, int Index)
 	spin_lock_irqsave(&info->dpram_lock, flags);
 	ft1000_write_reg(dev, FT1000_REG_DPRAM_ADDR, offset);
 	/* check if we want to read upper or lower 32-bit word */
-	if (Index) {
-		data = ft1000_read_reg(dev, FT1000_REG_MAG_DPDATAL);
-	} else {
-		data = ft1000_read_reg(dev, FT1000_REG_MAG_DPDATAH);
-	}
+	data = ft1000_read_reg(dev, index ? FT1000_REG_MAG_DPDATAL
+					  : FT1000_REG_MAG_DPDATAH);
 	spin_unlock_irqrestore(&info->dpram_lock, flags);
 
 	return data;
@@ -204,11 +201,8 @@ static inline void ft1000_write_dpram_mag_16(struct net_device *dev,
 	/* Provide mutual exclusive access while reading ASIC registers. */
 	spin_lock_irqsave(&info->dpram_lock, flags);
 	ft1000_write_reg(dev, FT1000_REG_DPRAM_ADDR, offset);
-	if (Index) {
-		ft1000_write_reg(dev, FT1000_REG_MAG_DPDATAL, value);
-	} else {
-		ft1000_write_reg(dev, FT1000_REG_MAG_DPDATAH, value);
-	}
+	ft1000_write_reg(dev, index ? FT1000_REG_MAG_DPDATAL
+				    : FT1000_REG_MAG_DPDATAH, value);
 	spin_unlock_irqrestore(&info->dpram_lock, flags);
 }
 



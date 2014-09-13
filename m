Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaIMSdM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 14:33:12 -0400
Received: from smtprelay0202.hostedemail.com ([216.40.44.202]:55578 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752201AbaIMSbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 14:31:48 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1568:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3865:4321:5007:6119:6261:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:12679:13311:13357:13972:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: name41_f6f5665a2646
X-Filterd-Recvd-Size: 1847
From: Joe Perches <joe@perches.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Hartley Sweeten <hsweeten@visionengravers.com>,
        Ryan Mallon <rmallon@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] arm: mach-ep93xx: Convert pr_warning to pr_warn
Date: Sat, 13 Sep 2014 11:31:14 -0700
Message-Id: <eeb86791d228154bba61fb9eca83e24a25376201.1410632835.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1410632834.git.joe@perches.com>
References: <cover.1410632834.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more common pr_warn.

Other miscellanea:

o Coalesce formats

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/mach-ep93xx/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ep93xx/core.c b/arch/arm/mach-ep93xx/core.c
index 0e571f1..c75c678 100644
--- a/arch/arm/mach-ep93xx/core.c
+++ b/arch/arm/mach-ep93xx/core.c
@@ -454,9 +454,9 @@ void __init ep93xx_register_i2c(struct i2c_gpio_platform_data *data,
 	 * CMOS driver.
 	 */
 	if (data->sda_is_open_drain && data->sda_pin != EP93XX_GPIO_LINE_EEDAT)
-		pr_warning("sda != EEDAT, open drain has no effect\n");
+		pr_warn("sda != EEDAT, open drain has no effect\n");
 	if (data->scl_is_open_drain && data->scl_pin != EP93XX_GPIO_LINE_EECLK)
-		pr_warning("scl != EECLK, open drain has no effect\n");
+		pr_warn("scl != EECLK, open drain has no effect\n");
 
 	__raw_writel((data->sda_is_open_drain << 1) |
 		     (data->scl_is_open_drain << 0),
-- 
1.8.1.2.459.gbcd45b4.dirty


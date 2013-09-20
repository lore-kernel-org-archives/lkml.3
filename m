Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab3ITN1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 09:27:00 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:52863 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab3ITN0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 09:26:11 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v2 1/3] omap2: Change clk dev id for rng to omap3-rom-rng
Date: Fri, 20 Sep 2013 15:25:05 +0200
Message-Id: <1379683507-30793-2-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379683507-30793-1-git-send-email-pali.rohar@gmail.com>
References: <1379534757-20870-1-git-send-email-pali.rohar@gmail.com>
 <1379683507-30793-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Name omap_rng is already used by omap_rng driver which is for omap2 and omap4.
For omap3 HS devices there is new driver omap3-rom-rng which needs that clk.
And because there cannot be two drivers with same name, rename omap3 clk dev id.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 arch/arm/mach-omap2/cclock3xxx_data.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/cclock3xxx_data.c b/arch/arm/mach-omap2/cclock3xxx_data.c
index 334b767..5059338 100644
--- a/arch/arm/mach-omap2/cclock3xxx_data.c
+++ b/arch/arm/mach-omap2/cclock3xxx_data.c
@@ -3274,7 +3274,7 @@ static struct omap_clk omap36xx_clks[] = {
  */
 static struct omap_clk omap34xx_omap36xx_clks[] = {
 	CLK(NULL,	"aes1_ick",	&aes1_ick),
-	CLK("omap_rng",	"ick",		&rng_ick),
+	CLK("omap3-rom-rng",	"ick",		&rng_ick),
 	CLK(NULL,	"sha11_ick",	&sha11_ick),
 	CLK(NULL,	"des1_ick",	&des1_ick),
 	CLK(NULL,	"cam_mclk",	&cam_mclk),
-- 
1.7.10.4


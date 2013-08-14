Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab3HNMAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 08:00:14 -0400
Received: from gloria.sntech.de ([95.129.55.99]:58460 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932164Ab3HNMAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 08:00:03 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: kgene.kim@samsung.com
Subject: [PATCH v2 1/4] ARM: S3C24XX: number the dma clocks
Date: Wed, 14 Aug 2013 13:59:54 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        linus.walleij@linaro.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <201308141359.13872.heiko@sntech.de>
In-Reply-To: <201308141359.13872.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308141359.54473.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each dma channel has its own clock. The upcoming dma driver wants to
handle these itself and therefore needs to be able to get the correct
clock for a channel.

Therefore rename the dma clocks to "dma.X" for s3c2412, s3c2416 and
s3c2443. This does not change the behaviour for the old dma driver at
all, as all dma clocks are still always on and not handled by the old
dma driver at all.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
are always enabled in the original code.
---
 arch/arm/mach-s3c24xx/clock-s3c2412.c  |    8 ++++----
 arch/arm/mach-s3c24xx/common-s3c2443.c |   12 ++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-s3c24xx/clock-s3c2412.c b/arch/arm/mach-s3c24xx/clock-s3c2412.c
index 2cc017d..26e2bdc 100644
--- a/arch/arm/mach-s3c24xx/clock-s3c2412.c
+++ b/arch/arm/mach-s3c24xx/clock-s3c2412.c
@@ -484,22 +484,22 @@ static struct clk init_clocks_disable[] = {
 
 static struct clk init_clocks[] = {
 	{
-		.name		= "dma",
+		.name		= "dma.0",
 		.parent		= &clk_h,
 		.enable		= s3c2412_clkcon_enable,
 		.ctrlbit	= S3C2412_CLKCON_DMA0,
 	}, {
-		.name		= "dma",
+		.name		= "dma.1",
 		.parent		= &clk_h,
 		.enable		= s3c2412_clkcon_enable,
 		.ctrlbit	= S3C2412_CLKCON_DMA1,
 	}, {
-		.name		= "dma",
+		.name		= "dma.2",
 		.parent		= &clk_h,
 		.enable		= s3c2412_clkcon_enable,
 		.ctrlbit	= S3C2412_CLKCON_DMA2,
 	}, {
-		.name		= "dma",
+		.name		= "dma.3",
 		.parent		= &clk_h,
 		.enable		= s3c2412_clkcon_enable,
 		.ctrlbit	= S3C2412_CLKCON_DMA3,
diff --git a/arch/arm/mach-s3c24xx/common-s3c2443.c b/arch/arm/mach-s3c24xx/common-s3c2443.c
index f6b9f2e..65d3eef 100644
--- a/arch/arm/mach-s3c24xx/common-s3c2443.c
+++ b/arch/arm/mach-s3c24xx/common-s3c2443.c
@@ -438,32 +438,32 @@ static struct clk init_clocks_off[] = {
 
 static struct clk init_clocks[] = {
 	{
-		.name		= "dma",
+		.name		= "dma.0",
 		.parent		= &clk_h,
 		.enable		= s3c2443_clkcon_enable_h,
 		.ctrlbit	= S3C2443_HCLKCON_DMA0,
 	}, {
-		.name		= "dma",
+		.name		= "dma.1",
 		.parent		= &clk_h,
 		.enable		= s3c2443_clkcon_enable_h,
 		.ctrlbit	= S3C2443_HCLKCON_DMA1,
 	}, {
-		.name		= "dma",
+		.name		= "dma.2",
 		.parent		= &clk_h,
 		.enable		= s3c2443_clkcon_enable_h,
 		.ctrlbit	= S3C2443_HCLKCON_DMA2,
 	}, {
-		.name		= "dma",
+		.name		= "dma.3",
 		.parent		= &clk_h,
 		.enable		= s3c2443_clkcon_enable_h,
 		.ctrlbit	= S3C2443_HCLKCON_DMA3,
 	}, {
-		.name		= "dma",
+		.name		= "dma.4",
 		.parent		= &clk_h,
 		.enable		= s3c2443_clkcon_enable_h,
 		.ctrlbit	= S3C2443_HCLKCON_DMA4,
 	}, {
-		.name		= "dma",
+		.name		= "dma.5",
 		.parent		= &clk_h,
 		.enable		= s3c2443_clkcon_enable_h,
 		.ctrlbit	= S3C2443_HCLKCON_DMA5,
-- 
1.7.10.4


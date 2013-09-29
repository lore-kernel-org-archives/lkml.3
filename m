Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab3I2Tm3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:42:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab3I2T3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Tony Lindgren <tony@atomide.com>
Subject: [ 02/71] ARM: OMAP4: Fix clock_get error for GPMC during boot
Date: Sun, 29 Sep 2013 12:27:14 -0700
Message-Id: <20130929192643.712371821@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

commit 2cfeed314207f808077edb2f1ba41ba1ebbe3e69 upstream.

Looks like we still have the legacy clock alias name for
omap4 GPMC (General Purpose Memory Controller), so let's
fix it for the device tree naming. There's no need to keep
the legacy naming as omap4 is DT only nowadays.

Without this fix we get the following error while booting:

[    0.440399] omap-gpmc 50000000.gpmc: error: clk_get

Reported-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/cclock44xx_data.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/cclock44xx_data.c
+++ b/arch/arm/mach-omap2/cclock44xx_data.c
@@ -1632,7 +1632,7 @@ static struct omap_clk omap44xx_clks[] =
 	CLK(NULL,	"auxclk5_src_ck",		&auxclk5_src_ck),
 	CLK(NULL,	"auxclk5_ck",			&auxclk5_ck),
 	CLK(NULL,	"auxclkreq5_ck",		&auxclkreq5_ck),
-	CLK("omap-gpmc",	"fck",			&dummy_ck),
+	CLK("50000000.gpmc",	"fck",			&dummy_ck),
 	CLK("omap_i2c.1",	"ick",			&dummy_ck),
 	CLK("omap_i2c.2",	"ick",			&dummy_ck),
 	CLK("omap_i2c.3",	"ick",			&dummy_ck),



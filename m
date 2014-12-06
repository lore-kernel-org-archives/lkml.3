Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaLFW7b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 17:59:31 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:38956 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaLFW7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 17:59:30 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@deeprootsystems.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: arm: mach-davinci: cdce949.c:  Remove unused function
Date: Sun,  7 Dec 2014 00:02:08 +0100
Message-Id: <1417906928-5728-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function cdce_set_rate() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/arm/mach-davinci/cdce949.c              |   37 --------------------------
 arch/arm/mach-davinci/include/mach/cdce949.h |    2 --
 2 files changed, 39 deletions(-)

diff --git a/arch/arm/mach-davinci/cdce949.c b/arch/arm/mach-davinci/cdce949.c
index abafb92..bccac4a 100644
--- a/arch/arm/mach-davinci/cdce949.c
+++ b/arch/arm/mach-davinci/cdce949.c
@@ -212,43 +212,6 @@ static struct cdce_output output_list[] = {
 	[5]	= { cdce_y5_freqs, ARRAY_SIZE(cdce_y5_freqs) },
 };
 
-int cdce_set_rate(struct clk *clk, unsigned long rate)
-{
-	int i, ret = 0;
-	struct cdce_freq *freq_table = output_list[clk->lpsc].freq_table;
-	struct cdce_reg  *regs = NULL;
-
-	if (!cdce_i2c_client)
-		return -ENODEV;
-
-	if (!freq_table)
-		return -EINVAL;
-
-	for (i = 0; i < output_list[clk->lpsc].size; i++) {
-		if (freq_table[i].frequency == rate / 1000) {
-			regs = freq_table[i].reglist;
-			break;
-		}
-	}
-
-	if (!regs)
-		return -EINVAL;
-
-	mutex_lock(&cdce_mutex);
-	for (i = 0; regs[i].addr; i++) {
-		ret = i2c_smbus_write_byte_data(cdce_i2c_client,
-					regs[i].addr | 0x80, regs[i].val);
-		if (ret)
-			break;
-	}
-	mutex_unlock(&cdce_mutex);
-
-	if (!ret)
-		clk->rate = rate;
-
-	return ret;
-}
-
 static int cdce_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
diff --git a/arch/arm/mach-davinci/include/mach/cdce949.h b/arch/arm/mach-davinci/include/mach/cdce949.h
index c73331f..2280e0b 100644
--- a/arch/arm/mach-davinci/include/mach/cdce949.h
+++ b/arch/arm/mach-davinci/include/mach/cdce949.h
@@ -14,6 +14,4 @@
 
 #include <mach/clock.h>
 
-int cdce_set_rate(struct clk *clk, unsigned long rate);
-
 #endif
-- 
1.7.10.4


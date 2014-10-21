Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296AbaJUJ0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:26:53 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:42868 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbaJUJWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:22:53 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 03/12] mmc: sdhci-pxav3: Move private driver data to driver source
Date: Tue, 21 Oct 2014 11:22:35 +0200
Message-Id: <1413883364-681-4-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1413883364-681-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1413883364-681-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct sdhci_pxa is only used in sdhci_pxa driver itself, so move it
there.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Chris Ball <chris@printf.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
Cc: linux-mmc@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/mmc/host/sdhci-pxav3.c          | 5 +++++
 include/linux/platform_data/pxa_sdhci.h | 5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
index b55c807982fe..48bc8179c8fc 100644
--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -58,6 +58,11 @@
 #define SDCE_MISC_INT		(1<<2)
 #define SDCE_MISC_INT_EN	(1<<1)
 
+struct sdhci_pxa {
+	u8	clk_enable;
+	u8	power_mode;
+};
+
 /*
  * These registers are relative to the second register region, for the
  * MBus bridge.
diff --git a/include/linux/platform_data/pxa_sdhci.h b/include/linux/platform_data/pxa_sdhci.h
index 27d3156d093a..9e20c2fb4ffd 100644
--- a/include/linux/platform_data/pxa_sdhci.h
+++ b/include/linux/platform_data/pxa_sdhci.h
@@ -55,9 +55,4 @@ struct sdhci_pxa_platdata {
 	unsigned int	quirks2;
 	unsigned int	pm_caps;
 };
-
-struct sdhci_pxa {
-	u8	clk_enable;
-	u8	power_mode;
-};
 #endif /* _PXA_SDHCI_H_ */
-- 
2.1.1


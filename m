Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab3EaWXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:23:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56253 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586Ab3EaWX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:23:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 14/15] clk: tegra: provide tegra_periph_reset_assert alternative
Date: Sat,  1 Jun 2013 00:22:51 +0200
Message-Id: <1370038972-2318779-15-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:tJKJpeb/bVl8ok/1wq+MklOorXp37J3zVgk7j7mRB13
 FATnMpgbmJrE3cB45lFIhTu+Ac+kYBRfn17lhVOk09gXcSptWb
 eHP9NAou9PgSEKbPjUCWXHZ5fQoUaqxqSzmIdVWUhrBJiryZcv
 G5a5i2a2w5QIlpB+ERbmEDivMQgYozWZiSItPeH6jhFsSnTPtI
 G0OJhM0Vj13xzJP61r24MKd3VM8JBSlsBNjMDwPaNG8pzXdK0P
 eg/daSMhMpL3IfY5kHj5X1QgMK3bBttU4XxcEwgJYZ+37z7Pcc
 yDfM6nxXcIKoIZl+IgAoT87qX72137CNgZM8XpWmNqQm8F+21v
 NFg5G8VbE8GZIkdZQ6R3rF8XO2x0MlX2i7o7IyqoS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have some tegra device drivers that are written to be platform
independent but still use the tegra specific tegra_periph_reset_assert
function. In order to build and link them without errors,
this provides a static inline version of these functions that
does nothing when Tegra support is disabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/clk/tegra.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/clk/tegra.h b/include/linux/clk/tegra.h
index 642789b..1397190 100644
--- a/include/linux/clk/tegra.h
+++ b/include/linux/clk/tegra.h
@@ -120,8 +120,13 @@ static inline void tegra_cpu_clock_resume(void)
 }
 #endif
 
+#ifdef ARCH_TEGRA
 void tegra_periph_reset_deassert(struct clk *c);
 void tegra_periph_reset_assert(struct clk *c);
+#else
+static inline void tegra_periph_reset_deassert(struct clk *c) {}
+static inline void tegra_periph_reset_assert(struct clk *c) {}
+#endif
 void tegra_clocks_init(void);
 void tegra_clocks_apply_init_table(void);
 
-- 
1.8.1.2


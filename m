Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbaC0AIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 20:08:30 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50039 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639AbaC0AG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 20:06:56 -0400
From: Felipe Balbi <balbi@ti.com>
To: Balaji T K <balajitk@ti.com>
CC: <chris@printf.net>, <ulf.hansson@linaro.org>, <linux-mmc@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3/5] mmc: host: omap_hsmmc: introduce new accessor functions
Date: Wed, 26 Mar 2014 19:04:48 -0500
Message-ID: <1395878690-9650-4-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.1.286.g5172cb3
In-Reply-To: <1395878690-9650-1-git-send-email-balbi@ti.com>
References: <1395878690-9650-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we introduce new accessors which provide for register
access with and without offsets.

This is just to make sure newer versions of the IP
can access the new registers prepended at the beginning
of the address space.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mmc/host/omap_hsmmc.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index d46f768..e596c6a 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -211,6 +211,42 @@ struct omap_hsmmc_host {
 	struct	omap_mmc_platform_data	*pdata;
 };
 
+static inline int _omap_hsmmc_read(struct omap_hsmmc_host *host,
+		u32 reg, bool offset)
+{
+	return readl(host->base + reg + (offset ? host->reg_offset : 0));
+}
+
+static inline void _omap_hsmmc_write(struct omap_hsmmc_host *host,
+		u32 reg, u32 val, bool offset)
+{
+	writel(val, host->base + reg + (offset ? host->reg_offset : 0));
+}
+
+static inline int omap_hsmmc_read_offset(struct omap_hsmmc_host *host,
+		u32 reg)
+{
+	return _omap_hsmmc_read(host, reg, true);
+}
+
+static inline void omap_hsmmc_write_offset(struct omap_hsmmc_host *host,
+		u32 reg, u32 val)
+{
+	_omap_hsmmc_write(host, reg, val, true);
+}
+
+static inline int omap_hsmmc_read_no_offset(struct omap_hsmmc_host *host,
+		u32 reg)
+{
+	return _omap_hsmmc_read(host, reg, false);
+}
+
+static inline void omap_hsmmc_write_no_offset(struct omap_hsmmc_host *host,
+		u32 reg, u32 val)
+{
+	_omap_hsmmc_write(host, reg, val, false);
+}
+
 struct omap_mmc_of_data {
 	u32 reg_offset;
 	u8 controller_flags;
-- 
1.9.1.286.g5172cb3


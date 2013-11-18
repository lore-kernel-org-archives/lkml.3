Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab3KRKcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 05:32:10 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:62143 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3KRKbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 05:31:18 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] mfd: cros ec: spi: Fix debug output
Date: Mon, 18 Nov 2013 11:30:49 +0100
Message-Id: <1384770649-8593-3-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1384770649-8593-1-git-send-email-treding@nvidia.com>
References: <1384770649-8593-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_cont() symbol doesn't exist, so replace it with pr_cont(). While
at it, also append a newline to the debug output to make it look nicer.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/mfd/cros_ec_spi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
index af5c2f6601cf..e3690fcb86ae 100644
--- a/drivers/mfd/cros_ec_spi.c
+++ b/drivers/mfd/cros_ec_spi.c
@@ -80,7 +80,9 @@ static void debug_packet(struct device *dev, const char *name, u8 *ptr,
 
 	dev_dbg(dev, "%s: ", name);
 	for (i = 0; i < len; i++)
-		dev_cont(dev, " %02x", ptr[i]);
+		pr_cont(" %02x", ptr[i]);
+
+	pr_cont("\n");
 #endif
 }
 
-- 
1.8.4.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab3IZSw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:52:29 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:38085 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab3IZSvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:51:41 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 20/21] of: only include prom.h on sparc
Date: Thu, 26 Sep 2013 13:50:55 -0500
Message-Id: <1380221456-11192-21-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

The dependency on prom.h by the core DT code is now removed and only
sparc needs to include prom.h for the core code.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@linaro.org>
---
 include/linux/of.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/of.h b/include/linux/of.h
index 4d294a0..54017b8 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -136,7 +136,9 @@ static inline unsigned long of_read_ulong(const __be32 *cell, int size)
 	return of_read_number(cell, size);
 }
 
+#if defined(CONFIG_SPARC)
 #include <asm/prom.h>
+#endif
 
 /* Default #address and #size cells.  Allow arch asm/prom.h to override */
 #if !defined(OF_ROOT_NODE_ADDR_CELLS_DEFAULT)
-- 
1.8.1.2


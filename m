Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbaIDJcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 05:32:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:60135 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601AbaIDJcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 05:32:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,464,1406617200"; 
   d="scan'208";a="586127862"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] mfd: pcf50633: use sprintf directly
Date: Thu,  4 Sep 2014 12:32:12 +0300
Message-Id: <1409823132-12705-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dump a content of the registers let's use snprintf() directly with %*ph
specifier.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/mfd/pcf50633-core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index c87f7a0..8401552 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -106,10 +106,7 @@ static ssize_t show_dump_regs(struct device *dev, struct device_attribute *attr,
 			} else
 				dump[n1] = pcf50633_reg_read(pcf, n + n1);
 
-		hex_dump_to_buffer(dump, sizeof(dump), 16, 1, buf1, 128, 0);
-		buf1 += strlen(buf1);
-		*buf1++ = '\n';
-		*buf1 = '\0';
+		buf1 += sprintf(buf1, "%*ph\n", (int)sizeof(dump), dump);
 	}
 
 	return buf1 - buf;
-- 
2.1.0


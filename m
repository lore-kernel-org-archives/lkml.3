Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbbASRoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 12:44:17 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:49668 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbbASRoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 12:44:16 -0500
Message-ID: <1421689454.9655.58.camel@x220>
Subject: [PATCH] coresight-etm: remove check for unknown Kconfig macro
From: Paul Bolle <pebolle@tiscali.nl>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2015 18:44:14 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jan 2015 17:44:14.0429 (UTC) FILETIME=[8A5DA0D0:01D0340F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CoreSight ETM/PTM driver contains a check for a
CONFIG_CORESIGHT_SOURCE_ETM_DEFAULT_ENABLE macro. But there's no related
Kconfig symbol CORESIGHT_SOURCE_ETM_DEFAULT_ENABLE. Remove that check
and the single line of code it hides.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Cross-compile tested only (on top of next-20150119).

 drivers/coresight/coresight-etm3x.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/coresight/coresight-etm3x.c b/drivers/coresight/coresight-etm3x.c
index 73c36696f1b6..f312dc4dd95c 100644
--- a/drivers/coresight/coresight-etm3x.c
+++ b/drivers/coresight/coresight-etm3x.c
@@ -34,11 +34,7 @@
 
 #include "coresight-etm.h"
 
-#ifdef CONFIG_CORESIGHT_SOURCE_ETM_DEFAULT_ENABLE
-static int boot_enable = 1;
-#else
 static int boot_enable;
-#endif
 module_param_named(
 	boot_enable, boot_enable, int, S_IRUGO
 );
-- 
1.9.3


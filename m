Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbbARCFQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 21:05:16 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:33313 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbbARCE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 21:04:57 -0500
From: mathieu.poirier@linaro.org
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org
Subject: [PATCH 2/4] staging: vt6655: removing dead function as reported by sparse
Date: Sat, 17 Jan 2015 19:04:24 -0700
Message-Id: <1421546666-21461-3-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421546666-21461-1-git-send-email-mathieu.poirier@linaro.org>
References: <1421546666-21461-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

mpoirier@t430:~/work/kernel1$ make C=1 M=drivers/staging/vt6655/
  CHECK   drivers/staging/vt6655/mac.c
drivers/staging/vt6655/mac.c:162:6: warning: symbol 'MACvGetShortRetryLimit' was not declared. Should it be static?
  CC [M]  drivers/staging/vt6655/mac.o

Commit:
87299d4c06f0 staging: vt6655: mac.c and mac.h remove dead functions.

removes a lot of "dead" functions but forgot @MACvGetShortRetryLimit.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/staging/vt6655/mac.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index 8f0d652fea7c..7402a2b272b0 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -148,25 +148,6 @@ void MACvSetShortRetryLimit(void __iomem *dwIoBase, unsigned char byRetryLimit)
 
 /*
  * Description:
- *      Get 802.11 Short Retry Limit
- *
- * Parameters:
- *  In:
- *      dwIoBase        - Base Address for MAC
- *  Out:
- *      pbyRetryLimit   - Retry Limit Get
- *
- * Return Value: none
- *
- */
-void MACvGetShortRetryLimit(void __iomem *dwIoBase, unsigned char *pbyRetryLimit)
-{
-	// get SRT
-	VNSvInPortB(dwIoBase + MAC_REG_SRT, pbyRetryLimit);
-}
-
-/*
- * Description:
  *      Set 802.11 Long Retry Limit
  *
  * Parameters:
-- 
1.9.1


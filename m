Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab3APOu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:50:29 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:49942 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257Ab3APOuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:50:25 -0500
From: sjur.brandeland@stericsson.com
To: Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: mporter@ti.com, =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Suman Anna <s-anna@ti.com>, Mark Grosen <mgrosen@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFCv3 03/11] remoteproc: Move check on firmware name to rproc_add
Date: Wed, 16 Jan 2013 15:43:42 +0100
Message-Id: <1358347430-9243-4-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358347430-9243-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1358347430-9243-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Verify that firmware name is defined in rproc_add.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index d21f8797..9caf533 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -980,13 +980,6 @@ int rproc_boot(struct rproc *rproc)
 		return ret;
 	}
 
-	/* loading a firmware is required */
-	if (!rproc->firmware) {
-		dev_err(dev, "%s: no firmware to load\n", __func__);
-		ret = -EINVAL;
-		goto unlock_mutex;
-	}
-
 	/* prevent underlying implementation from being removed */
 	if (!try_module_get(dev->parent->driver->owner)) {
 		dev_err(dev, "%s: can't get owner\n", __func__);
@@ -1122,6 +1115,12 @@ int rproc_add(struct rproc *rproc)
 	struct device *dev = &rproc->dev;
 	int ret;
 
+	/* loading a firmware is required */
+	if (!rproc->firmware) {
+		dev_err(dev, "%s: no firmware to load\n", __func__);
+		return -EINVAL;
+	}
+
 	ret = device_add(dev);
 	if (ret < 0)
 		return ret;
-- 
1.7.5.4


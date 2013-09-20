Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab3ITU21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:28:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41510 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab3ITUND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:13:03 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexander Shiyan <shc_work@mail.ru>, Kamil Debski <k.debski@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 62/93] [media] media: coda: Fix DT driver data pointer for i.MX27
Date: Fri, 20 Sep 2013 13:08:57 -0700
Message-Id: <1379707768-1804-63-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shiyan <shc_work@mail.ru>

commit 7b0dd9e60e714951b5400dd0740b3c4c3c3cb76f upstream.

The data pointer should point to DT data, and not to the ID
array.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/platform/coda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 4a980e0..02d4970 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1884,7 +1884,7 @@ MODULE_DEVICE_TABLE(platform, coda_platform_ids);
 
 #ifdef CONFIG_OF
 static const struct of_device_id coda_dt_ids[] = {
-	{ .compatible = "fsl,imx27-vpu", .data = &coda_platform_ids[CODA_IMX27] },
+	{ .compatible = "fsl,imx27-vpu", .data = &coda_devdata[CODA_IMX27] },
 	{ .compatible = "fsl,imx53-vpu", .data = &coda_devdata[CODA_IMX53] },
 	{ /* sentinel */ }
 };
-- 
1.8.1.2


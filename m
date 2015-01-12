Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbbALS4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:56:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58148 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbbALSaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrei Warkentin <andrey.warkentin@gmail.com>,
        Baruch Siach <baruch@tkos.co.il>, Ulf Hansson <ulf.hansson@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 148/216] mmc: block: add newline to sysfs display of force_ro
Date: Mon, 12 Jan 2015 18:28:46 +0000
Message-Id: <1421087394-2712-36-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baruch Siach <baruch@tkos.co.il>

commit 0031a98a85e9fca282624bfc887f9531b2768396 upstream.

Make force_ro consistent with other sysfs entries.

Fixes: 371a689f64b0d ('mmc: MMC boot partitions support')
Cc: Andrei Warkentin <andrey.warkentin@gmail.com>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mmc/card/block.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 452782bffebc..b082b25ea9c4 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -260,7 +260,7 @@ static ssize_t force_ro_show(struct device *dev, struct device_attribute *attr,
 	int ret;
 	struct mmc_blk_data *md = mmc_blk_get(dev_to_disk(dev));
 
-	ret = snprintf(buf, PAGE_SIZE, "%d",
+	ret = snprintf(buf, PAGE_SIZE, "%d\n",
 		       get_disk_ro(dev_to_disk(dev)) ^
 		       md->read_only);
 	mmc_blk_put(md);
-- 
2.1.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718AbbAIKi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:38:27 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44585 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757494AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Andrei Warkentin <andrey.warkentin@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 41/78] mmc: block: add newline to sysfs display of force_ro
Date: Fri,  9 Jan 2015 11:31:50 +0100
Message-Id: <50bd4857c6a000f0da4bc4b144baf111910f6a46.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 0031a98a85e9fca282624bfc887f9531b2768396 upstream.

Make force_ro consistent with other sysfs entries.

Fixes: 371a689f64b0d ('mmc: MMC boot partitions support')
Cc: Andrei Warkentin <andrey.warkentin@gmail.com>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mmc/card/block.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 4e8212c714b1..2aea365e096e 100644
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
2.2.1


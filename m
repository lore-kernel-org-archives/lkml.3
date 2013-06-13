Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759062Ab3FMS3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:29:04 -0400
Received: from etezian.org ([198.101.225.253]:56448 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758780Ab3FMS26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:28:58 -0400
From: Andi Shyti <andi@etezian.org>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, pc@asdf.org, oatilla@gmail.com,
        andi@etezian.org
Subject: [PATCH 08/19] bh1770glc: logic change in the proximity read
Date: Thu, 13 Jun 2013 20:20:42 +0200
Message-Id: <305e71436fd8c7875396c79154b2e6512bb18860.1371145891.git.andi@etezian.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the prox0_raw file in the sysfs interface reads the proximity
value directly from the register instead of reporting the last
read value; in this way userspace applications can have a real
time value

Signed-off-by: Andi Shyti <andi@etezian.org>
---
 drivers/misc/bh1770glc.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index ac6d0c8..031a9fa 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -786,6 +786,11 @@ static ssize_t bh1770_prox_result_show(struct device *dev,
 	ssize_t ret;
 
 	mutex_lock(&chip->mutex);
+	/*
+	 * if this function fails the prox_data will store
+	 * the value from the previous read
+	 */
+	bh1770_ps_get_result(chip);
 	if (chip->prox_enable_count && !pm_runtime_suspended(dev))
 		ret = sprintf(buf, "%d\n", chip->prox_data);
 	else
-- 
1.7.10.4


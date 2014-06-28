Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaF1L7k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 07:59:40 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:55716 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752647AbaF1L7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 07:59:39 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkcHABqtrlNbsk2v/2dsb2JhbABZgw2regUBAQEBAQEFAW0BkUKHQIEHF3WECwIkLyNWMxE3iEYBxRkXhWSJIR2ELQWXc4Jqiz+IPIIAgUQ7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/1] drivers/mfd/ab8500-debugfs.c: remove unnecessary null test before debugfs_remove_recursive
Date: Sat, 28 Jun 2014 13:58:17 +0200
Message-Id: <1403956697-3197-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: debugfs_remove_recursive(NULL) is safe this check is probably not required

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/mfd/ab8500-debugfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index d1a22aa..7ca8713 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -3192,8 +3192,7 @@ static int ab8500_debug_probe(struct platform_device *plf)
 	return 0;
 
 err:
-	if (ab8500_dir)
-		debugfs_remove_recursive(ab8500_dir);
+	debugfs_remove_recursive(ab8500_dir);
 	dev_err(&plf->dev, "failed to create debugfs entries.\n");
 
 	return -ENOMEM;
-- 
1.8.4.5


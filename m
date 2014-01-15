Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbaAOWkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:40:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40723 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbaAOVxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:53:25 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 013/166] [media] saa7164: fix return value check in saa7164_initdev()
Date: Wed, 15 Jan 2014 13:50:27 -0800
Message-Id: <1389822780-4729-14-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 89f4d45b2752df5d222b5f63919ce59e2d8afaf4 upstream.

In case of error, the function kthread_run() returns ERR_PTR()
and never returns NULL. The NULL test in the return value check
should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/pci/saa7164/saa7164-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index 63502e7..bb394e0 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -1348,9 +1348,11 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
 		if (fw_debug) {
 			dev->kthread = kthread_run(saa7164_thread_function, dev,
 				"saa7164 debug");
-			if (!dev->kthread)
+			if (IS_ERR(dev->kthread)) {
+				dev->kthread = NULL;
 				printk(KERN_ERR "%s() Failed to create "
 					"debug kernel thread\n", __func__);
+			}
 		}
 
 	} /* != BOARD_UNKNOWN */
-- 
1.8.3.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab3JJSaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:30:05 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36028 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab3JJSaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:30:00 -0400
From: Matias Bjorling <m@bjorling.me>
To: willy@linux.intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        Matias Bjorling <m@bjorling.me>
Subject: [PATCH 2/2] NVMe: Extract admin queue size
Date: Thu, 10 Oct 2013 20:29:47 +0200
Message-Id: <1381429787-4146-3-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381429787-4146-1-git-send-email-m@bjorling.me>
References: <1381429787-4146-1-git-send-email-m@bjorling.me>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The queue size of the admin queue should be defined as a constant for use in
multiple places.

Signed-off-by: Matias Bjorling <m@bjorling.me>
---
 drivers/block/nvme-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 1e940e8..d4f01d4 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -44,6 +44,7 @@
 #include <asm-generic/io-64-nonatomic-lo-hi.h>
 
 #define NVME_Q_DEPTH 1024
+#define NVME_ADMIN_Q_DEPTH 64
 #define SQ_SIZE(depth)		(depth * sizeof(struct nvme_command))
 #define CQ_SIZE(depth)		(depth * sizeof(struct nvme_completion))
 #define NVME_MINORS 64
@@ -1261,7 +1262,7 @@ static int nvme_configure_admin_queue(struct nvme_dev *dev)
 
 	nvmeq = dev->queues[0];
 	if (!nvmeq) {
-		nvmeq = nvme_alloc_queue(dev, 0, 64, 0);
+		nvmeq = nvme_alloc_queue(dev, 0, NVME_ADMIN_Q_DEPTH, 0);
 		if (!nvmeq)
 			return -ENOMEM;
 		dev->queues[0] = nvmeq;
-- 
1.8.1.2


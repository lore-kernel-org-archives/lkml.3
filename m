Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaJZJja (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 05:39:30 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:49757 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaJZJj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 05:39:29 -0400
Message-ID: <1414316366.4290.4.camel@phoenix>
Subject: [PATCH 3/3] soc: ti: knav_qmss_queue: Return proper error if
 devm_kzalloc fails
From: Axel Lin <axel.lin@ingics.com>
To: Santosh Shilimkar <ssantosh@kernel.org>
Cc: Sandeep Nair <sandeep_n@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Date: Sun, 26 Oct 2014 17:39:26 +0800
In-Reply-To: <1414316264.4290.2.camel@phoenix>
References: <1414316264.4290.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -ENOMEM if devm_kzalloc fails.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/soc/ti/knav_qmss_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/ti/knav_qmss_queue.c b/drivers/soc/ti/knav_qmss_queue.c
index d66aaf2..6f22d56 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -1640,7 +1640,7 @@ static int knav_queue_init_queues(struct knav_device *kdev)
 	size = (1 << kdev->inst_shift) * kdev->num_queues_in_use;
 	kdev->instances = devm_kzalloc(kdev->dev, size, GFP_KERNEL);
 	if (!kdev->instances)
-		return -1;
+		return -ENOMEM;
 
 	for_each_queue_range(kdev, range) {
 		if (range->ops && range->ops->init_range)
-- 
1.9.1




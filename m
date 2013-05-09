Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab3EIFBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 01:01:11 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:50206 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab3EIFA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 01:00:57 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <stern@rowland.harvard.edu>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <lizefan@huawei.com>,
        Libo Chen <chenlibo.3@gmail.com>, Libo Chen <libo.chen@huawei.com>
Subject: [PATCH 2/4] usb: isp1760-if: fix memleak when platform_get_resource fail
Date: Thu, 9 May 2013 12:58:09 +0800
Message-ID: <1368075491-38728-3-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1368075491-38728-1-git-send-email-libo.chen@huawei.com>
References: <1368075491-38728-1-git-send-email-libo.chen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Libo Chen <chenlibo.3@gmail.com>

When platform_get_resource fail, we should release_mem_region

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/usb/host/isp1760-if.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/isp1760-if.c b/drivers/usb/host/isp1760-if.c
index bbb791b..a13709e 100644
--- a/drivers/usb/host/isp1760-if.c
+++ b/drivers/usb/host/isp1760-if.c
@@ -373,8 +373,10 @@ static int isp1760_plat_probe(struct platform_device *pdev)
 	irq_res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!irq_res) {
 		pr_warning("isp1760: IRQ resource not available\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto cleanup;
 	}
+
 	irqflags |= irq_res->flags & IRQF_TRIGGER_MASK;
 
 	if (priv) {
-- 
1.7.1



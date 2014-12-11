Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933849AbaLKLG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 06:06:29 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:36327 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480AbaLKLG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 06:06:28 -0500
From: Wang Long <long.wanglong@huawei.com>
To: <tglx@linutronix.de>, <jason@lakedaemon.net>, <haojian.zhuang@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <peifeiyue@huawei.com>,
        <huxinwei@huawei.com>
Subject: [PATCH] irq: irq-hip04: initialize hip04_cpu_map to 0xffff
Date: Thu, 11 Dec 2014 11:03:36 +0000
Message-ID: <1418295816-179583-1-git-send-email-long.wanglong@huawei.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.200]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HiP04 GIC extends to support 16 cores, so we should
initialize the hip04_cpu_map to 0xffff.

Signed-off-by: Wang Long <long.wanglong@huawei.com>
---
 drivers/irqchip/irq-hip04.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-hip04.c b/drivers/irqchip/irq-hip04.c
index 9c8f8335..8eee46b 100644
--- a/drivers/irqchip/irq-hip04.c
+++ b/drivers/irqchip/irq-hip04.c
@@ -382,7 +382,7 @@ hip04_of_init(struct device_node *node, struct device_node *parent)
 	 * It will be refined as each CPU probes its ID.
 	 */
 	for (i = 0; i < NR_HIP04_CPU_IF; i++)
-		hip04_cpu_map[i] = 0xff;
+		hip04_cpu_map[i] = 0xffff;
 
 	/*
 	 * Find out how many interrupts are supported.
-- 
1.8.3.4


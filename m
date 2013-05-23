Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409Ab3EWLRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 07:17:10 -0400
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:39591 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757940Ab3EWLRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 07:17:08 -0400
From: <yizhang.mrvl@gmail.com>
To: <sameo@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <yizhang.mrvl@gmail.com>
CC: <cxie4@marvell.com>, <arnd@arndb.de>, <yizhang@marvell.com>,
        <linux-kernel@vger.kernel.org>, <jtzhou@marvell.com>
Subject: [PATCH 2/4] mfd: 88pm800: remove "IRQF_TRIGGER_FALLING" flag
Date: Thu, 23 May 2013 19:10:45 +0800
Message-ID: <1369307447-17874-3-git-send-email-yizhang.mrvl@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1369307447-17874-1-git-send-email-yizhang.mrvl@gmail.com>
References: <1369307447-17874-1-git-send-email-yizhang.mrvl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Zhang <yizhang@marvell.com>

for interrupt controller such as GIC who is level triggered,
"IRQF_TRIGGER_FALLING" will fail to request irq

Signed-off-by: Yi Zhang <yizhang@marvell.com>
---
 drivers/mfd/88pm800.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index bbb6aa8..618a6b9 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -318,7 +318,7 @@ out:
 static int device_irq_init_800(struct pm80x_chip *chip)
 {
 	struct regmap *map = chip->regmap;
-	unsigned long flags = IRQF_TRIGGER_FALLING | IRQF_ONESHOT;
+	unsigned long flags = IRQF_ONESHOT;
 	int data, mask, ret = -EINVAL;
 
 	if (!map || !chip->irq) {
-- 
1.7.0.4


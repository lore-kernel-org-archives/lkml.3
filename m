Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab3EVMJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 08:09:45 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:53210 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755392Ab3EVMJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 08:09:44 -0400
From: <yizhang.mrvl@gmail.com>
To: <sameo@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <yizhang.mrvl@gmail.com>
CC: <cxie4@marvell.com>, <arnd@arndb.de>, <yizhang@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] mfd: 88pm800: remove "IRQF_TRIGGER_FALLING" flag
Date: Wed, 22 May 2013 20:07:07 +0800
Message-ID: <1369224429-27077-3-git-send-email-yizhang.mrvl@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1369224429-27077-1-git-send-email-yizhang.mrvl@gmail.com>
References: <1369224429-27077-1-git-send-email-yizhang.mrvl@gmail.com>
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


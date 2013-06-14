Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab3FNFXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 01:23:32 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:46791 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379Ab3FNFXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 01:23:30 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <yizhang@marvell.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH V2 3/9] mfd: 88pm800: fix for mask_invert
Date: Fri, 14 Jun 2013 01:21:47 -0400
Message-ID: <1371187313-5776-4-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371187313-5776-1-git-send-email-chao.xie@marvell.com>
References: <1371187313-5776-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mask_invert must be set. Or interrupt cannot be cleared.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/mfd/88pm800.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index 0801049..cca63f2 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -362,6 +362,7 @@ static struct regmap_irq_chip pm800_irq_chip = {
 	.status_base = PM800_INT_STATUS1,
 	.mask_base = PM800_INT_ENA_1,
 	.ack_base = PM800_INT_STATUS1,
+	.mask_invert = 1,
 };
 
 static int pm800_pages_init(struct pm80x_chip *chip)
-- 
1.7.4.1


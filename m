Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab3IZNLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:11:24 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11513 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237Ab3IZNLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:11:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 26 Sep 2013 06:11:22 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 3/4] mfd: palmas: reset pm_power_off if it is set for the device
Date: Thu, 26 Sep 2013 19:03:50 +0530
Message-ID: <1380202431-4868-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1380202431-4868-1-git-send-email-ldewangan@nvidia.com>
References: <1380202431-4868-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If Palams supports the system power controller and pm_power_off
is implemented through the Palmas driver then reset the pm_power_off
in driver remove.

This will avoid the call of Palmas driver after removal of driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/palmas.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 3b63139..6aab016 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -570,6 +570,11 @@ static int palmas_i2c_remove(struct i2c_client *i2c)
 
 	regmap_del_irq_chip(palmas->irq, palmas->irq_data);
 
+	if (palmas == palmas_dev) {
+		pm_power_off = NULL;
+		palmas_dev = NULL;
+	}
+
 	return 0;
 }
 
-- 
1.7.1.1


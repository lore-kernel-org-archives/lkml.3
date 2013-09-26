Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab3IZNLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:11:19 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15239 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676Ab3IZNLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:11:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 26 Sep 2013 06:07:36 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/4] mfd: palmas: remove call of mfd_remove_devices
Date: Thu, 26 Sep 2013 19:03:48 +0530
Message-ID: <1380202431-4868-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1380202431-4868-1-git-send-email-ldewangan@nvidia.com>
References: <1380202431-4868-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver only support the device tree and sub modules are populated
through platform, the registration of sub devices through mfd_add_devices
has been removed.

Hence in remove path of the driver, it is not require to call
mfd_remove_devices.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/palmas.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 135afab..9607d24 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -567,7 +567,6 @@ static int palmas_i2c_remove(struct i2c_client *i2c)
 {
 	struct palmas *palmas = i2c_get_clientdata(i2c);
 
-	mfd_remove_devices(palmas->dev);
 	regmap_del_irq_chip(palmas->irq, palmas->irq_data);
 
 	return 0;
-- 
1.7.1.1


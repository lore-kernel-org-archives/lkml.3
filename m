Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab3B1Hio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 02:38:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:49067 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab3B1Hin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 02:38:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,754,1355126400"; 
   d="scan'208";a="291674999"
Subject: [PATCH 1/5] regmap: irq: call pm_runtime_put in
 pm_runtime_get_sync failed case
From: Li Fei <fei.li@intel.com>
To: broonie@opensource.wolfsonmicro.com, gregkh@linuxfoundation.org
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com,
        fei.li@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Feb 2013 15:37:11 +0800
Message-ID: <1362037031.6212.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Even in failed case of pm_runtime_get_sync, the usage_count
is incremented. In order to keep the usage_count with correct
value and runtime power management to behave correctly, call
pm_runtime_put(_sync) in such case.

Signed-off-by Liu Chuansheng <chuansheng.liu@intel.com>
Signed-off-by: Li Fei <fei.li@intel.com>
---
 drivers/base/regmap/regmap-irq.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 4706c63..020ea2b 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -184,6 +184,7 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 		if (ret < 0) {
 			dev_err(map->dev, "IRQ thread failed to resume: %d\n",
 				ret);
+			pm_runtime_put(map->dev);
 			return IRQ_NONE;
 		}
 	}
-- 
1.7.4.1




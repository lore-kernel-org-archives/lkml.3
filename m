Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbaA1IvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 03:51:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:29797 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773AbaA1IvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 03:51:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,735,1384329600"; 
   d="scan'208";a="471910823"
Message-ID: <52E76F71.4080304@intel.com>
Date: Tue, 28 Jan 2014 16:50:57 +0800
From: "xinhui.pan" <xinhuix.pan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-gpio@vger.kernel.org, david.a.cohen@linux.intel.com,
        linus.walleij@linaro.org, gnurou@gmail.com,
        yanmin_zhang@linux.intel.com
Subject: [PATCH] gpio-intel-mid: fix the incorrect return of idle callback
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "xinhui.pan" <xinhuiX.pan@intel.com>

intel_gpio_runtime_idle should return correct error code if it do fail.
make it more correct even though -EBUSY is the most possible return value.

Signed-off-by: bo.he <bo.he@intel.com>
Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>
---
 drivers/gpio/gpio-intel-mid.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-intel-mid.c b/drivers/gpio/gpio-intel-mid.c
index d1b50ef..05749a3 100644
--- a/drivers/gpio/gpio-intel-mid.c
+++ b/drivers/gpio/gpio-intel-mid.c
@@ -394,7 +394,9 @@ static const struct irq_domain_ops intel_gpio_irq_ops = {
 
 static int intel_gpio_runtime_idle(struct device *dev)
 {
-	pm_schedule_suspend(dev, 500);
+	int err = pm_schedule_suspend(dev, 500);
+	if (err)
+		return err;
 	return -EBUSY;
 }
 
-- 
1.7.9.5

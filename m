Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbaAaVC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:02:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:22894 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291AbaAaVC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:02:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,759,1384329600"; 
   d="scan'208";a="476012342"
From: David Cohen <david.a.cohen@linux.intel.com>
To: linus.walleij@linaro.org, gnurou@gmail.com
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        "xinhui.pan" <xinhuiX.pan@intel.com>, "bo.he" <bo.he@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Felibe Balbi <balbi@ti.com>
Subject: [PATCH v2] gpio-intel-mid: fix the incorrect return of idle callback
Date: Fri, 31 Jan 2014 13:08:01 -0800
Message-Id: <1391202481-19533-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <20140131205007.GB26770@psi-dev26.jf.intel.com>
References: <20140131205007.GB26770@psi-dev26.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "xinhui.pan" <xinhuiX.pan@intel.com>

intel_gpio_runtime_idle should return correct error code if it do fail.
make it more correct even though -EBUSY is the most possible return value.

Signed-off-by: bo.he <bo.he@intel.com>
Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Cc: Felibe Balbi <balbi@ti.com>
---
 drivers/gpio/gpio-intel-mid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-intel-mid.c b/drivers/gpio/gpio-intel-mid.c
index 41218e93b9fe..55688d0548e9 100644
--- a/drivers/gpio/gpio-intel-mid.c
+++ b/drivers/gpio/gpio-intel-mid.c
@@ -369,8 +369,8 @@ static const struct irq_domain_ops intel_gpio_irq_ops = {
 
 static int intel_gpio_runtime_idle(struct device *dev)
 {
-	pm_schedule_suspend(dev, 500);
-	return -EBUSY;
+	int err = pm_schedule_suspend(dev, 500);
+	return err ?: -EBUSY;
 }
 
 static const struct dev_pm_ops intel_gpio_pm_ops = {
-- 
1.8.4.2


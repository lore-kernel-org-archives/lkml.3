Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934597AbaDJCLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 22:11:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:62768 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933779AbaDJCLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 22:11:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,830,1389772800"; 
   d="scan'208";a="518140612"
Message-ID: <5345FDBD.9090908@linux.intel.com>
Date: Thu, 10 Apr 2014 10:11:09 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: dmitry.torokhov@gmail.com, sachin.kamat@linaro.org,
        linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [patch]GPIO button is supposed to wake the system up if the wakeup
 attribute is set
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the wakeup attribute is set, GPIO button is supposed to set
irqflag - IRQF_NO_SUSPEND to request irq. So when the system enters
the suspend sleep mode, the GPIO irq keeps enabled and is able to
wake the system up.

The affected/tested machines include Dell Venue 11 Pro and Asus T100TA.

Signed-off-by: Aubrey Li <aubrey.li@linux.intel.com>
---
 drivers/input/keyboard/gpio_keys.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 2db1324..40f3963 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -503,6 +503,9 @@ static int gpio_keys_setup_key(struct platform_device *pdev,
 	if (!button->can_disable)
 		irqflags |= IRQF_SHARED;
 
+	if (button->wakeup)
+		irqflags |= IRQF_NO_SUSPEND;
+
 	error = request_any_context_irq(bdata->irq, isr, irqflags, desc, bdata);
 	if (error < 0) {
 		dev_err(dev, "Unable to claim irq %d; error %d\n",
-- 
1.7.10.4

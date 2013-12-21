Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab3LUCOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 21:14:12 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:20483 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab3LUCOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 21:14:08 -0500
X-IronPort-AV: E=Sophos;i="4.95,525,1384329600"; 
   d="scan'208";a="4514644"
From: Sherman Yin <syin@broadcom.com>
To: Mark Brown <broonie@kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Sherman Yin <syin@broadcom.com>
Subject: [PATCH v4 1/4] pinctrl: Add void * to pinctrl_pin_desc
Date: Fri, 20 Dec 2013 18:13:33 -0800
Message-ID: <1387592016-13740-2-git-send-email-syin@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387592016-13740-1-git-send-email-syin@broadcom.com>
References: <1386787041-6035-1-git-send-email-syin@broadcom.com>
 <1387592016-13740-1-git-send-email-syin@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drv_data is added to the pinctrl_pin_desc for drivers to define additional
driver-specific per-pin data.

Signed-off-by: Sherman Yin <syin@broadcom.com>
Reviewed-by: Christian Daudt <bcm@fixthebug.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
---
v4: no change
v3: no change
v2: no change
---
 include/linux/pinctrl/pinctrl.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index fefb886..cc8e1af 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -32,10 +32,12 @@ struct device_node;
  * pins, pads or other muxable units in this struct
  * @number: unique pin number from the global pin number space
  * @name: a name for this pin
+ * @drv_data: driver-defined per-pin data. pinctrl core does not touch this
  */
 struct pinctrl_pin_desc {
 	unsigned number;
 	const char *name;
+	void *drv_data;
 };
 
 /* Convenience macro to define a single named or anonymous pin descriptor */
-- 
1.7.9.5


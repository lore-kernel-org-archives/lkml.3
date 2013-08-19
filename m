Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab3HSCHv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 22:07:51 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:51287 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab3HSCHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 22:07:50 -0400
Message-ID: <1376878066.10251.4.camel@phoenix>
Subject: [PATCH 2/2] pinctrl: core: Add proper mutex lock in
 pinctrl_request_gpio
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Patrice Chotard <patrice.chotard@st.com>, linux-kernel@vger.kernel.org
Date: Mon, 19 Aug 2013 10:07:46 +0800
In-Reply-To: <1376877989.10251.2.camel@phoenix>
References: <1376877989.10251.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one is missed in commit 42fed7ba "pinctrl: move subsystem mutex to
pinctrl_dev struct".

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 53c40d9..92f86ab 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -562,11 +562,15 @@ int pinctrl_request_gpio(unsigned gpio)
 		return ret;
 	}
 
+	mutex_lock(&pctldev->mutex);
+
 	/* Convert to the pin controllers number space */
 	pin = gpio_to_pin(range, gpio);
 
 	ret = pinmux_request_gpio(pctldev, range, pin, gpio);
 
+	mutex_unlock(&pctldev->mutex);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(pinctrl_request_gpio);
-- 
1.8.1.2




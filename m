Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab3AYOPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:15:08 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:57653 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab3AYOPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:15:02 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@list.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Subject: [PATCH 13/19] pinctrl: nomadik: nmk_prcm_gpiocr_get_mode may be unused
Date: Fri, 25 Jan 2013 14:14:30 +0000
Message-Id: <1359123276-15833-14-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359123276-15833-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ESJk5c5wDulP3avvEH7Ho6wjaDeWVHQEIS4klh6Zv6v
 D/ZZ1xtw+rvOvaE19h4l+A10q601aLC+JgjYDKyLg+Q3zdUXCN
 d0+zOHsEZ6nwdqrhPHptS7V5d1JyLGIaOLOE1CgA+fXreU4kT4
 3BohLJtIL+yhD6ScS1eEgXo5agamdzEKVoMsj3X9RLPrCsXv5l
 OCbR5HvRA4KjQ9OGk9wZ18wRiV370xa4hOacHrYqy8XnYRon5N
 TXA7aUbr80NEHX3XBeY5bDVZB6HFKBURXjH9mV+uODgBEko2t7
 d54kE2tKxDeflAEW/oONLdPD3UHxwxt6BRUVecKd0aEDWiiyZi
 M1c7EENOEyWw79FiuJPK3hvBZGIza70nbuj4D/KIP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nmk_prcm_gpiocr_get_mode is only needed for debugfs output at
the moment, which can be compile-time disabled. Marking
the function __maybe_unused still gives us compile-time
coverage, but avoids a gcc warning.

Without this patch, building nhk8815_defconfig results in:

drivers/pinctrl/pinctrl-nomadik.c:676:12: warning: 'nmk_prcm_gpiocr_get_mode' defined but not used [-Wunused-function]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
---
 drivers/pinctrl/pinctrl-nomadik.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 1bb16ff..5767b18 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -676,7 +676,7 @@ int nmk_gpio_set_mode(int gpio, int gpio_mode)
 }
 EXPORT_SYMBOL(nmk_gpio_set_mode);
 
-static int nmk_prcm_gpiocr_get_mode(struct pinctrl_dev *pctldev, int gpio)
+static int __maybe_unused nmk_prcm_gpiocr_get_mode(struct pinctrl_dev *pctldev, int gpio)
 {
 	int i;
 	u16 reg;
-- 
1.8.0


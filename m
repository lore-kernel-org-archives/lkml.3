Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab3AYWqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:46:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:49671 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab3AYWp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:45:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Subject: [PATCH 13/19] pinctrl: nomadik: nmk_prcm_gpiocr_get_mode may be unused
Date: Fri, 25 Jan 2013 22:44:12 +0000
Message-Id: <1359153858-31992-14-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359153858-31992-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359153858-31992-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:8Wjof6ZuoQPQ5p1QwmpG+rUa4ck38hzlM4xkmVv85Bp
 bQdASSJEt0oerCgEgN+HTH8SJPDFbqAN6YDsUxmHzQF/kx5Ji+
 BZFlcH6/92HQhYK+PX3F6cHW8cWTBKsW2aOZuktGyK6mKhR/82
 Yb+5trDiQDS/7tfberNCjfCBpafb8dR3C7Hzil9afC0prdh96A
 E6izWayk5gfeqhqscym0vZV+dfrT7+/DE5izKX9ev7fpAMoKEs
 6zqFLrPCHsDbli8X/jUVB9QVS1AHp/rdImuuxfDjh08oe+2HW9
 PXLV0Zj0RyXTPgA1gD+p/BbHjgip/SDb6KSFOu0607OubmLHAM
 Eq8nf3MadM9hbAYDg7zE4HsX+J1SIPHCJ0432zkL/
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


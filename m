Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaGMLth (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 07:49:37 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:62031 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbaGMLt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 07:49:29 -0400
Message-ID: <53C27247.2010300@gmail.com>
Date: Sun, 13 Jul 2014 19:49:27 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: thierry.reding@gmail.com
CC: linux-pwm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH] drivers/pwm/Kconfig: Let PWM_CLPS711X depend on HAS_IOMEM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PWM_CLPS711X needs HAS_IOMEM, so let it depend on HAS_IOMEM.

The related error (with allmodconfig under score):

    MODPOST 1365 modules
  ERROR: "devm_ioremap_resource" [drivers/pwm/pwm-clps711x.ko] undefined!


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/pwm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 4ad7b89..2faf5ce 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -82,7 +82,7 @@ config PWM_BFIN
 
 config PWM_CLPS711X
 	tristate "CLPS711X PWM support"
-	depends on ARCH_CLPS711X || COMPILE_TEST
+	depends on (ARCH_CLPS711X || COMPILE_TEST) && HAS_IOMEM
 	help
 	  Generic PWM framework driver for Cirrus Logic CLPS711X.
 
-- 
1.7.11.7

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab3JTWPP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 18:15:15 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14623 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab3JTWPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 18:15:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 20 Oct 2013 15:10:33 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 3/3] gpiolib: make GPIO_DEVRES depend on GPIOLIB
Date: Sun, 20 Oct 2013 15:14:59 -0700
Message-ID: <1382307299-22587-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382307299-22587-1-git-send-email-acourbot@nvidia.com>
References: <1382307299-22587-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current Kconfig allows GPIO_DEVRES to be selected and compiled without
GPIOLIB. This does not make sense anymore since GPIOLIB has become the
exclusive way to deal with GPIOs. This patch makes GPIO_DEVRES available
only if GPIOLIB is selected.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 92e258c..62eb9ef 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -30,10 +30,6 @@ config ARCH_REQUIRE_GPIOLIB
 	  Selecting this from the architecture code will cause the gpiolib
 	  code to always get built in.
 
-config GPIO_DEVRES
-	def_bool y
-	depends on HAS_IOMEM
-
 
 menuconfig GPIOLIB
 	bool "GPIO Support"
@@ -47,6 +43,10 @@ menuconfig GPIOLIB
 
 if GPIOLIB
 
+config GPIO_DEVRES
+	def_bool y
+	depends on HAS_IOMEM
+
 config OF_GPIO
 	def_bool y
 	depends on OF
-- 
1.8.4.1


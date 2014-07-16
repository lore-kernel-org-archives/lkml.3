Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591AbaGPLgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:36:37 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:51334 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134AbaGPLgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:36:35 -0400
From: pramod.gurav.etc@gmail.com
To: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav.etc@gmail.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH] regmap: Kconfig: Select SPMI when REGMAP_SPMI is selected
Date: Wed, 16 Jul 2014 17:09:57 +0530
Message-Id: <1405510797-755-1-git-send-email-pramod.gurav.etc@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pramod Gurav <pramod.gurav.etc@gmail.com>

REGMAP_SPMI module calls some functions from SPMI hence build breaks
when SPMI is not enabled while compiling REGMAP_SPMI with below linker
errors:

drivers/built-in.o: In function `regmap_spmi_ext_read':
:(.text+0x1143ec): undefined reference to `spmi_ext_register_read'
:(.text+0x11443c): undefined reference to `spmi_ext_register_readl'
drivers/built-in.o: In function `regmap_spmi_ext_gather_write':
:(.text+0x1144c4): undefined reference to `spmi_ext_register_write'
:(.text+0x114520): undefined reference to `spmi_ext_register_writel'
drivers/built-in.o: In function `regmap_spmi_base_read':
:(.text+0x1145b8): undefined reference to `spmi_register_read'
drivers/built-in.o: In function `regmap_spmi_base_gather_write':
:(.text+0x114630): undefined reference to `spmi_register_write'
:(.text+0x11465c): undefined reference to `spmi_register_zero_write'

Signed-off-by: Pramod Gurav <pramod.gurav.etc@gmail.com>
CC: Josh Cartwright <joshc@codeaurora.org>
CC: Mark Brown <broonie@linaro.org>
---
This was found when I enabled support for Qualcomm QPNP PMICs and was
compiling it. It selects REGMAP_SPMI and hence the crash.

 drivers/base/regmap/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
index 4251570..1aa9d71 100644
--- a/drivers/base/regmap/Kconfig
+++ b/drivers/base/regmap/Kconfig
@@ -16,6 +16,7 @@ config REGMAP_SPI
 	tristate
 
 config REGMAP_SPMI
+	select SPMI
 	tristate
 
 config REGMAP_MMIO
-- 
1.7.9.5


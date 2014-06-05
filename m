Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaFEVY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 17:24:57 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:59702 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaFEVYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 17:24:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/3] mfd: davinci voicecodec need regmap_mmio
Date: Thu,  5 Jun 2014 23:24:13 +0200
Message-Id: <1402003454-1989084-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402003454-1989084-1-git-send-email-arnd@arndb.de>
References: <1402003454-1989084-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:55lIXKJA57rQ2n96BJlkXF8fTBKujN+aU1YW+ccmKhZ
 gYfcuEjGj9FjMZe6OvrAPrOla0xLzXnd051AFNuK8B4h+AWuPJ
 gLIVvd4mUL6+TDFX0I0uSjc1ESVDxrA9uB+6ZtfUYzHM79+8HA
 nUfJySOUK+4dgFD926gdLPvUvbsfvNSB5K/MMvDBsktM2Vzfrh
 n7YHRVLIKqmcEL2rLv1O3j3uKeXCadrydA3j6f06bmIoPUeGsq
 ivtIhMb8iBa8ddr8gwioWbK3SSB8mHpqLbD7sTGEdqs9JGSKcY
 blQEhNWGodDjHbSic3MhrbgaVZF7aF/A7+ZrcsvXFNbDD7Yc6T
 AmI/tYFOfaktrvdAgU0/jGqRKeR8dv8a6jtQuYY4w
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without REGMAP_MMIO, building that driver results in a link error:

drivers/built-in.o: In function `davinci_vc_probe':
:(.init.text+0x3c1c): undefined reference to `devm_regmap_init_mmio_clk'

This adds a Kconfig 'select' statement as the usual way to ensure
that REGMAP_MMIO is enabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/mfd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 4370692..2dd838f 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -760,6 +760,7 @@ config MFD_SYSCON
 config MFD_DAVINCI_VOICECODEC
 	tristate
 	select MFD_CORE
+	select REGMAP_MMIO
 
 config MFD_TI_AM335X_TSCADC
 	tristate "TI ADC / Touch Screen chip support"
-- 
1.8.3.2


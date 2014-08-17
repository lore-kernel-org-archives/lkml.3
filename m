Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaHQKJO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 06:09:14 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:51994 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaHQKJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 06:09:11 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-spi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] regmap: Add eplicit dependencies to catch "select" misuse
Date: Sun, 17 Aug 2014 12:08:57 +0200
Message-Id: <1408270138-29811-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add explicit dependencies for the various regmap modules, so Kconfig
will print a warning message when another module selects a regmap module
without fulfilling its dependencies.

Without this, it's much more difficult to find out which module did the
offending select.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/base/regmap/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
index 4251570610c9..8a3f51f7b1b9 100644
--- a/drivers/base/regmap/Kconfig
+++ b/drivers/base/regmap/Kconfig
@@ -11,12 +11,15 @@ config REGMAP
 
 config REGMAP_I2C
 	tristate
+	depends on I2C
 
 config REGMAP_SPI
 	tristate
+	depends on SPI
 
 config REGMAP_SPMI
 	tristate
+	depends on SPMI
 
 config REGMAP_MMIO
 	tristate
-- 
1.9.1


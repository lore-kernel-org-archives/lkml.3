Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaFEVYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 17:24:50 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:65200 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaFEVYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 17:24:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/3] mfd: UCB1x00: enable modular build
Date: Thu,  5 Jun 2014 23:24:12 +0200
Message-Id: <1402003454-1989084-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402003454-1989084-1-git-send-email-arnd@arndb.de>
References: <1402003454-1989084-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:cJUVEn5BHD+nFnYbG4ZGsSJlYZsPo+GyzT7i+OxrzKm
 H/I8tIogciUJSwdd0tLR3oxNaUbdmDInS02iFHEYcUMTJ8YgIB
 8vOwIYc0DQGykvNfWCTU4oWfECKj+WhyUOK8pyyKayl6fAzJTp
 bhuVHu1KM5OOJEV2q5KdhnpyVABAD3hggcmHUdwbUVDyKnGlK4
 GelkHTwq0q51NNC2bomur6R8a40SL8WcsITECVRJz2IFPh6KH4
 oSvXFNbsU5a7AXTCYMigLiIew4VeRYg4P5WxN93qsR7UIxU/DL
 t2gggwX73APkx0nPpHt+LpnlGtlAF6foZV0i2xwXIsEGkHoOhg
 VgrP1B/gjRheC3tOyPmVrweJjjjuOwulKBUlJQQEf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The UCB1200 / UCB1300 driver uses the MCP_SA11X0 driver, which
can be a loadable module, but this results in a link error
when UCB1200 itself is built-in:

drivers/built-in.o: In function `ucb1x00_io_set_dir':
:(.text+0x4a364): undefined reference to `mcp_reg_write'
drivers/built-in.o: In function `ucb1x00_io_write':
:(.text+0x4a3dc): undefined reference to `mcp_reg_write'
drivers/built-in.o: In function `ucb1x00_io_read':
:(.text+0x4a400): undefined reference to `mcp_reg_read'
drivers/built-in.o: In function `ucb1x00_adc_enable':
:(.text+0x4a460): undefined reference to `mcp_enable'
...

This can easily be resolved by making CONFIG_MCP_UCB1200 itself
a tristate option, since that causes Kconfig to track the
dependency correctly.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/mfd/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index ee8204c..4370692 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1248,7 +1248,7 @@ config MCP_SA11X0
 
 # Chip drivers
 config MCP_UCB1200
-	bool "Support for UCB1200 / UCB1300"
+	tristate "Support for UCB1200 / UCB1300"
 	depends on MCP_SA11X0
 	select MCP
 
-- 
1.8.3.2


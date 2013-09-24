Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750785Ab3IXER1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 00:17:27 -0400
Received: from gw.cm.dream.jp ([59.157.128.2]:60764 "EHLO vsmtp02.cm.dti.ne.jp"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750706Ab3IXER0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 00:17:26 -0400
Date: Tue, 24 Sep 2013 13:17:03 +0900
From: takasi-y@ops.dti.ne.jp
To: SH-Linux <linux-sh@vger.kernel.org>
Cc: Magnus Damm <magnus.damm@gmail.com>, ben.dooks@codethink.co.uk,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        Simon Horman <horms@verge.net.au>, Paul Mundt <lethal@linux-sh.org>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] ARM: shmobile: kzm9d-reference: Use common clock
 framework
Message-Id: <20130924131703.4834a055892285858338003c@ops.dti.ne.jp>
In-Reply-To: <52410F86.4040301@renesas.com>
References: <52410F86.4040301@renesas.com>
X-Mailer: Sylpheed 3.4.0beta3 (GTK+ 2.24.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common clock framework version of clock
 drivers/clk/shmobile/clk-emev2.c
instead of sh-clkfwk version
 arch/arm/mach-shmobile/clock-emev2.c

kzm9d(without -reference) still uses sh-clkfwk version.

Because two of that framework can not live in one kernel binary,
there will be SoCs and Boards that can not be in one binary as
multiplatform binary or so.
For example, kzm9d and kzm9d-reference is now exclusive.

Signed-off-by: Takashi Yoshii <takashi.yoshii.zj@renesas.com>
---
 arch/arm/mach-shmobile/Kconfig                 | 1 +
 arch/arm/mach-shmobile/board-kzm9d-reference.c | 5 ++---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
index 50bab8d..d20d4ce 100644
--- a/arch/arm/mach-shmobile/Kconfig
+++ b/arch/arm/mach-shmobile/Kconfig
@@ -237,6 +237,7 @@ config MACH_KZM9D_REFERENCE
 	depends on ARCH_EMEV2
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 	select USE_OF
+	select COMMON_CLK
 	---help---
 	   Use reference implementation of KZM9D board support
 	   which makes a greater use of device tree at the expense
diff --git a/arch/arm/mach-shmobile/board-kzm9d-reference.c b/arch/arm/mach-shmobile/board-kzm9d-reference.c
index 8f8bb2f..e0b8317 100644
--- a/arch/arm/mach-shmobile/board-kzm9d-reference.c
+++ b/arch/arm/mach-shmobile/board-kzm9d-reference.c
@@ -20,15 +20,14 @@
 
 #include <linux/init.h>
 #include <linux/of_platform.h>
+#include <linux/clk-provider.h>
 #include <mach/emev2.h>
 #include <mach/common.h>
 #include <asm/mach/arch.h>
 
 static void __init kzm9d_add_standard_devices(void)
 {
-	if (!IS_ENABLED(CONFIG_COMMON_CLK))
-		emev2_clock_init();
-
+	of_clk_init(NULL);
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
-- 
1.8.1.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760991AbaGPAPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:15:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759703AbaGOXNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:13:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 3.10 20/44] clk: spear3xx: Use proper control register offset
Date: Tue, 15 Jul 2014 16:17:18 -0700
Message-Id: <20140715231647.302102178@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231646.690728348@linuxfoundation.org>
References: <20140715231646.690728348@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 15ebb05248d025534773c9ef64915bd888f04e4b upstream.

The control register is at offset 0x10, not 0x0. This is wreckaged
since commit 5df33a62c (SPEAr: Switch to common clock framework).

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/spear/spear3xx_clock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/spear/spear3xx_clock.c
+++ b/drivers/clk/spear/spear3xx_clock.c
@@ -211,7 +211,7 @@ static inline void spear310_clk_init(voi
 /* array of all spear 320 clock lookups */
 #ifdef CONFIG_MACH_SPEAR320
 
-#define SPEAR320_CONTROL_REG		(soc_config_base + 0x0000)
+#define SPEAR320_CONTROL_REG		(soc_config_base + 0x0010)
 #define SPEAR320_EXT_CTRL_REG		(soc_config_base + 0x0018)
 
 	#define SPEAR320_UARTX_PCLK_MASK		0x1



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbaA3O5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:57:49 -0500
Received: from eu1sys200aog121.obsmtp.com ([207.126.144.151]:40250 "EHLO
	eu1sys200aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752750AbaA3O5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:57:48 -0500
From: Patrice CHOTARD <patrice.chotard@st.com>
To: Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Cc: maxime.coquelin@st.com, alexandre.torgue@st.com, patrice.chotard@st.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH 1/4] ARM: STi: add stid127 soc support
Date: Thu, 30 Jan 2014 15:55:41 +0100
Message-Id: <1391093744-19905-2-git-send-email-patrice.chotard@st.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391093744-19905-1-git-send-email-patrice.chotard@st.com>
References: <1391093744-19905-1-git-send-email-patrice.chotard@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre TORGUE <alexandre.torgue@st.com>

This patch adds support to STiD127 SoC.
The main adaptation is the L2 cache way size compare to STiH41x SoCs.

Signed-off-by: alexandre torgue <alexandre.torgue@st.com>
Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
---
 arch/arm/mach-sti/board-dt.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/mach-sti/board-dt.c b/arch/arm/mach-sti/board-dt.c
index 1217fb5..be018a9 100644
--- a/arch/arm/mach-sti/board-dt.c
+++ b/arch/arm/mach-sti/board-dt.c
@@ -9,6 +9,7 @@
 
 #include <linux/irq.h>
 #include <linux/of_platform.h>
+#include <linux/of.h>
 #include <asm/hardware/cache-l2x0.h>
 #include <asm/mach/arch.h>
 
@@ -18,6 +19,10 @@ void __init stih41x_l2x0_init(void)
 {
 	u32 way_size = 0x4;
 	u32 aux_ctrl;
+
+	if (of_machine_is_compatible("st,stid127"))
+		way_size = 0x3;
+
 	/* may be this can be encoded in macros like BIT*() */
 	aux_ctrl = (0x1 << L2X0_AUX_CTRL_SHARE_OVERRIDE_SHIFT) |
 		(0x1 << L2X0_AUX_CTRL_DATA_PREFETCH_SHIFT) |
@@ -36,6 +41,7 @@ static void __init stih41x_machine_init(void)
 static const char *stih41x_dt_match[] __initdata = {
 	"st,stih415",
 	"st,stih416",
+	"st,stid127",
 	NULL
 };
 
-- 
1.7.9.5


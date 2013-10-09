Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab3JIV3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 17:29:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58472 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab3JIV3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 17:29:42 -0400
From: Nishanth Menon <nm@ti.com>
To: Kevin Hilman <khilman@linaro.org>, Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V6 01/15] ARM: OMAP3+: do not register non-dt OPP tables for device tree boot
Date: Wed, 9 Oct 2013 16:28:50 -0500
Message-ID: <1381354144-7134-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381354144-7134-1-git-send-email-nm@ti.com>
References: <1381354144-7134-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP3+ supports both device tree and non-device tree boot.
Device tree bindings for OMAP3+ is supposed to be added via dts following:
Documentation/devicetree/bindings/power/opp.txt

Since we now have device tree entries for OMAP3+ cpu OPPs,
The current code wrongly adds duplicate OPPs. So, dont register OPPs
when booting using device tree.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/mach-omap2/opp.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mach-omap2/opp.c b/arch/arm/mach-omap2/opp.c
index bd41d59..82fd8c7 100644
--- a/arch/arm/mach-omap2/opp.c
+++ b/arch/arm/mach-omap2/opp.c
@@ -17,6 +17,7 @@
  * GNU General Public License for more details.
  */
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/opp.h>
 #include <linux/cpu.h>
 
@@ -40,6 +41,9 @@ int __init omap_init_opp_table(struct omap_opp_def *opp_def,
 {
 	int i, r;
 
+	if (of_have_populated_dt())
+		return -EINVAL;
+
 	if (!opp_def || !opp_def_size) {
 		pr_err("%s: invalid params!\n", __func__);
 		return -EINVAL;
-- 
1.7.9.5


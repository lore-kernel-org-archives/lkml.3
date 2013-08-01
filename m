Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab3HAO7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:59:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44658 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756168Ab3HAO7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:59:11 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <rnayak@ti.com>
CC: <benoit.cousson@linaro.org>, <balbi@ti.com>, <george.cherian@ti.com>,
        <kishon@ti.com>, <dmurphy@ti.com>, <t-kristo@ti.com>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 4/4] ARM: DRA7: hwmod: Add SYSCONFIG for usb_otg_ss
Date: Thu, 1 Aug 2013 17:58:54 +0300
Message-ID: <1375369134-26398-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1375369134-26398-1-git-send-email-rogerq@ti.com>
References: <1375369134-26398-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the sysconfig class bits for the Super Speed USB
controllers

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
index f647998b..e8d9f38 100644
--- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
@@ -1732,8 +1732,20 @@ static struct omap_hwmod dra7xx_uart6_hwmod = {
  *
  */
 
+static struct omap_hwmod_class_sysconfig dra7xx_usb_otg_ss_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0010,
+	.sysc_flags	= (SYSC_HAS_DMADISABLE | SYSC_HAS_MIDLEMODE |
+			   SYSC_HAS_SIDLEMODE),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+			   SIDLE_SMART_WKUP | MSTANDBY_FORCE | MSTANDBY_NO |
+			   MSTANDBY_SMART | MSTANDBY_SMART_WKUP),
+	.sysc_fields	= &omap_hwmod_sysc_type2,
+};
+
 static struct omap_hwmod_class dra7xx_usb_otg_ss_hwmod_class = {
 	.name	= "usb_otg_ss",
+	.sysc	= &dra7xx_usb_otg_ss_sysc,
 };
 
 /* usb_otg_ss1 */
-- 
1.7.4.1


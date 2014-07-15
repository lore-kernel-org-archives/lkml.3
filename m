Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364AbaGORPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:15:03 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45936 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687AbaGORCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:12 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>, Paul Walmsley <paul@pwsan.com>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 37/94] ARM: DRA7: hwmod: Add SYSCONFIG for usb_otg_ss
Date: Tue, 15 Jul 2014 20:00:52 +0300
Message-Id: <1405443709-15288-37-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

Add the sysconfig class bits for the Super Speed USB
controllers

Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Rajendra Nayak <rnayak@ti.com>
Tested-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
index 1209266..284324f 100644
--- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
@@ -1727,8 +1727,20 @@ static struct omap_hwmod dra7xx_uart6_hwmod = {
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
1.7.10.4


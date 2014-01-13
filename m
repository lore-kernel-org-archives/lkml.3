Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbaAMRN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:13:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52778 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbaAMQA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:00:57 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roger Quadros <rogerq@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 001/208] ARM: OMAP3: hwmod data: Don't prevent RESET of USB Host module
Date: Mon, 13 Jan 2014 15:57:22 +0000
Message-Id: <1389628849-1614-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@ti.com>

commit 7f4d3641e2548d1ac5dee837ff434df668a2810c upstream.

Unlike what the comment states, errata i660 does not state that we
can't RESET the USB host module. Instead it states that RESET is the
only way to recover from a deadlock situation.

RESET ensures that the module is in a known good state irrespective
of what bootloader does with the module, so it must be done at boot.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Tested-by: Tomi Valkeinen <tomi.valkeinen@ti.com> # Panda, BeagleXM
Fixes: de231388cb80 ("ARM: OMAP: USB: EHCI and OHCI hwmod structures for OMAP3")
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index 0c3a427..f234cbe 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -1943,7 +1943,8 @@ static struct omap_hwmod_class_sysconfig omap3xxx_usb_host_hs_sysc = {
 	.syss_offs	= 0x0014,
 	.sysc_flags	= (SYSC_HAS_MIDLEMODE | SYSC_HAS_CLOCKACTIVITY |
 			   SYSC_HAS_SIDLEMODE | SYSC_HAS_ENAWAKEUP |
-			   SYSC_HAS_SOFTRESET | SYSC_HAS_AUTOIDLE),
+			   SYSC_HAS_SOFTRESET | SYSC_HAS_AUTOIDLE |
+			   SYSS_HAS_RESET_STATUS),
 	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
 			   MSTANDBY_FORCE | MSTANDBY_NO | MSTANDBY_SMART),
 	.sysc_fields	= &omap_hwmod_sysc_type1,
@@ -2021,15 +2022,7 @@ static struct omap_hwmod omap3xxx_usb_host_hs_hwmod = {
 	 * hence HWMOD_SWSUP_MSTANDBY
 	 */
 
-	/*
-	 * During system boot; If the hwmod framework resets the module
-	 * the module will have smart idle settings; which can lead to deadlock
-	 * (above Errata Id:i660); so, dont reset the module during boot;
-	 * Use HWMOD_INIT_NO_RESET.
-	 */
-
-	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY |
-			  HWMOD_INIT_NO_RESET,
+	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
 };
 
 /*
-- 
1.8.3.2


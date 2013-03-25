Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085Ab3CYXaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 19:30:20 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:51491 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759018Ab3CYXaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 19:30:18 -0400
Message-ID: <1364254205.1390.307.camel@x61.thuisdomein>
Subject: [PATCH] omap: fix typo "CONFIG_BRIDGE_DVFS"
From: Paul Bolle <pebolle@tiscali.nl>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 26 Mar 2013 00:30:05 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2013 23:30:10.0030 (UTC) FILETIME=[B0F740E0:01CE29B0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 90173882ed15a8034d6d162da5f343a2c7d87587 ("omap: add dsp platform
device") used CONFIG_BRIDGE_DVFS were it obviously meant
CONFIG_TIDSPBRIDGE_DVFS. Fix that.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested. As this typo has been in the tree since v2.6.37, this really
needs some testing.

 arch/arm/mach-omap2/dsp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/dsp.c b/arch/arm/mach-omap2/dsp.c
index b155500..b8208b4 100644
--- a/arch/arm/mach-omap2/dsp.c
+++ b/arch/arm/mach-omap2/dsp.c
@@ -26,7 +26,7 @@
 #include "control.h"
 #include "cm2xxx_3xxx.h"
 #include "prm2xxx_3xxx.h"
-#ifdef CONFIG_BRIDGE_DVFS
+#ifdef CONFIG_TIDSPBRIDGE_DVFS
 #include "omap-pm.h"
 #endif
 
@@ -35,7 +35,7 @@
 static struct platform_device *omap_dsp_pdev;
 
 static struct omap_dsp_platform_data omap_dsp_pdata __initdata = {
-#ifdef CONFIG_BRIDGE_DVFS
+#ifdef CONFIG_TIDSPBRIDGE_DVFS
 	.dsp_set_min_opp = omap_pm_dsp_set_min_opp,
 	.dsp_get_opp = omap_pm_dsp_get_opp,
 	.cpu_set_freq = omap_pm_cpu_set_freq,
-- 
1.7.11.7


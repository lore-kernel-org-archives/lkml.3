Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab3A3PB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 10:01:59 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:60196 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab3A3PBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 10:01:43 -0500
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        eduardo.valentin@ti.com
Subject: [RFC PATCH v3 2/2] ARM: OMAP4: setup SoC model name during ID initialisation
Date: Wed, 30 Jan 2013 17:01:31 +0200
Message-Id: <1359558091-29251-3-git-send-email-ruslan.bilovol@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359558091-29251-1-git-send-email-ruslan.bilovol@ti.com>
References: <1359558091-29251-1-git-send-email-ruslan.bilovol@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set up the SoC model name during OMAP ID initialisation
so it will be displayed in /proc/cpuinfo:

/ # cat proc/cpuinfo
[...]
CPU variant     : 0x2
CPU part        : 0xc09
CPU revision    : 10

SoC name        : OMAP4470

Hardware        : OMAP4 Blaze Tablet
Revision        : 20edb4
[...]

Signed-off-by: Ruslan Bilovol <ruslan.bilovol@ti.com>
---
 arch/arm/mach-omap2/id.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index 45cc7ed4..dca7ac7 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -20,6 +20,7 @@
 #include <linux/io.h>
 
 #include <asm/cputype.h>
+#include <asm/setup.h>
 
 #include "common.h"
 
@@ -33,6 +34,7 @@
 
 static unsigned int omap_revision;
 static const char *cpu_rev;
+static char omap_soc_model_name[80];
 u32 omap_features;
 
 unsigned int omap_rev(void)
@@ -502,6 +504,9 @@ void __init omap4xxx_check_revision(void)
 		omap_revision = OMAP4430_REV_ES2_3;
 	}
 
+	sprintf(omap_soc_model_name, "OMAP%04x", omap_rev() >> 16);
+	set_soc_model_name(omap_soc_model_name);
+
 	pr_info("OMAP%04x ES%d.%d\n", omap_rev() >> 16,
 		((omap_rev() >> 12) & 0xf), ((omap_rev() >> 8) & 0xf));
 }
-- 
1.7.9.5


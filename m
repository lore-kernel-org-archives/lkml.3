Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab3E3N3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:29:23 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:60646 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab3E3N2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:28:25 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 4/5] ARM: ux500: Provide auxdata to ux500 ASoC driver
Date: Thu, 30 May 2013 15:27:44 +0200
Message-Id: <1369920465-13905-5-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1369920465-13905-1-git-send-email-fabio.baltieri@linaro.org>
References: <1369920465-13905-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ux500 ASoC driver is expected to have a specific device name to get
clock resources correctly.  This patch provides the necessary
OF_DEV_AUXDATA to match the name in DT and non-DT cases.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 46cca52..fb3d5a2 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -277,6 +277,8 @@ static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("stericsson,db8500-prcmu", 0x80157000, "db8500-prcmu",
 			&db8500_prcmu_pdata),
 	OF_DEV_AUXDATA("smsc,lan9115", 0x50000000, "smsc911x.0", NULL),
+	OF_DEV_AUXDATA("stericsson,snd-soc-mop500", 0, "snd-soc-mop500.0",
+			NULL),
 	/* Requires device name bindings. */
 	OF_DEV_AUXDATA("stericsson,nmk-pinctrl", U8500_PRCMU_BASE,
 		"pinctrl-db8500", NULL),
-- 
1.8.2


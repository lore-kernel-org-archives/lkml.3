Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab3BGH4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 02:56:23 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33059 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3BGH4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 02:56:20 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: <linux-mmc@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <nsekhar@ti.com>, <hs@denx.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <cjb@laptop.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/3] ARM: davinci: da850: override mmc DT node device name
Date: Thu, 7 Feb 2013 13:27:03 +0530
Message-ID: <1360223825-23929-2-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360223825-23929-1-git-send-email-prakash.pm@ti.com>
References: <1360223825-23929-1-git-send-email-prakash.pm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Populate OF_DEV_AUXDATA with desired device name expected by
davinci_mmc driver. Without this clk_get of davinci_mmc DT driver
fails.

Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
Cc: linux-mmc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com
Cc: devicetree-discuss@lists.ozlabs.org
Cc: cjb@laptop.org
Cc: Sekhar Nori <nsekhar@ti.com>
---
Since v1:
Compatible string modified to accomodate version information.

 arch/arm/mach-davinci/da8xx-dt.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-davinci/da8xx-dt.c b/arch/arm/mach-davinci/da8xx-dt.c
index 37c27af..3362ca4 100644
--- a/arch/arm/mach-davinci/da8xx-dt.c
+++ b/arch/arm/mach-davinci/da8xx-dt.c
@@ -39,9 +39,16 @@ static void __init da8xx_init_irq(void)
 
 #ifdef CONFIG_ARCH_DAVINCI_DA850
 
+static const struct of_dev_auxdata da8xx_auxdata[] __initconst = {
+	OF_DEV_AUXDATA("ti,davinci-mmc-da830", 0x01c40000, "davinci_mmc.0",
+			NULL),
+	{},
+};
+
 static void __init da850_init_machine(void)
 {
-	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+	of_platform_populate(NULL, of_default_bus_match_table, da8xx_auxdata,
+			NULL);
 
 	da8xx_uart_clk_enable();
 }
-- 
1.7.4.1


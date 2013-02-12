Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab3BLGhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 01:37:15 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38951 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab3BLGhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 01:37:13 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: <linux-mmc@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <nsekhar@ti.com>, <hs@denx.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <cjb@laptop.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 3/3] ARM: davinci: da850: override mmc DT node device name
Date: Tue, 12 Feb 2013 12:07:38 +0530
Message-ID: <1360651058-5255-4-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360651058-5255-1-git-send-email-prakash.pm@ti.com>
References: <1360651058-5255-1-git-send-email-prakash.pm@ti.com>
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
Since v2:
Rebased on top of v3.9/dt-2 branch of linux_davinci and reordered this patch.
Since v1:
No Change.

 arch/arm/mach-davinci/da8xx-dt.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/da8xx-dt.c b/arch/arm/mach-davinci/da8xx-dt.c
index 5404e92..fc62240 100644
--- a/arch/arm/mach-davinci/da8xx-dt.c
+++ b/arch/arm/mach-davinci/da8xx-dt.c
@@ -40,6 +40,8 @@ static void __init da8xx_init_irq(void)
 struct of_dev_auxdata da850_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("ti,davinci-i2c", 0x01c22000, "i2c_davinci.1", NULL),
 	OF_DEV_AUXDATA("ti,davinci-wdt", 0x01c21000, "watchdog", NULL),
+	OF_DEV_AUXDATA("ti,davinci-mmc-da830", 0x01c40000, "davinci_mmc.0",
+			NULL),
 	{}
 };
 
-- 
1.7.4.1


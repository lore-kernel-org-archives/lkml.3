Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab3CLON6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 10:13:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52489 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3CLONz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 10:13:55 -0400
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: <linux-mmc@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <nsekhar@ti.com>, <hs@denx.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <cjb@laptop.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 4/4] ARM: davinci: da850: override mmc DT node device name
Date: Tue, 12 Mar 2013 19:43:57 +0530
Message-ID: <1363097637-11371-5-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363097637-11371-1-git-send-email-prakash.pm@ti.com>
References: <1363097637-11371-1-git-send-email-prakash.pm@ti.com>
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
 arch/arm/mach-davinci/da8xx-dt.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/da8xx-dt.c b/arch/arm/mach-davinci/da8xx-dt.c
index e049f07..516ec7d 100644
--- a/arch/arm/mach-davinci/da8xx-dt.c
+++ b/arch/arm/mach-davinci/da8xx-dt.c
@@ -41,6 +41,8 @@ struct of_dev_auxdata da850_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("ti,davinci-i2c", 0x01c22000, "i2c_davinci.1", NULL),
 	OF_DEV_AUXDATA("ti,davinci-wdt", 0x01c21000, "watchdog", NULL),
 	OF_DEV_AUXDATA("ti,da830-spi", 0x01f0e000, "spi_davinci.1", NULL),
+	OF_DEV_AUXDATA("ti,davinci-mmc-da830", 0x01c40000,
+			"davinci-mmc-da830.0", NULL),
 	{}
 };
 
-- 
1.7.4.1


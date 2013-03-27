Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab3C0HoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 03:44:03 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44087 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777Ab3C0HoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 03:44:01 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <linux@arm.linux.org.uk>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 2/3] ARM: davinci: da850: override LCDC DT node device name
Date: Wed, 27 Mar 2013 13:13:58 +0530
Message-ID: <1364370239-18390-3-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364370239-18390-1-git-send-email-avinashphilip@ti.com>
References: <1364370239-18390-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Populate OF_DEV_AUXDATA with desired device name expected by da8xx-fb
driver. Without this clk_get of da8xx-fb DT driver fails.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
 arch/arm/mach-davinci/da8xx-dt.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-davinci/da8xx-dt.c b/arch/arm/mach-davinci/da8xx-dt.c
index 89ee974..3436052 100644
--- a/arch/arm/mach-davinci/da8xx-dt.c
+++ b/arch/arm/mach-davinci/da8xx-dt.c
@@ -45,6 +45,7 @@ struct of_dev_auxdata da850_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("ti,da850-ecap", 0x01f06000, "ecap", NULL),
 	OF_DEV_AUXDATA("ti,da850-ecap", 0x01f07000, "ecap", NULL),
 	OF_DEV_AUXDATA("ti,da850-ecap", 0x01f08000, "ecap", NULL),
+	OF_DEV_AUXDATA("ti,da830-lcdc", 0x01e13000, "da8xx_lcdc.0", NULL),
 	{}
 };
 
-- 
1.7.9.5


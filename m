Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab3AWJt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:49:27 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:34738 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab3AWJtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:49:22 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <richard.genoud@gmail.com>, <linux-arm@overkiz.com>,
        <manabian@gmail.com>, <dgilbert@interlog.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Josh Wu <josh.wu@atmel.com>, Bo Shen <voice.shen@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 5/9] ARM: at91: rm9200: remake the BGA as default version
Date: Wed, 23 Jan 2013 10:48:52 +0100
Message-ID: <36224d0fe0f34cdde66a381708853ebadeac799c.1358934163.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1358934163.git.nicolas.ferre@atmel.com>
References: <cover.1358934163.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Make BGA as the default version as we are supposed to just have
to specify when we use the PQFP version.

Issue was existing since commit:
3e90772 (ARM: at91: fix at91rm9200 soc subtype handling).

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: stable <stable@vger.kernel.org> [v3.3]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/setup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 9ee866c..4b67847 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -105,6 +105,8 @@ static void __init soc_detect(u32 dbgu_base)
 	switch (socid) {
 	case ARCH_ID_AT91RM9200:
 		at91_soc_initdata.type = AT91_SOC_RM9200;
+		if (at91_soc_initdata.subtype == AT91_SOC_SUBTYPE_NONE)
+			at91_soc_initdata.subtype = AT91_SOC_RM9200_BGA;
 		at91_boot_soc = at91rm9200_soc;
 		break;
 
-- 
1.8.0


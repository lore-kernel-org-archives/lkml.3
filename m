Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936525Ab3DHWw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 18:52:29 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:52105 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936486Ab3DHWw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 18:52:27 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH v3 4/9] ARM: mvebu: Enable pj4b on LPAE compilations
Date: Tue,  9 Apr 2013 00:52:12 +0200
Message-Id: <1365461538-30702-5-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365461538-30702-1-git-send-email-gregory.clement@free-electrons.com>
References: <1365461538-30702-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lior Amsalem <alior@marvell.com>

pj4b cpus are LPAE capable so enable them on LPAE compilations

Signed-off-by: Lior Amsalem <alior@marvell.com>
Tested-by: Franklin <flin@marvell.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/mm/proc-v7.S |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index f584d3f..d75dc67 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -402,6 +402,8 @@ __v7_ca9mp_proc_info:
 	__v7_proc __v7_ca9mp_setup
 	.size	__v7_ca9mp_proc_info, . - __v7_ca9mp_proc_info
 
+#endif	/* CONFIG_ARM_LPAE */
+
 	/*
 	 * Marvell PJ4B processor.
 	 */
@@ -411,7 +413,6 @@ __v7_pj4b_proc_info:
 	.long	0xfffffff0
 	__v7_proc __v7_pj4b_setup
 	.size	__v7_pj4b_proc_info, . - __v7_pj4b_proc_info
-#endif	/* CONFIG_ARM_LPAE */
 
 	/*
 	 * ARM Ltd. Cortex A7 processor.
-- 
1.7.9.5


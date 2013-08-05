Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab3HEQRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:17:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39381 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551Ab3HEQQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:16:26 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Mark Brown <broonie@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Balaji TK <balajitk@ti.com>,
        Gururaja Hebbar <gururaja.hebbar@ti.com>, Chris Ball <cjb@laptop.org>,
        Jason Kridner <jkridner@beagleboard.org>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH v3 06/12] ARM: edma: Add pr_debug in edma_link
Date: Mon, 5 Aug 2013 11:14:51 -0500
Message-ID: <1375719297-12871-7-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375719297-12871-1-git-send-email-joelf@ti.com>
References: <1375719297-12871-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Useful for visualizing linking of PaRAM slots

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/common/edma.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index aa43c49..34d3fc9 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -1125,6 +1125,8 @@ void edma_link(unsigned from, unsigned to)
 	ctlr_to = EDMA_CTLR(to);
 	to = EDMA_CHAN_SLOT(to);
 
+	pr_debug("Setting up link %d -> %d\n", from, to);
+
 	if (from >= edma_cc[ctlr_from]->num_slots)
 		return;
 	if (to >= edma_cc[ctlr_to]->num_slots)
-- 
1.7.9.5


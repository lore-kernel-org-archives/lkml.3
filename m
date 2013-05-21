Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab3EUSNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 14:13:55 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46881 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab3EUSNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 14:13:53 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 21 May 2013 13:13:21 -0500
Message-Id: <1369160001-4019-7-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369160001-4019-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130521181230.GF1627@sirena.org.uk>
 <1369160001-4019-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 7/7] mfd: arizona: Change fast_start pdata name to better reflect functionality
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

The bit in the register enables MICBIAS fast startup when clear not when
set. This patch changes the name of this pdata option to soft_start to
better match the functionality. We rename rather than invert the
handling to keep the same default functionality, which is fast start
active.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c        |    2 +-
 include/linux/mfd/arizona/pdata.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 437f199..74b4481 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -860,7 +860,7 @@ int arizona_dev_init(struct arizona *arizona)
 		if (arizona->pdata.micbias[i].discharge)
 			val |= ARIZONA_MICB1_DISCH;
 
-		if (arizona->pdata.micbias[i].fast_start)
+		if (arizona->pdata.micbias[i].soft_start)
 			val |= ARIZONA_MICB1_RATE;
 
 		if (arizona->pdata.micbias[i].bypass)
diff --git a/include/linux/mfd/arizona/pdata.h b/include/linux/mfd/arizona/pdata.h
index 80dead1..12a5c13 100644
--- a/include/linux/mfd/arizona/pdata.h
+++ b/include/linux/mfd/arizona/pdata.h
@@ -77,7 +77,7 @@ struct arizona_micbias {
 	int mV;                    /** Regulated voltage */
 	unsigned int ext_cap:1;    /** External capacitor fitted */
 	unsigned int discharge:1;  /** Actively discharge */
-	unsigned int fast_start:1; /** Enable aggressive startup ramp rate */
+	unsigned int soft_start:1; /** Disable aggressive startup ramp rate */
 	unsigned int bypass:1;     /** Use bypass mode */
 };
 
-- 
1.7.10.4


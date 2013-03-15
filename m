Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab3CONRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:17:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50652 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652Ab3CONRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:17:51 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Vaibhav Bedia <vaibhav.bedia@ti.com>
Subject: [PATCH 45/50] staging: omap-thermal: change Kconfig dependency method
Date: Fri, 15 Mar 2013 09:00:33 -0400
Message-ID: <1363352438-15935-46-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now arch code has to specify CONFIG_ARCH_HAS_BANDGAP. So, this driver
will be selectable only if the platform reports itself as having a
bandgap device.

Any OMAP variant or any other OMAP version needs to
	select ARCH_HAS_BANDGAP
so that the driver will be applicable. A part from that it is
required to device the data structures that maps the registers
and their bitfields. The DT compatible list must also be updated.

CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Vaibhav Bedia <vaibhav.bedia@ti.com>

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/Kconfig |    2 +-
 drivers/staging/omap-thermal/TODO    |    1 -
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/omap-thermal/Kconfig b/drivers/staging/omap-thermal/Kconfig
index 30cbc3b..52170bf 100644
--- a/drivers/staging/omap-thermal/Kconfig
+++ b/drivers/staging/omap-thermal/Kconfig
@@ -1,7 +1,7 @@
 config OMAP_BANDGAP
 	tristate "Texas Instruments OMAP4+ temperature sensor driver"
 	depends on THERMAL
-	depends on ARCH_OMAP4 || SOC_OMAP5
+	depends on ARCH_HAS_BANDGAP
 	help
 	  If you say yes here you get support for the Texas Instruments
 	  OMAP4460+ on die bandgap temperature sensor support. The register
diff --git a/drivers/staging/omap-thermal/TODO b/drivers/staging/omap-thermal/TODO
index 9e23cc4..77b761b 100644
--- a/drivers/staging/omap-thermal/TODO
+++ b/drivers/staging/omap-thermal/TODO
@@ -20,7 +20,6 @@ on omap5-thermal.c
 - Add support for GPU cooling
 
 generally:
-- write Kconfig dependencies so that omap variants are covered
 - make checkpatch.pl and sparse happy
 - make sure this code works on OMAP4430, OMAP4460 and OMAP5430
 - update documentation
-- 
1.7.7.1.488.ge8e1c


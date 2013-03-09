Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab3CIQch (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 11:32:37 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:64668 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760334Ab3CIQcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 11:32:36 -0500
Message-ID: <1362846754.3137.9.camel@x61.thuisdomein>
Subject: [PATCH] mfd: drop "select PMIC_DA9055"
From: Paul Bolle <pebolle@tiscali.nl>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Date: Sat, 09 Mar 2013 17:32:34 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Mar 2013 16:32:35.0046 (UTC) FILETIME=[B46C1860:01CE1CE3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig entry for DA9055 PMIC Support selects PMIC_DA9055. That was
probably inspired by the similar select statement in the entry for
DA9052/53 PMIC with I2C. But the DA9055 PMIC only comes in an I2C
variant and its driver doesn't need a separate Kconfig symbol for shared
code. In any case, this select can be dropped as PMIC_DA9055 doesn't
exist.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested with "git grep" only.

1) Note that the DA9052 and DA9055 drivers all have code for module
support, but their Kconfig entries only allow them to be builtin. Can't
these entries be made tristate? If not, shouldn't the code for module
support be removed?

 drivers/mfd/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 671f5b1..cdff6dd 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -487,7 +487,6 @@ config MFD_DA9055
 	bool "Dialog Semiconductor DA9055 PMIC Support"
 	select REGMAP_I2C
 	select REGMAP_IRQ
-	select PMIC_DA9055
 	select MFD_CORE
 	depends on I2C=y && GENERIC_HARDIRQS
 	help
-- 
1.7.11.7


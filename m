Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab3CZSUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:20:32 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54127 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3CZSUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:20:31 -0400
X-IronPort-AV: E=Sophos;i="4.84,913,1355126400"; 
   d="scan'208";a="32874140"
From: David Brown <davidb@codeaurora.org>
To: Greg KH <greg@kroah.com>
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] mfd: pm8921: Disable driver until it gets fixed
Date: Tue, 26 Mar 2013 11:20:17 -0700
Message-Id: <1364322017-21490-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20130326151811.de958e38f0116334a62e1c8b@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pm8921 driver has been broken for a while now, but was prevented
from compiling because the SSBI bus driver was missing.  Now that SSBI
is present, pm8921 causes compile fails.

Until the pm8921 driver is fixed, mark it as BROKEN to prevent
compiles from failing.

Cc: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
Someone is working on the pm8921 driver, but we need to disable it
until those patches are posted.

 drivers/mfd/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 5bfa7bb..b9723a8 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -990,7 +990,7 @@ config MFD_PM8XXX
 
 config MFD_PM8921_CORE
 	tristate "Qualcomm PM8921 PMIC chip"
-	depends on SSBI
+	depends on SSBI && BROKEN
 	select MFD_CORE
 	select MFD_PM8XXX
 	help
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


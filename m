Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab3GEWpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:45:04 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:40752
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751019Ab3GEWpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:45:03 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: linux@arm.linux.org.uk, gregkh@linuxfoundation.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH] arm: Convert sa1111 platform and bus legacy pm_ops to dev_pm_ops
Date: Fri,  5 Jul 2013 16:44:57 -0600
Message-Id: <1373064297-13582-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert arch/arm/common/sa1111 platform and bus legacy pm_ops to dev_pm_ops.
This change also updates the use of COMFIG_PM to CONFIG_PM_SLEEP as this
platform and bus code implements PM_SLEEP ops and not the PM_RUNTIME ops.
Compile tested.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 arch/arm/common/sa1111.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
index 2a64c12..95594f0 100644
--- a/arch/arm/common/sa1111.c
+++ b/arch/arm/common/sa1111.c
@@ -1321,7 +1321,7 @@ static int sa1111_bus_resume(struct device *dev)
 }
 static SIMPLE_DEV_PM_OPS(sa1111_bus_dev_pm_ops, sa1111_bus_suspend,
 			 sa1111_bus_resume);
-#endif 
+#endif
 
 static void sa1111_bus_shutdown(struct device *dev)
 {
-- 
1.7.10.4


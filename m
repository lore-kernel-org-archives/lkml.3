Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab3DWQcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:32:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49407 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab3DWQb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:31:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "M'boumba Cedric Madianga" <cedric.madianga@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Michel JAOUEN <michel.jaouen@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 20/21] MFD: ab8500: export ab8500_gpadc_sw_hw_convert properly
Date: Tue, 23 Apr 2013 18:30:52 +0200
Message-Id: <1366734653-488286-21-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366734653-488286-1-git-send-email-arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:czil2QkpoShs2YAunsMr2Vw1lY0PJ2DSjbVTK/NcIeO
 tC+/vyx2cbwSplUQ9+J+51XmWsTyu3f2cpoxL7E5VjQlGOdj4V
 35UuRUDNw0BI1kgwCg/wA93wM6ax58HQsCkJpXqNghKvfo16oH
 xy1T0lg2LURT3RYonayXd0ILa23NFfkXgn4YHDcsBXduVRaDs+
 RECAA/zgCBaHOOd3i72I5zK9NtghqHppoyG5T/ddZmZdN/Ysi4
 cAOUFIK9cKIU4t93kzscPx7i+MV1LyMyWK43bn7nzrPH6kp63y
 /k3tWl0yHNxWJ+c0/e7S5cfF8r3RyCGhQsEGvHkCRFNuWk+EDH
 NDjENDMfjmtX4iViGJQuOtddZWyYYj0wmtDbhexaD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently the ab8500_gpadc_sw_hw_convert function got renamed
from ab8500_gpadc_convert to ab8500_gpadc_sw_hw_convert in
commit 734823462 "mfd: ab8500-gpadc: Add gpadc hw conversion",
but the export for this function did not get changed at the
same time, causing this allyesconfig error:

ERROR: "ab8500_gpadc_sw_hw_convert" [drivers/hwmon/ab8500.ko] undefined!

This patch fixes the export.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: M'boumba Cedric Madianga <cedric.madianga@stericsson.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Mattias WALLIN <mattias.wallin@stericsson.com>
Cc: Michel JAOUEN <michel.jaouen@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/ab8500-gpadc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index 5f341a5..184df96 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -269,7 +269,7 @@ int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 channel)
 
 	return voltage;
 }
-EXPORT_SYMBOL(ab8500_gpadc_convert);
+EXPORT_SYMBOL(ab8500_gpadc_sw_hw_convert);
 
 /**
  * ab8500_gpadc_read_raw() - gpadc read
-- 
1.8.1.2


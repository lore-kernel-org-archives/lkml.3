Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbaDOLYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:24:09 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:64211 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919AbaDOLYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:24:06 -0400
Message-ID: <1397561044.1985.47.camel@x220>
Subject: [PATCH 1/2] video: mmp: Remove references to CPU_MMP3
From: Paul Bolle <pebolle@tiscali.nl>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Richard Weinberger <richard@nod.at>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 15 Apr 2014 13:24:04 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Apr 2014 11:24:04.0933 (UTC) FILETIME=[35987F50:01CF589D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

References to the Kconfig symbol CPU_MMP3 were added to the tree since
v3.6. But that Kconfig symbol has never been part of the tree. So get
rid of these references.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested with git grep.

1) Originally sent as "[PATCH 01/28] Remove CPU_MMP3" two months ago.
Added a proper commit explanation to aid reviewers.

2) One reference to CPU_MMP3 remains. I'll remove that in a more
elaborate patch.

 drivers/video/mmp/Kconfig    | 2 +-
 drivers/video/mmp/hw/Kconfig | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/mmp/Kconfig b/drivers/video/mmp/Kconfig
index e9ea39e13722..969925d694c9 100644
--- a/drivers/video/mmp/Kconfig
+++ b/drivers/video/mmp/Kconfig
@@ -1,6 +1,6 @@
 menuconfig MMP_DISP
         tristate "Marvell MMP Display Subsystem support"
-        depends on CPU_PXA910 || CPU_MMP2 || CPU_MMP3 || CPU_PXA988
+        depends on CPU_PXA910 || CPU_MMP2 || CPU_PXA988
         help
 	  Marvell Display Subsystem support.
 
diff --git a/drivers/video/mmp/hw/Kconfig b/drivers/video/mmp/hw/Kconfig
index 02f109a20cd0..99f0506afc99 100644
--- a/drivers/video/mmp/hw/Kconfig
+++ b/drivers/video/mmp/hw/Kconfig
@@ -2,12 +2,12 @@ if MMP_DISP
 
 config MMP_DISP_CONTROLLER
 	bool "mmp display controller hw support"
-	depends on CPU_PXA910 || CPU_MMP2 || CPU_MMP3 || CPU_PXA988
+	depends on CPU_PXA910 || CPU_MMP2 || CPU_PXA988
 	default n
 	help
 		Marvell MMP display hw controller support
 		this controller is used on Marvell PXA910,
-		MMP2, MMP3, PXA988 chips
+		MMP2, PXA988 chips
 
 config MMP_DISP_SPI
 	bool "mmp display controller spi port"
-- 
1.9.0


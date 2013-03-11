Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab3CKVaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:30:10 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:50307 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753438Ab3CKVaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:30:08 -0400
Message-ID: <1363037403.3137.114.camel@x61.thuisdomein>
Subject: [PATCH] [media] soc_camera: remove two outdated selects
From: Paul Bolle <pebolle@tiscali.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 11 Mar 2013 22:30:03 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Mar 2013 21:30:03.0451 (UTC) FILETIME=[97BA10B0:01CE1E9F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Release v2.6.30 removed the MT9M001_PCA9536_SWITCH and
MT9V022_PCA9536_SWITCH Kconfig symbols, in commits
36034dc325ecab63c8cfb992fbf9a1a8e94738a2 ("V4L/DVB (11032): mt9m001:
allow setting of bus width from board code") and
e958e27adeade7fa085dd396a8a0dfaef7e338c1 ("V4L/DVB (11033): mt9v022:
allow setting of bus width from board code").

These two commits removed all gpio related code from these two drivers.
But they skipped removing their two selects of GPIO_PCA953X. Remove
these now as they are outdated. Their dependencies can never evaluate to
true anyhow.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested by grepping the tree.

 drivers/media/i2c/soc_camera/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/Kconfig b/drivers/media/i2c/soc_camera/Kconfig
index 6dff2b7..23d352f 100644
--- a/drivers/media/i2c/soc_camera/Kconfig
+++ b/drivers/media/i2c/soc_camera/Kconfig
@@ -9,7 +9,6 @@ config SOC_CAMERA_IMX074
 config SOC_CAMERA_MT9M001
 	tristate "mt9m001 support"
 	depends on SOC_CAMERA && I2C
-	select GPIO_PCA953X if MT9M001_PCA9536_SWITCH
 	help
 	  This driver supports MT9M001 cameras from Micron, monochrome
 	  and colour models.
@@ -36,7 +35,6 @@ config SOC_CAMERA_MT9T112
 config SOC_CAMERA_MT9V022
 	tristate "mt9v022 and mt9v024 support"
 	depends on SOC_CAMERA && I2C
-	select GPIO_PCA953X if MT9V022_PCA9536_SWITCH
 	help
 	  This driver supports MT9V022 cameras from Micron
 
-- 
1.7.11.7


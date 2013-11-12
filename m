Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab3KLUMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:12:52 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:58226 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab3KLUMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:12:43 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 06/12] staging: Remove superfluous name casts
Date: Tue, 12 Nov 2013 20:07:19 +0100
Message-Id: <1384283245-9419-7-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384283245-9419-1-git-send-email-geert@linux-m68k.org>
References: <1384283245-9419-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_driver.name is "const char *"

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/dwc2/platform.c  |    2 +-
 drivers/staging/usbip/vhci_hcd.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/dwc2/platform.c b/drivers/staging/dwc2/platform.c
index 76ae6e210f55..8f0489efdf40 100644
--- a/drivers/staging/dwc2/platform.c
+++ b/drivers/staging/dwc2/platform.c
@@ -134,7 +134,7 @@ MODULE_DEVICE_TABLE(of, dwc2_of_match_table);
 
 static struct platform_driver dwc2_platform_driver = {
 	.driver = {
-		.name = (char *)dwc2_driver_name,
+		.name = dwc2_driver_name,
 		.of_match_table = dwc2_of_match_table,
 	},
 	.probe = dwc2_driver_probe,
diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index e810ad53e2ac..8ae1feeb36cd 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -1108,7 +1108,7 @@ static struct platform_driver vhci_driver = {
 	.suspend = vhci_hcd_suspend,
 	.resume	= vhci_hcd_resume,
 	.driver	= {
-		.name = (char *) driver_name,
+		.name = driver_name,
 		.owner = THIS_MODULE,
 	},
 };
-- 
1.7.9.5


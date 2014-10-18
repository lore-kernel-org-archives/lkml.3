Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaJRWRN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 18:17:13 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:35296 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaJRWRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 18:17:11 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Tony Olech <tony.olech@elandigitalsystems.com>,
        Chris Ball <chris@printf.net>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Grant Likely <grant.likely@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 5/5] mmc: host: vub300.c:  Cleaning up missing null-terminate by switching from strncpy to strzcpy
Date: Sun, 19 Oct 2014 00:19:23 +0200
Message-Id: <1413670763-6662-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensures that the string is null-terminate in connection with the
use of strncpy, by switching from strncpy to strzcpy.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/mmc/host/vub300.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index 4262296..191e649 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -515,7 +515,7 @@ static void new_system_port_status(struct vub300_mmc_host *vub300)
 		vub300->card_present = 1;
 		vub300->bus_width = 0;
 		if (disable_offload_processing)
-			strncpy(vub300->vub_name, "EMPTY Processing Disabled",
+			strzcpy(vub300->vub_name, "EMPTY Processing Disabled",
 				sizeof(vub300->vub_name));
 		else
 			vub300->vub_name[0] = 0;
@@ -1222,7 +1222,7 @@ static void __download_offload_pseudocode(struct vub300_mmc_host *vub300,
 		dev_err(&vub300->udev->dev,
 			"corrupt offload pseudocode in firmware %s\n",
 			vub300->vub_name);
-		strncpy(vub300->vub_name, "corrupt offload pseudocode",
+		strzcpy(vub300->vub_name, "corrupt offload pseudocode",
 			sizeof(vub300->vub_name));
 		return;
 	}
@@ -1250,7 +1250,7 @@ static void __download_offload_pseudocode(struct vub300_mmc_host *vub300,
 						xfer_buffer, xfer_length, HZ);
 			kfree(xfer_buffer);
 			if (retval < 0) {
-				strncpy(vub300->vub_name,
+				strzcpy(vub300->vub_name,
 					"SDIO pseudocode download failed",
 					sizeof(vub300->vub_name));
 				return;
@@ -1260,7 +1260,7 @@ static void __download_offload_pseudocode(struct vub300_mmc_host *vub300,
 				"not enough memory for xfer buffer to send"
 				" INTERRUPT_PSEUDOCODE for %s %s\n", fw->data,
 				vub300->vub_name);
-			strncpy(vub300->vub_name,
+			strzcpy(vub300->vub_name,
 				"SDIO interrupt pseudocode download failed",
 				sizeof(vub300->vub_name));
 			return;
@@ -1269,7 +1269,7 @@ static void __download_offload_pseudocode(struct vub300_mmc_host *vub300,
 		dev_err(&vub300->udev->dev,
 			"corrupt interrupt pseudocode in firmware %s %s\n",
 			fw->data, vub300->vub_name);
-		strncpy(vub300->vub_name, "corrupt interrupt pseudocode",
+		strzcpy(vub300->vub_name, "corrupt interrupt pseudocode",
 			sizeof(vub300->vub_name));
 		return;
 	}
@@ -1297,7 +1297,7 @@ static void __download_offload_pseudocode(struct vub300_mmc_host *vub300,
 						xfer_buffer, xfer_length, HZ);
 			kfree(xfer_buffer);
 			if (retval < 0) {
-				strncpy(vub300->vub_name,
+				strzcpy(vub300->vub_name,
 					"SDIO pseudocode download failed",
 					sizeof(vub300->vub_name));
 				return;
@@ -1307,7 +1307,7 @@ static void __download_offload_pseudocode(struct vub300_mmc_host *vub300,
 				"not enough memory for xfer buffer to send"
 				" TRANSFER_PSEUDOCODE for %s %s\n", fw->data,
 				vub300->vub_name);
-			strncpy(vub300->vub_name,
+			strzcpy(vub300->vub_name,
 				"SDIO transfer pseudocode download failed",
 				sizeof(vub300->vub_name));
 			return;
@@ -1316,7 +1316,7 @@ static void __download_offload_pseudocode(struct vub300_mmc_host *vub300,
 		dev_err(&vub300->udev->dev,
 			"corrupt transfer pseudocode in firmware %s %s\n",
 			fw->data, vub300->vub_name);
-		strncpy(vub300->vub_name, "corrupt transfer pseudocode",
+		strzcpy(vub300->vub_name, "corrupt transfer pseudocode",
 			sizeof(vub300->vub_name));
 		return;
 	}
@@ -1350,7 +1350,7 @@ static void __download_offload_pseudocode(struct vub300_mmc_host *vub300,
 		dev_err(&vub300->udev->dev,
 			"corrupt dynamic registers in firmware %s\n",
 			vub300->vub_name);
-		strncpy(vub300->vub_name, "corrupt dynamic registers",
+		strzcpy(vub300->vub_name, "corrupt dynamic registers",
 			sizeof(vub300->vub_name));
 		return;
 	}
@@ -1380,11 +1380,11 @@ static void download_offload_pseudocode(struct vub300_mmc_host *vub300)
 		 vub300->vub_name);
 	retval = request_firmware(&fw, vub300->vub_name, &card->dev);
 	if (retval < 0) {
-		strncpy(vub300->vub_name, "vub_default.bin",
+		strzcpy(vub300->vub_name, "vub_default.bin",
 			sizeof(vub300->vub_name));
 		retval = request_firmware(&fw, vub300->vub_name, &card->dev);
 		if (retval < 0) {
-			strncpy(vub300->vub_name,
+			strzcpy(vub300->vub_name,
 				"no SDIO offload firmware found",
 				sizeof(vub300->vub_name));
 		} else {
@@ -1766,7 +1766,7 @@ static void vub300_cmndwork_thread(struct work_struct *work)
 			 * has been already downloaded to the VUB300 chip
 			 */
 		} else if (0 == vub300->mmc->card->sdio_funcs) {
-			strncpy(vub300->vub_name, "SD memory device",
+			strzcpy(vub300->vub_name, "SD memory device",
 				sizeof(vub300->vub_name));
 		} else {
 			download_offload_pseudocode(vub300);
-- 
1.7.10.4


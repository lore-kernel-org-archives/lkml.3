Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab3FWHD6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 03:03:58 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:52744 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab3FWHDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 03:03:49 -0400
From: Chad Williamson <chad@dahc.us>
To: gregkh@linuxfoundation.org
Cc: puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        tulinizer@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Chad Williamson <chad@dahc.us>
Subject: [PATCH 4/6] Staging: silicom: remove the board_t typedef in bpctl_mod.c
Date: Sun, 23 Jun 2013 02:02:26 -0500
Message-Id: <1371970948-26802-5-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371970948-26802-1-git-send-email-chad@dahc.us>
References: <1371970948-26802-1-git-send-email-chad@dahc.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the board_t enum typdef with struct board_type (_type for
consistency with media_type, above), resolving a checkpatch.pl
warning. (As far as I can tell, this isn't used anywhere.)

Signed-off-by: Chad Williamson <chad@dahc.us>
---
 drivers/staging/silicom/bpctl_mod.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 6945d3c..4d7ce55 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -5815,7 +5815,7 @@ static const struct file_operations Fops = {
 #define SILICOM_E1000BP_ETHERNET_DEVICE(device_id) {\
 	PCI_DEVICE(SILICOM_VID, device_id)}
 
-typedef enum {
+enum board_type {
 	PXG2BPFI,
 	PXG2BPFIL,
 	PXG2BPFILX,
@@ -5973,7 +5973,7 @@ typedef enum {
 	PE310G4BPi9SR,
 	PE310G4BPi9LR,
 	PE210G2BPi40,
-} board_t;
+};
 
 typedef struct _bpmod_info_t {
 	unsigned int vendor;
-- 
1.8.1.4


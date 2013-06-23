Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751060Ab3FWHEr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 03:04:47 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:51714 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab3FWHDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 03:03:52 -0400
From: Chad Williamson <chad@dahc.us>
To: gregkh@linuxfoundation.org
Cc: puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        tulinizer@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Chad Williamson <chad@dahc.us>
Subject: [PATCH 5/6] Staging: silicom: remove the typedef for bpmod_info_t
Date: Sun, 23 Jun 2013 02:02:27 -0500
Message-Id: <1371970948-26802-6-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371970948-26802-1-git-send-email-chad@dahc.us>
References: <1371970948-26802-1-git-send-email-chad@dahc.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the bpmod_info_t typedef from bpctl_mod.c, replacing it with
struct bpmod_info.

Signed-off-by: Chad Williamson <chad@dahc.us>
---
 drivers/staging/silicom/bpctl_mod.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 4d7ce55..35e8910 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -5975,7 +5975,7 @@ enum board_type {
 	PE210G2BPi40,
 };
 
-typedef struct _bpmod_info_t {
+struct bpmod_info {
 	unsigned int vendor;
 	unsigned int device;
 	unsigned int subvendor;
@@ -5983,7 +5983,7 @@ typedef struct _bpmod_info_t {
 	unsigned int index;
 	char *bp_name;
 
-} bpmod_info_t;
+};
 
 typedef struct _dev_desc {
 	char *name;
@@ -6159,7 +6159,7 @@ dev_desc_t dev_desc[] = {
 	{0},
 };
 
-static bpmod_info_t tx_ctl_pci_tbl[] = {
+static struct bpmod_info tx_ctl_pci_tbl[] = {
 	{0x8086, 0x107a, SILICOM_SVID, SILICOM_PXG2BPFI_SSID, PXG2BPFI,
 	 "PXG2BPFI-SD"},
 	{0x8086, 0x107a, SILICOM_SVID, SILICOM_PXG2BPFIL_SSID, PXG2BPFIL,
@@ -6657,7 +6657,7 @@ static void find_fw(struct bpctl_dev *dev)
 	printk("firmware version: 0x%x\n", dev->bp_fw_ver);
 }
 
-static int init_one(struct bpctl_dev *dev, bpmod_info_t *info, struct pci_dev *pdev1)
+static int init_one(struct bpctl_dev *dev, struct bpmod_info *info, struct pci_dev *pdev1)
 {
 	unsigned long mmio_start, mmio_len;
 
-- 
1.8.1.4


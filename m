Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbaBUBMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 20:12:54 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:44539 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623AbaBUBMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 20:12:51 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: JBottomley@parallels.com
Cc: jayamohan.kallickal@emulex.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [SCSI] be2iscsi: use NULL instead of 0 for pointer
Date: Fri, 21 Feb 2014 10:12:45 +0900
Message-ID: <8505576.9F9pTSfgP9@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b483ef302f7d77c586949ae170754d589e8a4935 Mon Sep 17 00:00:00 2001
From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Fri, 21 Feb 2014 08:39:08 +0900
Subject: [PATCH] [SCSI] be2iscsi: use NULL instead of 0 for pointer

sparse says:

drivers/scsi/be2iscsi/be_cmds.c:27:32: warning:
 Using plain integer as NULL pointer
drivers/scsi/be2iscsi/be_cmds.c:28:34: warning:
 Using plain integer as NULL pointer
drivers/scsi/be2iscsi/be_cmds.c:29:34: warning:
 Using plain integer as NULL pointer

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 3338391..1ec9793 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -24,9 +24,9 @@
 int beiscsi_pci_soft_reset(struct beiscsi_hba *phba)
 {
 	u32 sreset;
-	u8 *pci_reset_offset = 0;
-	u8 *pci_online0_offset = 0;
-	u8 *pci_online1_offset = 0;
+	u8 *pci_reset_offset = NULL;
+	u8 *pci_online0_offset = NULL;
+	u8 *pci_online1_offset = NULL;
 	u32 pconline0 = 0;
 	u32 pconline1 = 0;
 	u32 i;
-- 
1.7.9.5



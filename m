Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab3IMU13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 16:27:29 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:38502 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab3IMU11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 16:27:27 -0400
From: Antonio Alecrim Jr <antonio.alecrim@gmail.com>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Antonio Alecrim Jr <antonio.alecrim@gmail.com>
Subject: [PATCH 1/1] scsi:aic7xxx_old: fix: add missing enum ahc_chip entries
Date: Fri, 13 Sep 2013 14:27:29 -0300
Message-Id: <1379093249-5493-1-git-send-email-antonio.alecrim@gmail.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to this missing enum entries some switch cases have
unreached conditions:
drivers/scsi/aic7xxx_old.c: In function ‘aic7xxx_register’:
drivers/scsi/aic7xxx_old.c:7901:5: warning: case value ‘257’ not in enumerated type ‘ahc_chip’ [-Wswitch]

Signed-off-by: Antonio Alecrim Jr <antonio.alecrim@gmail.com>
---
 drivers/scsi/aic7xxx_old.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 33ec9c6..643e214 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -728,6 +728,8 @@ typedef enum {
   AHC_VL               = 0x0100,
   AHC_EISA             = 0x0200,
   AHC_PCI              = 0x0400,
+  AHC_AIC7770_EISA     = AHC_AIC7770|AHC_EISA,
+  AHC_AIC7770_VL       = AHC_AIC7770|AHC_VL,
 } ahc_chip;
 
 typedef enum {
-- 
1.8.3.1


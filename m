Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbaCZQtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 12:49:25 -0400
Received: from ced.ryick.net ([82.229.97.62]:42848 "EHLO ced.ryick.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320AbaCZQtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 12:49:23 -0400
From: =?UTF-8?q?C=C3=A9dric=20Cabessa?= <ced@ryick.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?C=C3=A9dric=20Cabessa?= <ced@ryick.net>
Subject: [PATCH] staging: vt6655,vt6656: fix sparse error "unexpected unlock"
Date: Wed, 26 Mar 2014 17:49:01 +0100
Message-Id: <1395852541-21211-1-git-send-email-ced@ryick.net>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cédric Cabessa <ced@ryick.net>
---
 drivers/staging/vt6655/wpactl.c   | 3 ++-
 drivers/staging/vt6656/firmware.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

This patch is part of the eudyptula challenge.

diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index d17224f..9f0715c 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -188,7 +188,8 @@ int wpa_set_wpadev(PSDevice pDevice, int val)
  *
  */
 
-int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel)
+int wpa_set_keys(PSDevice pDevice, void *ctx,
+		 bool fcpfkernel) __must_hold(&pDevice->lock)
 {
 	struct viawget_wpa_param *param = ctx;
 	PSMgmtObject pMgmt = pDevice->pMgmt;
diff --git a/drivers/staging/vt6656/firmware.c b/drivers/staging/vt6656/firmware.c
index cd2ea76..15c1e86 100644
--- a/drivers/staging/vt6656/firmware.c
+++ b/drivers/staging/vt6656/firmware.c
@@ -31,6 +31,7 @@
  *
  */
 
+#include <linux/compiler.h>
 #include "firmware.h"
 #include "control.h"
 #include "rndis.h"
@@ -43,7 +44,7 @@ static int msglevel = MSG_LEVEL_INFO;
 
 #define FIRMWARE_CHUNK_SIZE	0x400
 
-int FIRMWAREbDownload(struct vnt_private *pDevice)
+int FIRMWAREbDownload(struct vnt_private *pDevice) __must_hold(&pDevice->lock)
 {
 	struct device *dev = &pDevice->usb->dev;
 	const struct firmware *fw;
-- 
1.8.3.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaF1GRy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 02:17:54 -0400
Received: from mail-oa0-f74.google.com ([209.85.219.74]:60929 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaF1GR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 02:17:29 -0400
From: Ben Chan <benchan@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] staging: gdm72xx: use bool instead of custom-defined BOOLEAN
Date: Fri, 27 Jun 2014 23:17:25 -0700
Message-Id: <1403936247-24117-2-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1403936247-24117-1-git-send-email-benchan@chromium.org>
References: <1403936247-24117-1-git-send-email-benchan@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Chan <benchan@chromium.org>
---
 drivers/staging/gdm72xx/gdm_qos.c | 10 +++++-----
 drivers/staging/gdm72xx/gdm_qos.h |  4 +---
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
index df6f000..732f009 100644
--- a/drivers/staging/gdm72xx/gdm_qos.c
+++ b/drivers/staging/gdm72xx/gdm_qos.c
@@ -100,7 +100,7 @@ void gdm_qos_init(void *nic_ptr)
 	for (i = 0; i < QOS_MAX; i++) {
 		INIT_LIST_HEAD(&qcb->qos_list[i]);
 		qcb->csr[i].qos_buf_count = 0;
-		qcb->csr[i].enabled = 0;
+		qcb->csr[i].enabled = false;
 	}
 
 	qcb->qos_list_cnt = 0;
@@ -127,7 +127,7 @@ void gdm_qos_release_list(void *nic_ptr)
 
 	for (i = 0; i < QOS_MAX; i++) {
 		qcb->csr[i].qos_buf_count = 0;
-		qcb->csr[i].enabled = 0;
+		qcb->csr[i].enabled = false;
 	}
 
 	qcb->qos_list_cnt = 0;
@@ -316,8 +316,8 @@ static u32 get_csr(struct qos_cb_s *qcb, u32 SFID, int mode)
 
 	if (mode) {
 		for (i = 0; i < QOS_MAX; i++) {
-			if (qcb->csr[i].enabled == 0) {
-				qcb->csr[i].enabled = 1;
+			if (!qcb->csr[i].enabled) {
+				qcb->csr[i].enabled = true;
 				qcb->qos_list_cnt++;
 				return i;
 			}
@@ -428,7 +428,7 @@ void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 		INIT_LIST_HEAD(&free_list);
 
 		spin_lock_irqsave(&qcb->qos_lock, flags);
-		qcb->csr[index].enabled = 0;
+		qcb->csr[index].enabled = false;
 		qcb->qos_list_cnt--;
 		qcb->qos_limit_size = 254/qcb->qos_list_cnt;
 
diff --git a/drivers/staging/gdm72xx/gdm_qos.h b/drivers/staging/gdm72xx/gdm_qos.h
index 6543cff..50aa191 100644
--- a/drivers/staging/gdm72xx/gdm_qos.h
+++ b/drivers/staging/gdm72xx/gdm_qos.h
@@ -18,8 +18,6 @@
 #include <linux/usb.h>
 #include <linux/list.h>
 
-#define BOOLEAN	u8
-
 #define QOS_MAX				16
 #define IPTYPEOFSERVICE			0x8000
 #define	PROTOCOL			0x4000
@@ -34,7 +32,7 @@
 #define	IEEE802_1QVLANID		0x10
 
 struct gdm_wimax_csr_s {
-	BOOLEAN		enabled;
+	bool		enabled;
 	u32		SFID;
 	u8		qos_buf_count;
 	u16		classifier_rule_en;
-- 
2.0.0.526.g5318336


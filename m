Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaF1GSN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 02:18:13 -0400
Received: from mail-pd0-f202.google.com ([209.85.192.202]:37527 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaF1GR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 02:17:28 -0400
From: Ben Chan <benchan@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] staging: gdm72xx: use lower case for variable names for consistency
Date: Fri, 27 Jun 2014 23:17:27 -0700
Message-Id: <1403936247-24117-4-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1403936247-24117-1-git-send-email-benchan@chromium.org>
References: <1403936247-24117-1-git-send-email-benchan@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Chan <benchan@chromium.org>
---
 drivers/staging/gdm72xx/gdm_qos.c | 38 +++++++++++++++++++-------------------
 drivers/staging/gdm72xx/gdm_qos.h |  2 +-
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
index a2efc5c..b08c8e1 100644
--- a/drivers/staging/gdm72xx/gdm_qos.c
+++ b/drivers/staging/gdm72xx/gdm_qos.c
@@ -190,15 +190,15 @@ static int chk_ipv4_rule(struct gdm_wimax_csr_s *csr, u8 *stream, u8 *port)
 
 static int get_qos_index(struct nic *nic, u8 *iph, u8 *tcpudph)
 {
-	int IP_ver, i;
+	int ip_ver, i;
 	struct qos_cb_s *qcb = &nic->qos;
 
 	if (iph == NULL || tcpudph == NULL)
 		return -1;
 
-	IP_ver = (iph[0]>>4)&0xf;
+	ip_ver = (iph[0]>>4)&0xf;
 
-	if (IP_ver != 4)
+	if (ip_ver != 4)
 		return -1;
 
 	for (i = 0; i < QOS_MAX; i++) {
@@ -303,12 +303,12 @@ out:
 	return ret;
 }
 
-static int get_csr(struct qos_cb_s *qcb, u32 SFID, int mode)
+static int get_csr(struct qos_cb_s *qcb, u32 sfid, int mode)
 {
 	int i;
 
 	for (i = 0; i < qcb->qos_list_cnt; i++) {
-		if (qcb->csr[i].SFID == SFID)
+		if (qcb->csr[i].sfid == sfid)
 			return i;
 	}
 
@@ -332,7 +332,7 @@ void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 {
 	struct nic *nic = nic_ptr;
 	int i, index, pos;
-	u32 SFID;
+	u32 sfid;
 	u8 sub_cmd_evt;
 	struct qos_cb_s *qcb = &nic->qos;
 	struct qos_entry_s *entry, *n;
@@ -345,11 +345,11 @@ void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 	if (sub_cmd_evt == QOS_REPORT) {
 		spin_lock_irqsave(&qcb->qos_lock, flags);
 		for (i = 0; i < qcb->qos_list_cnt; i++) {
-			SFID = ((buf[(i*5)+6]<<24)&0xff000000);
-			SFID += ((buf[(i*5)+7]<<16)&0xff0000);
-			SFID += ((buf[(i*5)+8]<<8)&0xff00);
-			SFID += (buf[(i*5)+9]);
-			index = get_csr(qcb, SFID, 0);
+			sfid = ((buf[(i*5)+6]<<24)&0xff000000);
+			sfid += ((buf[(i*5)+7]<<16)&0xff0000);
+			sfid += ((buf[(i*5)+8]<<8)&0xff00);
+			sfid += (buf[(i*5)+9]);
+			index = get_csr(qcb, sfid, 0);
 			if (index == -1) {
 				spin_unlock_irqrestore(&qcb->qos_lock, flags);
 				netdev_err(nic->netdev, "QoS ERROR: No SF\n");
@@ -366,12 +366,12 @@ void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 
 	/* sub_cmd_evt == QOS_ADD || sub_cmd_evt == QOS_CHANG_DEL */
 	pos = 6;
-	SFID = ((buf[pos++]<<24)&0xff000000);
-	SFID += ((buf[pos++]<<16)&0xff0000);
-	SFID += ((buf[pos++]<<8)&0xff00);
-	SFID += (buf[pos++]);
+	sfid = ((buf[pos++]<<24)&0xff000000);
+	sfid += ((buf[pos++]<<16)&0xff0000);
+	sfid += ((buf[pos++]<<8)&0xff00);
+	sfid += (buf[pos++]);
 
-	index = get_csr(qcb, SFID, 1);
+	index = get_csr(qcb, sfid, 1);
 	if (index == -1) {
 		netdev_err(nic->netdev,
 			   "QoS ERROR: csr Update Error / Wrong index (%d)\n",
@@ -381,10 +381,10 @@ void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 
 	if (sub_cmd_evt == QOS_ADD) {
 		netdev_dbg(nic->netdev, "QOS_ADD SFID = 0x%x, index=%d\n",
-			   SFID, index);
+			   sfid, index);
 
 		spin_lock_irqsave(&qcb->qos_lock, flags);
-		qcb->csr[index].SFID = SFID;
+		qcb->csr[index].sfid = sfid;
 		qcb->csr[index].classifier_rule_en = ((buf[pos++]<<8)&0xff00);
 		qcb->csr[index].classifier_rule_en += buf[pos++];
 		if (qcb->csr[index].classifier_rule_en == 0)
@@ -422,7 +422,7 @@ void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 		spin_unlock_irqrestore(&qcb->qos_lock, flags);
 	} else if (sub_cmd_evt == QOS_CHANGE_DEL) {
 		netdev_dbg(nic->netdev, "QOS_CHANGE_DEL SFID = 0x%x, index=%d\n",
-			   SFID, index);
+			   sfid, index);
 
 		INIT_LIST_HEAD(&free_list);
 
diff --git a/drivers/staging/gdm72xx/gdm_qos.h b/drivers/staging/gdm72xx/gdm_qos.h
index ab03d33..8f742f3 100644
--- a/drivers/staging/gdm72xx/gdm_qos.h
+++ b/drivers/staging/gdm72xx/gdm_qos.h
@@ -33,7 +33,7 @@
 
 struct gdm_wimax_csr_s {
 	bool		enabled;
-	u32		SFID;
+	u32		sfid;
 	u8		qos_buf_count;
 	u16		classifier_rule_en;
 	u8		ip2s_lo;
-- 
2.0.0.526.g5318336


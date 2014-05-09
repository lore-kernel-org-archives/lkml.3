Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbaEIKJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:09:31 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58290 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756584AbaEIKJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:09:28 -0400
X-Sasl-enc: b0gmfWF6Aem0hRWc3SwbKNX4snAQpAt+ekasjQQOOYup 1399630162
From: Michalis Pappas <mpappas@fastmail.fm>
To: gregkh@linuxfoundation.org, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Michalis Pappas <mpappas@fastmail.fm>
Subject: [PATCH v5 05/10] staging: gdm72xx: Fix some camel-case variables
Date: Fri,  9 May 2014 18:08:24 +0800
Message-Id: <1399630109-18701-5-git-send-email-mpappas@fastmail.fm>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <536CA86B.7000109@fastmail.fm>
References: <536CA86B.7000109@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following checkpatch.pl issue:

CHECK: Avoid CamelCase: 

Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
---
 drivers/staging/gdm72xx/gdm_qos.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
index 519db48..465f695 100644
--- a/drivers/staging/gdm72xx/gdm_qos.c
+++ b/drivers/staging/gdm72xx/gdm_qos.c
@@ -142,24 +142,24 @@ void gdm_qos_release_list(void *nic_ptr)
 	free_qos_entry_list(&free_list);
 }
 
-static u32 chk_ipv4_rule(struct gdm_wimax_csr_s *csr, u8 *Stream, u8 *port)
+static u32 chk_ipv4_rule(struct gdm_wimax_csr_s *csr, u8 *stream, u8 *port)
 {
 	int i;
 
 	if (csr->classifier_rule_en&IPTYPEOFSERVICE) {
-		if (((Stream[1] & csr->ip2s_mask) < csr->ip2s_lo) ||
-		((Stream[1] & csr->ip2s_mask) > csr->ip2s_hi))
+		if (((stream[1] & csr->ip2s_mask) < csr->ip2s_lo) ||
+		((stream[1] & csr->ip2s_mask) > csr->ip2s_hi))
 			return 1;
 	}
 
 	if (csr->classifier_rule_en&PROTOCOL) {
-		if (Stream[9] != csr->protocol)
+		if (stream[9] != csr->protocol)
 			return 1;
 	}
 
 	if (csr->classifier_rule_en&IPMASKEDSRCADDRESS) {
 		for (i = 0; i < 4; i++) {
-			if ((Stream[12 + i] & csr->ipsrc_addrmask[i]) !=
+			if ((stream[12 + i] & csr->ipsrc_addrmask[i]) !=
 			(csr->ipsrc_addr[i] & csr->ipsrc_addrmask[i]))
 				return 1;
 		}
@@ -167,7 +167,7 @@ static u32 chk_ipv4_rule(struct gdm_wimax_csr_s *csr, u8 *Stream, u8 *port)
 
 	if (csr->classifier_rule_en&IPMASKEDDSTADDRESS) {
 		for (i = 0; i < 4; i++) {
-			if ((Stream[16 + i] & csr->ipdst_addrmask[i]) !=
+			if ((stream[16 + i] & csr->ipdst_addrmask[i]) !=
 			(csr->ipdst_addr[i] & csr->ipdst_addrmask[i]))
 				return 1;
 		}
@@ -190,16 +190,15 @@ static u32 chk_ipv4_rule(struct gdm_wimax_csr_s *csr, u8 *Stream, u8 *port)
 
 static u32 get_qos_index(struct nic *nic, u8 *iph, u8 *tcpudph)
 {
-	u32	IP_Ver, Header_Len, i;
+	u32	IP_ver, i;
 	struct qos_cb_s *qcb = &nic->qos;
 
 	if (iph == NULL || tcpudph == NULL)
 		return -1;
 
-	IP_Ver = (iph[0]>>4)&0xf;
-	Header_Len = iph[0]&0xf;
+	IP_ver = (iph[0]>>4)&0xf;
 
-	if (IP_Ver == 4) {
+	if (IP_ver == 4) {
 		for (i = 0; i < QOS_MAX; i++) {
 			if (qcb->csr[i].enabled) {
 				if (qcb->csr[i].classifier_rule_en) {
@@ -336,16 +335,16 @@ void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 {
 	struct nic *nic = nic_ptr;
 	u32 i, SFID, index, pos;
-	u8 subCmdEvt;
+	u8 sub_cmd_evt;
 	struct qos_cb_s *qcb = &nic->qos;
 	struct qos_entry_s *entry, *n;
 	struct list_head send_list;
 	struct list_head free_list;
 	unsigned long flags;
 
-	subCmdEvt = (u8)buf[4];
+	sub_cmd_evt = (u8)buf[4];
 
-	if (subCmdEvt == QOS_REPORT) {
+	if (sub_cmd_evt == QOS_REPORT) {
 		spin_lock_irqsave(&qcb->qos_lock, flags);
 		for (i = 0; i < qcb->qos_list_cnt; i++) {
 			SFID = ((buf[(i*5)+6]<<24)&0xff000000);
@@ -367,7 +366,7 @@ void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 		return;
 	}
 
-	/* subCmdEvt == QOS_ADD || subCmdEvt == QOS_CHANG_DEL */
+	/* sub_cmd_evt == QOS_ADD || sub_cmd_evt == QOS_CHANG_DEL */
 	pos = 6;
 	SFID = ((buf[pos++]<<24)&0xff000000);
 	SFID += ((buf[pos++]<<16)&0xff0000);
@@ -382,7 +381,7 @@ void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 		return;
 	}
 
-	if (subCmdEvt == QOS_ADD) {
+	if (sub_cmd_evt == QOS_ADD) {
 		netdev_dbg(nic->netdev, "QOS_ADD SFID = 0x%x, index=%d\n",
 			   SFID, index);
 
@@ -423,7 +422,7 @@ void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 
 		qcb->qos_limit_size = 254/qcb->qos_list_cnt;
 		spin_unlock_irqrestore(&qcb->qos_lock, flags);
-	} else if (subCmdEvt == QOS_CHANGE_DEL) {
+	} else if (sub_cmd_evt == QOS_CHANGE_DEL) {
 		netdev_dbg(nic->netdev, "QOS_CHANGE_DEL SFID = 0x%x, index=%d\n",
 			   SFID, index);
 
-- 
1.8.4


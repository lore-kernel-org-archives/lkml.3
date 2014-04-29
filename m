Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbaD2COX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 22:14:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58368 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751680AbaD2COV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 22:14:21 -0400
X-Sasl-enc: We50ydXcUx9ktm4vzFBRf2rFyKF84jGaCw3MKErx/HSE 1398737660
Message-ID: <535F0ADA.9070906@fastmail.fm>
Date: Tue, 29 Apr 2014 10:13:46 +0800
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/10] staging: gdm72xx: Fixed some camelCase variables
References: <532BF9B0.2080008@fastmail.fm> <20140418225229.GA28077@kroah.com> <53534051.2020504@fastmail.fm> <53534116.3040705@fastmail.fm> <20140422093743.GC26890@mwanda> <53570BAA.3080709@fastmail.fm> <20140423080447.GS26890@mwanda> <53577E96.10106@fastmail.fm> <20140423090557.GU26890@mwanda> <20140423090904.GV26890@mwanda> <535F0866.2060207@fastmail.fm>
In-Reply-To: <535F0866.2060207@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fixed some camelCase variables

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


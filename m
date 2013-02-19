Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203Ab3BSRpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:45:52 -0500
Received: from mout.gmx.net ([212.227.17.20]:65224 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933141Ab3BSRpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:45:49 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+0KLx/5vK0uLQv8odUSG2qZkZVBPmexic12bpYJy
	S7/GCK0mkio0PB
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sage Ahn <syahn@gctsemi.com>,
        Macpaul Lin <macpaul.from.taiwan@gmail.com>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>,
        Devendra Naga <devendra.aaru@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 2/3] staging/gdm72xx: Remove unused variable in gdm_qos.c
Date: Tue, 19 Feb 2013 18:50:19 +0100
Message-Id: <1361296220-10020-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1361296220-10020-1-git-send-email-peterhuewe@gmx.de>
References: <1361296220-10020-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

len is never read after assignment, thus can be removed.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/gdm72xx/gdm_qos.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
index 1e63031..d48994b 100644
--- a/drivers/staging/gdm72xx/gdm_qos.c
+++ b/drivers/staging/gdm72xx/gdm_qos.c
@@ -337,7 +337,6 @@ void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 	struct nic *nic = nic_ptr;
 	u32 i, SFID, index, pos;
 	u8 subCmdEvt;
-	u8 len;
 	struct qos_cb_s *qcb = &nic->qos;
 	struct qos_entry_s *entry, *n;
 	struct list_head send_list;
@@ -347,8 +346,6 @@ void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 	subCmdEvt = (u8)buf[4];
 
 	if (subCmdEvt == QOS_REPORT) {
-		len = (u8)buf[5];
-
 		spin_lock_irqsave(&qcb->qos_lock, flags);
 		for (i = 0; i < qcb->qos_list_cnt; i++) {
 			SFID = ((buf[(i*5)+6]<<24)&0xff000000);
@@ -369,8 +366,7 @@ void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 		send_qos_list(nic, &send_list);
 		return;
 	} else if (subCmdEvt == QOS_ADD) {
-		pos = 5;
-		len = (u8)buf[pos++];
+		pos = 6;
 
 		SFID = ((buf[pos++]<<24)&0xff000000);
 		SFID += ((buf[pos++]<<16)&0xff0000);
@@ -424,8 +420,7 @@ void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 		qcb->qos_limit_size = 254/qcb->qos_list_cnt;
 		spin_unlock_irqrestore(&qcb->qos_lock, flags);
 	} else if (subCmdEvt == QOS_CHANGE_DEL) {
-		pos = 5;
-		len = (u8)buf[pos++];
+		pos = 6;
 		SFID = ((buf[pos++]<<24)&0xff000000);
 		SFID += ((buf[pos++]<<16)&0xff0000);
 		SFID += ((buf[pos++]<<8)&0xff00);
-- 
1.7.8.6


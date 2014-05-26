Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaEZPW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:22:26 -0400
Received: from isis.lip6.fr ([132.227.60.2]:57180 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbaEZPVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:21:21 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: benoit.taine@lip6.fr, iscsi-driver@qlogic.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 4/18] qla4xxx: Use kmemdup instead of kmalloc + memcpy
Date: Mon, 26 May 2014 17:21:13 +0200
Message-Id: <1401117687-28911-5-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Mon, 26 May 2014 17:20:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issue was reported by coccicheck using the semantic patch 
at scripts/coccinelle/api/memdup.cocci

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
---
Tested by compilation without errors.

 drivers/scsi/qla4xxx/ql4_os.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 9eef7d4..3202063 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3565,14 +3565,13 @@ static int qla4xxx_copy_from_fwddb_param(struct iscsi_bus_flash_session *sess,
 	if (test_bit(OPT_IPV6_DEVICE, &options)) {
 		conn->ipv6_traffic_class = fw_ddb_entry->ipv4_tos;
 
-		conn->link_local_ipv6_addr = kzalloc(IPv6_ADDR_LEN, GFP_KERNEL);
+		conn->link_local_ipv6_addr = kmemdup(
+					fw_ddb_entry->link_local_ipv6_addr,
+					IPv6_ADDR_LEN, GFP_KERNEL);
 		if (!conn->link_local_ipv6_addr) {
 			rc = -ENOMEM;
 			goto exit_copy;
 		}
-
-		memcpy(conn->link_local_ipv6_addr,
-		       fw_ddb_entry->link_local_ipv6_addr, IPv6_ADDR_LEN);
 	} else {
 		conn->ipv4_tos = fw_ddb_entry->ipv4_tos;
 	}


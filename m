Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaFIT5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 15:57:23 -0400
Received: from mail-pb0-f73.google.com ([209.85.160.73]:64890 "EHLO
	mail-pb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbaFIT5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 15:57:20 -0400
From: Nick Black <nlb@google.com>
To: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi@googlegroups.com
Cc: linux-kernel@vger.kernel.org, Nick Black <nlb@google.com>
Subject: [PATCH 1/1] iscsi: kill redundant casts
Date: Mon,  9 Jun 2014 15:57:02 -0400
Message-Id: <1402343822-27701-1-git-send-email-nlb@google.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove two redundant casts from char * to char *.

Signed-off-by: Nick Black <nlb@google.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 0102a2d..38a1de3 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3059,7 +3059,7 @@ iscsi_get_chap(struct iscsi_transport *transport, struct nlmsghdr *nlh)
 		evchap->u.get_chap.host_no = ev->u.get_chap.host_no;
 		evchap->u.get_chap.chap_tbl_idx = ev->u.get_chap.chap_tbl_idx;
 		evchap->u.get_chap.num_entries = ev->u.get_chap.num_entries;
-		buf = (char *) ((char *)evchap + sizeof(*evchap));
+		buf = (char *)evchap + sizeof(*evchap);
 		memset(buf, 0, chap_buf_size);
 
 		err = transport->get_chap(shost, ev->u.get_chap.chap_tbl_idx,
@@ -3463,7 +3463,7 @@ iscsi_get_host_stats(struct iscsi_transport *transport, struct nlmsghdr *nlh)
 		evhost_stats->type = nlh->nlmsg_type;
 		evhost_stats->u.get_host_stats.host_no =
 					ev->u.get_host_stats.host_no;
-		buf = (char *)((char *)evhost_stats + sizeof(*evhost_stats));
+		buf = (char *)evhost_stats + sizeof(*evhost_stats);
 		memset(buf, 0, host_stats_size);
 
 		err = transport->get_host_stats(shost, buf, host_stats_size);
-- 
2.0.0.526.g5318336


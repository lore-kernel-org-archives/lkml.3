Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbbAAQ74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 11:59:56 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34597 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbbAAQ7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 11:59:55 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Christoph Hellwig <hch@lst.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Anish Bhatt <anish@chelsio.com>, Karen Xie <kxie@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hannes Reinecke <hare@suse.de>, Hans Wennborg <hans@hanshq.net>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: cxgbi: libcxgbi.c:  Remove some unused functions
Date: Thu,  1 Jan 2015 18:02:55 +0100
Message-Id: <1420131775-31186-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
csk_print_ip() csk_print_port()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/cxgbi/libcxgbi.c |   28 ----------------------------
 1 file changed, 28 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 674d498..7d2884b 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2434,34 +2434,6 @@ int cxgbi_set_conn_param(struct iscsi_cls_conn *cls_conn,
 }
 EXPORT_SYMBOL_GPL(cxgbi_set_conn_param);
 
-static inline int csk_print_port(struct cxgbi_sock *csk, char *buf)
-{
-	int len;
-
-	cxgbi_sock_get(csk);
-	len = sprintf(buf, "%hu\n", ntohs(csk->daddr.sin_port));
-	cxgbi_sock_put(csk);
-
-	return len;
-}
-
-static inline int csk_print_ip(struct cxgbi_sock *csk, char *buf)
-{
-	int len;
-
-	cxgbi_sock_get(csk);
-	if (csk->csk_family == AF_INET)
-		len = sprintf(buf, "%pI4",
-			      &csk->daddr.sin_addr.s_addr);
-	else
-		len = sprintf(buf, "%pI6",
-			      &csk->daddr6.sin6_addr);
-
-	cxgbi_sock_put(csk);
-
-	return len;
-}
-
 int cxgbi_get_ep_param(struct iscsi_endpoint *ep, enum iscsi_param param,
 		       char *buf)
 {
-- 
1.7.10.4


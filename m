Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbbAFPxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:53:25 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45694 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383AbbAFPxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:53:22 -0500
From: Imre Palik <imrep.amz@gmail.com>
To: xen-devel@lists.xenproject.org, netdev@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        linux-kernel@vger.kernel.org, "Palik, Imre" <imrep@amazon.de>,
        Anthony Liguori <aliguori@amazon.com>
Subject: [PATCH] xen-netback: fixing the propagation of the transmit shaper timeout
Date: Tue,  6 Jan 2015 16:44:44 +0100
Message-Id: <1420559084-28370-1-git-send-email-imrep.amz@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Palik, Imre" <imrep@amazon.de>

Since e9ce7cb6b107 ("xen-netback: Factor queue-specific data into queue struct"),
the transimt shaper timeout is always set to 0.  The value the user sets via
xenbus is never propagated to the transmit shaper.

This patch fixes the issue.

Cc: Anthony Liguori <aliguori@amazon.com>
Signed-off-by: Imre Palik <imrep@amazon.de>
---
 drivers/net/xen-netback/xenbus.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index efbaf2a..794204e 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -737,6 +737,7 @@ static void connect(struct backend_info *be)
 		}
 
 		queue->remaining_credit = credit_bytes;
+		queue->credit_usec = credit_usec;
 
 		err = connect_rings(be, queue);
 		if (err) {
-- 
1.7.9.5


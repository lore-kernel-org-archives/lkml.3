Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700AbaLBLhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 06:37:50 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:52080 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbaLBLht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 06:37:49 -0500
From: Mike Krinkin <krinkin.m.u@gmail.com>
To: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mike Krinkin <krinkin.m.u@gmail.com>
Subject: [PATCH] staging: rtl8712: remove unnecessary else after return
Date: Tue,  2 Dec 2014 14:37:45 +0300
Message-Id: <1417520265-4177-1-git-send-email-krinkin.m.u@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes checkpatch warning:
WARNING: else is not generally useful after a break or return

Signed-off-by: Mike Krinkin <krinkin.m.u@gmail.com>
---
 drivers/staging/rtl8712/rtl8712_recv.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index 27f38ac..cd8b444 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -522,11 +522,10 @@ int r8712_recv_indicatepkts_in_order(struct _adapter *padapter,
 	if (bforced == true) {
 		if (list_empty(phead))
 			return true;
-		else {
-			prframe = LIST_CONTAINOR(plist, union recv_frame, u);
-			pattrib = &prframe->u.hdr.attrib;
-			preorder_ctrl->indicate_seq = pattrib->seq_num;
-		}
+
+		prframe = LIST_CONTAINOR(plist, union recv_frame, u);
+		pattrib = &prframe->u.hdr.attrib;
+		preorder_ctrl->indicate_seq = pattrib->seq_num;
 	}
 	/* Prepare indication list and indication.
 	 * Check if there is any packet need indicate. */
-- 
1.9.1


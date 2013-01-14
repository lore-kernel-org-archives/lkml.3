Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab3ANC3e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 21:29:34 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60515 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab3ANC3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 21:29:32 -0500
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: gregkh@linuxfoundation.org, greg@kroah.com
Cc: Cruz Julian Bishop <cruzjbishop@gmail.com>, liodot@gmail.com,
        charrer@alacritech.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] staging: slicoss: Fix three checkpatch.pl errors in slicoss.c
Date: Mon, 14 Jan 2013 12:29:08 +1000
Message-Id: <1358130549-10969-3-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358130549-10969-1-git-send-email-cruzjbishop@gmail.com>
References: <1358130549-10969-1-git-send-email-cruzjbishop@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The errors fixed are all instances of
"ERROR: do not use assignment in if condition"

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
---
 drivers/staging/slicoss/slicoss.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 5aa03ee..b6b99a3 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -2930,11 +2930,14 @@ static int slic_if_init(struct adapter *adapter)
 	}
 
 	if (!adapter->queues_initialized) {
-		if ((rc = slic_rspqueue_init(adapter)))
+		rc = slic_rspqueue_init(adapter);
+		if (rc)
 			goto err;
-		if ((rc = slic_cmdq_init(adapter)))
+		rc = slic_cmdq_init(adapter);
+		if (rc)
 			goto err;
-		if ((rc = slic_rcvqueue_init(adapter)))
+		rc = slic_rcvqueue_init(adapter);
+		if (rc)
 			goto err;
 		adapter->queues_initialized = 1;
 	}
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285AbaGQNzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:55:21 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:43197 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbaGQNzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:55:19 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Cc: sivanich@sgi.com, Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH 3/4] drivers/misc/sgi-gru/grukdump.c: drop negativity check for unsgined req.gid
Date: Thu, 17 Jul 2014 16:55:07 +0300
Message-Id: <1405605307-13657-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-3.16-rc5/drivers/misc/sgi-gru/grukdump.c:199]: (style) Checking if
unsigned variable 'gid' is less than zero.

    if (req.gid >= gru_max_gids || req.gid < 0)
        return -EINVAL;

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80461
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 drivers/misc/sgi-gru/grukdump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/sgi-gru/grukdump.c b/drivers/misc/sgi-gru/grukdump.c
index a3700a5..e0e0e7e 100644
--- a/drivers/misc/sgi-gru/grukdump.c
+++ b/drivers/misc/sgi-gru/grukdump.c
@@ -196,7 +196,7 @@ int gru_dump_chiplet_request(unsigned long arg)
 		return -EFAULT;
 
 	/* Currently, only dump by gid is implemented */
-	if (req.gid >= gru_max_gids || req.gid < 0)
+	if (req.gid >= gru_max_gids)
 		return -EINVAL;
 
 	gru = GID_TO_GRU(req.gid);
-- 
1.8.5.5


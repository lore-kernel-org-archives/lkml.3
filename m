Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaGJKfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 06:35:17 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:45757 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaGJKfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:35:15 -0400
From: Vincent Heuken <me@vincentheuken.com>
To: willy@meta-x.org, gregkh@linuxfoundation.org, armand.bastien@laposte.net,
        domdevlin@free.fr, monamagarwal123@gmail.com, julia.lawall@lip6.fr,
        arnd@arndb.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Vincent Heuken <me@vincentheuken.com>
Subject: [PATCH] Staging: panel: fixed frivilous else statement warning
Date: Thu, 10 Jul 2014 03:34:28 -0700
Message-Id: <1404988468-8032-1-git-send-email-me@vincentheuken.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed one instance of the following checkpatch.pl warning in
panel.c:
WARNING: else is not generally useful after a break or return

Signed-off-by: Vincent Heuken <me@vincentheuken.com>
---
 drivers/staging/panel/panel.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 4e92293..6d1a320 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -1800,11 +1800,12 @@ static inline int input_state_high(struct logical_input *input)
 				input->high_timer++;
 		}
 		return 1;
-	} else {
-		/* else signal falling down. Let's fall through. */
-		input->state = INPUT_ST_FALLING;
-		input->fall_timer = 0;
 	}
+
+	/* else signal falling down. Let's fall through. */
+	input->state = INPUT_ST_FALLING;
+	input->fall_timer = 0;
+
 	return 0;
 }
 
-- 
2.0.1


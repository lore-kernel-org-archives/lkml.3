Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285AbaKROvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:51:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108AbaKROJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:55 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 101/206] media: tda7432: Fix setting TDA7432_MUTE bit for TDA7432_RF register
Date: Tue, 18 Nov 2014 15:07:36 +0100
Message-Id: <9f7dc51801a9bab5ebf3de6cfccbe78c779a6863.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 91ba0e59babdb3c7aca836a65f1095b3eaff7b06 upstream.

Fix a copy-paste bug when converting to the control framework.

Fixes: commit 5d478e0de871 ("[media] tda7432: convert to the control framework")

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/i2c/tda7432.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tda7432.c b/drivers/media/i2c/tda7432.c
index 72af644fa051..cf93021a6500 100644
--- a/drivers/media/i2c/tda7432.c
+++ b/drivers/media/i2c/tda7432.c
@@ -293,7 +293,7 @@ static int tda7432_s_ctrl(struct v4l2_ctrl *ctrl)
 		if (t->mute->val) {
 			lf |= TDA7432_MUTE;
 			lr |= TDA7432_MUTE;
-			lf |= TDA7432_MUTE;
+			rf |= TDA7432_MUTE;
 			rr |= TDA7432_MUTE;
 		}
 		/* Mute & update balance*/
-- 
2.1.3


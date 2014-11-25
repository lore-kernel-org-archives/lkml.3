Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaKYL0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:26:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58633 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbaKYKmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:04 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 127/254] [media] tda7432: Fix setting TDA7432_MUTE bit for TDA7432_RF register
Date: Tue, 25 Nov 2014 10:37:57 +0000
Message-Id: <1416912004-5928-128-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit 91ba0e59babdb3c7aca836a65f1095b3eaff7b06 upstream.

Fix a copy-paste bug when converting to the control framework.

Fixes: commit 5d478e0de871 ("[media] tda7432: convert to the control framework")

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
2.1.0


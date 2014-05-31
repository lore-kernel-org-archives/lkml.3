Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbaEaNOe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 09:14:34 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:64916 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550AbaEaNOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 09:14:32 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: kernel-janitors@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/11] cw1200: Remove useless return variables
Date: Sat, 31 May 2014 10:14:02 -0300
Message-Id: <1401542051-3174-2-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove variables that are initialized with a constant,
are never updated, and are only used as parameter of return.
Return the constant instead of using a variable.

Verified by compilation only.

The coccinelle script that find and fixes this issue is:
// <smpl>
@@
type T;
constant C;
identifier ret;
@@
- T ret = C;
... when != ret
    when strict
return
- ret
+ C
;
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/net/wireless/cw1200/sta.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/net/wireless/cw1200/sta.c b/drivers/net/wireless/cw1200/sta.c
index cd0cad7..622370c 100644
--- a/drivers/net/wireless/cw1200/sta.c
+++ b/drivers/net/wireless/cw1200/sta.c
@@ -2289,24 +2289,7 @@ static int cw1200_upload_null(struct cw1200_common *priv)
 
 static int cw1200_upload_qosnull(struct cw1200_common *priv)
 {
-	int ret = 0;
-	/* TODO:  This needs to be implemented
-
-	struct wsm_template_frame frame = {
-		.frame_type = WSM_FRAME_TYPE_QOS_NULL,
-		.rate = 0xFF,
-	};
-
-	frame.skb = ieee80211_qosnullfunc_get(priv->hw, priv->vif);
-	if (!frame.skb)
-		return -ENOMEM;
-
-	ret = wsm_set_template_frame(priv, &frame);
-
-	dev_kfree_skb(frame.skb);
-
-	*/
-	return ret;
+	return 0;
 }
 
 static int cw1200_enable_beaconing(struct cw1200_common *priv,


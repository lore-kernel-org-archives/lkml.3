Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab3EHXOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 19:14:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23777 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3EHXOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 19:14:49 -0400
X-AuditID: cbfee691-b7fe56d000004b96-37-518adc68b070
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Philipp Reisner'" <philipp.reisner@linbit.com>,
        "'Lars Ellenberg'" <lars.ellenberg@linbit.com>
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable ]drbd: fix for deadlock when using automatic
 split-brain-recovery
Date: Thu, 09 May 2013 08:14:47 +0900
Message-id: <003801ce4c41$d52a0890$7f7e19b0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLserQ
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zfd2MO12BBrMmM1ksaea2mN/9nsXi
	8q45bBYvZz5msliw8RGjA6vH0ytHmDz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEro+/5Y/aC
	X7wVS5+/YmxgvMzdxcjBISFgIrHjsFIXIyeQKSZx4d56ti5GLg4hgWWMEgtubGaHSJhIrP/3
	HCoxnVHi3elJrBDOX0aJy2d7warYBHQljq3fwgpiiwh4S5ya8osZxGYWqJKY+PUOI8g2IQFu
	idXNQSBhTgEeiXV/OsFKhAXiJG7eOglmswioSkzvW8cGYvMK2ElcPr6SCcIWlPgx+R4LxEgt
	ic3bmlghbHmJzWveMkM8oy7x6K8uRFhEYt+Ld2BbRQRiJHbvtwK5WELgFLvE1vnNbBCrBCS+
	TT7EAtEqK7HpADPEu5ISB1fcYJnAKDELyeJZSBbPQrJ4FpJtCxhZVjGKphYkFxQnpReZ6hUn
	5haX5qXrJefnbmKExOPEHYz3D1gfYkwGWj+RWUo0OR8Yz3kl8YbGZkYWpiamxkbmlmakCSuJ
	86q3WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYPR5eLz91LNK8QP6D4Td/568c9Wo/22P
	so5Bhs7r3P6bMU8lSg7+4u8WshW6/2Uq04W3FcGPlQ9zqv89uWIjjxvv89o4BbbKbet/zVAo
	jkoKDNd/1nFa/YDNmekBX5p/Na36cfYXmw5PseaRVxVrP29X/zDZdutE526PlYlmPkcj1X/E
	Tt0cdViJpTgj0VCLuag4EQBbKXeZ3QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQd30O12BBudbrC2WNHNbzO9+z2Jx
	edccNouXMx8zWSzY+IjRgdXj6ZUjTB59W1YxenzeJBfAHNXAaJORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFJJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjHmNH3/DF7wS/eiqXPXzE2MF7m7mLk5JAQMJFY/+85G4QtJnHh3nog
	m4tDSGA6o8S705NYIZy/jBKXz/ayg1SxCehKHFu/hRXEFhHwljg15RcziM0sUCUx8esdxi5G
	DqAGbonVzUEgYU4BHol1fzrBSoQF4iRu3joJZrMIqEpM71sHtphXwE7i8vGVTBC2oMSPyfdY
	IEZqSWze1sQKYctLbF7zlhlkvISAusSjv7oQYRGJfS/egW0VEYiR2L3fagKj0Cwkg2YhGTQL
	yaBZSLoXMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiO92fSOxhXNVgcYhTgYFTi4c1I
	7AoUYk0sK67MPcQowcGsJMJ7txUoxJuSWFmVWpQfX1Sak1p8iDEZ6M+JzFKiyfnAVJRXEm9o
	bGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYwRlb/uSDr/+u6UVcIs
	WNFVc95W9EHKDO4iJ/v1yZevK555vP7i6sulC5Sk8yaW3X10dqdOqXPH1qnNq/6G/rrRKtJS
	6vxJe4EEg7bWEtayvxxHTmh/4H3bfGqqVLrlhbo9T05K3F+6RIWf6+sO9/rPDqzy0v5dPDvS
	Pf7ufxX4+VfRyUNas/2VWIozEg21mIuKEwEGdXiHOwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Philipp Reisner <philipp.reisner@linbit.com>"

commit 7c689e63a847316c1b2500f86891b0a574ce7e69 upstream

With an automatic after split-brain recovery policy of
"after-sb-1pri call-pri-lost-after-sb",
when trying to drbd_set_role() to R_SECONDARY,
we run into a deadlock.

This was first recognized and supposedly fixed by
2009-06-10 "Fixed a deadlock when using automatic split brain recovery when
both nodes are"
replacing drbd_set_role() with drbd_change_state() in that code-path,
but the first hunk of that patch forgets to remove the drbd_set_role().

We apparently only ever tested the "two primaries" case.

Cc: <stable@vger.kernel.org> # 3.9.x: ef57f9e6: drbd: Fix build error
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/block/drbd/drbd_receiver.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_receiver.c
b/drivers/block/drbd/drbd_receiver.c
index a9eccfc..5105f43 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2661,7 +2661,6 @@ static int drbd_asb_recover_1p(struct drbd_conf *mdev)
__must_hold(local)
 		if (hg == -1 && mdev->state.role == R_PRIMARY) {
 			enum drbd_state_rv rv2;
 
-			drbd_set_role(mdev, R_SECONDARY, 0);
 			 /* drbd_change_state() does not sleep while in
SS_IN_TRANSIENT_STATE,
 			  * we might be here in C_WF_REPORT_PARAMS which is
transient.
 			  * we do not need to wait for the after state
change work either. */
-- 
1.7.9.5


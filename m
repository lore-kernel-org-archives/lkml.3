Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaD1J7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:59:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:44690 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbaD1J7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:59:21 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-ee-535e2678d846
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 1/2] f2fs: set errno when f2fs_iget failed in
 recover_dentry
Date: Mon, 28 Apr 2014 17:58:34 +0800
Message-id: <000501cf62c8$86ae39e0$940aada0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9ih2VOcOsdeE/3QXuPU+obt2PigA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jAd0Ktbhgg2tveS2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyti4/RRrwW3WirZ/
	T5gbGA+wdDFyckgImEi0zz/ODGGLSVy4t56ti5GLQ0hgEaPEqzmN7BDOD0aJpQ9esoNUsQmo
	SCzv+M8EYosIKEpseL8BLM4skClxr2kG2CRhgQiJWesbwDawCKhKtHdPAavhFbCUWHp6PiOE
	LSjxY/I9FoheLYn1O48zQdjyEpvXvIW6SEFix9nXjBC79CS2NJ1nhagRl9h45BbLBEaBWUhG
	zUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERzKz6R2MK5ssDjEKMDB
	qMTDGzEnNliINbGsuDL3EKMEB7OSCO9+ibhgId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHWq0D
	hQTSE0tSs1NTC1KLYLJMHJxSDYzFk6uE3/4tb1rTHjjDtHcyx9T3vw5K6RmlehYr7s86nfC/
	QCbqoumpsibbb5Xn9og4Xt+6/UdBZsmEyTdmT88NnpLX4COox/0ocMWqFddlIlkkj009IFb/
	63/Moa6dFx//sF+2eGZPN99lM6Uy+U03tz7vOLE8pPRb+X3Tyfbaf+NuXW+XP8SnxFKckWio
	xVxUnAgAQjnYG2ECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should set the error number correctly when we fail in recover_dentry(), so
the recover flow could stop for the reason as error number shows instead of
continuing.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/recovery.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index be1e3e8..e950a2f 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -75,7 +75,8 @@ retry:
 		einode = f2fs_iget(inode->i_sb, le32_to_cpu(de->ino));
 		if (IS_ERR(einode)) {
 			WARN_ON(1);
-			if (PTR_ERR(einode) == -ENOENT)
+			err = PTR_ERR(einode);
+			if (err == -ENOENT)
 				err = -EEXIST;
 			goto out_unmap_put;
 		}
-- 
1.7.9.5



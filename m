Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933957AbaCTOrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:47:40 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36593 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbaCTOrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:47:36 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, eddie.wai@broadcom.com,
        paulmck@linux.vnet.ibm.com
Subject: [PATCH 9/9] vhost: Replace rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL) in test.c
Date: Thu, 20 Mar 2014 20:16:42 +0530
Message-Id: <07dc03597c3779e18b0e402efd59c39eabc5bb57.1395324808.git.monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <649bfa7337b1aca38de9b1aa69f1d68e6c257a74.1395324808.git.monamagarwal123@gmail.com>
References: <649bfa7337b1aca38de9b1aa69f1d68e6c257a74.1395324808.git.monamagarwal123@gmail.com>
In-Reply-To: <cover.1395324808.git.monamagarwal123@gmail.com>
References: <cover.1395324808.git.monamagarwal123@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 drivers/vhost/test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index fc9a1d7..82b3744 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -128,7 +128,7 @@ static void *vhost_test_stop_vq(struct vhost_test *n,
 	mutex_lock(&vq->mutex);
 	private = rcu_dereference_protected(vq->private_data,
 					 lockdep_is_held(&vq->mutex));
-	rcu_assign_pointer(vq->private_data, NULL);
+	RCU_INIT_POINTER(vq->private_data, NULL);
 	mutex_unlock(&vq->mutex);
 	return private;
 }
-- 
1.7.9.5


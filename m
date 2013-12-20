Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab3LTMnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:43:24 -0500
Received: from mail09.linbit.com ([212.69.161.110]:38651 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab3LTMj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:39:27 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 01/26] drbd: Add missing error goto
Date: Fri, 20 Dec 2013 13:28:58 +0100
Message-Id: <1387542563-6833-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
References: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index c706d50..e75c6db 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1273,6 +1273,7 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	if (err && err != -ENOMSG) {
 		retcode = ERR_MANDATORY_TAG;
 		drbd_msg_put_info(from_attrs_err_to_txt(err));
+		goto fail_unlock;
 	}
 
 	if (!expect(new_disk_conf->resync_rate >= 1))
-- 
1.7.9.5


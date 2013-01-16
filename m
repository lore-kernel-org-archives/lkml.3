Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab3APRCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:02:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35883 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757452Ab3APQAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:00:46 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 052/222] iscsit: use GFP_ATOMIC under spin lock
Date: Wed, 16 Jan 2013 13:54:12 -0200
Message-Id: <1358351822-7675-53-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 3c989d7603872bf878840f7ce3ea49b73bea4c6c upstream.

The function iscsit_build_conn_drop_async_message() is called
from iscsit_close_connection() with spin lock 'sess->conn_lock'
held, so we should use GFP_ATOMIC instead of GFP_KERNEL.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/target/iscsi/iscsi_target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 65fc914..ac41f04 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -2382,7 +2382,7 @@ static void iscsit_build_conn_drop_async_message(struct iscsi_conn *conn)
 	if (!conn_p)
 		return;
 
-	cmd = iscsit_allocate_cmd(conn_p, GFP_KERNEL);
+	cmd = iscsit_allocate_cmd(conn_p, GFP_ATOMIC);
 	if (!cmd) {
 		iscsit_dec_conn_usage_count(conn_p);
 		return;
-- 
1.7.9.5


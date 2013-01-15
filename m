Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab3AOS7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:59:21 -0500
Received: from mail.kernel.org ([198.145.19.201]:34821 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757295Ab3AOS5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:57:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 039/221] iscsit: use GFP_ATOMIC under spin lock
Date: Tue, 15 Jan 2013 10:49:26 -0800
Message-Id: <20130115185000.851487671@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 3c989d7603872bf878840f7ce3ea49b73bea4c6c upstream.

The function iscsit_build_conn_drop_async_message() is called
from iscsit_close_connection() with spin lock 'sess->conn_lock'
held, so we should use GFP_ATOMIC instead of GFP_KERNEL.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -2360,7 +2360,7 @@ static void iscsit_build_conn_drop_async
 	if (!conn_p)
 		return;
 
-	cmd = iscsit_allocate_cmd(conn_p, GFP_KERNEL);
+	cmd = iscsit_allocate_cmd(conn_p, GFP_ATOMIC);
 	if (!cmd) {
 		iscsit_dec_conn_usage_count(conn_p);
 		return;



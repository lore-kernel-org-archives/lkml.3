Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab3AOWrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:47:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:45241 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932508Ab3AOWrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:47:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 021/171] iscsit: use GFP_ATOMIC under spin lock
Date: Tue, 15 Jan 2013 14:43:06 -0800
Message-Id: <20130115224314.935338808@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2359,7 +2359,7 @@ static void iscsit_build_conn_drop_async
 	if (!conn_p)
 		return;
 
-	cmd = iscsit_allocate_cmd(conn_p, GFP_KERNEL);
+	cmd = iscsit_allocate_cmd(conn_p, GFP_ATOMIC);
 	if (!cmd) {
 		iscsit_dec_conn_usage_count(conn_p);
 		return;



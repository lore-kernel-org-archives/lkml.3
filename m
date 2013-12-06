Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694Ab3LFUNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:13:40 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:54793 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758611Ab3LFUNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:13:35 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v4 net-next 4/4] tun: remove unused parameter in tun_do_read()
Date: Sat,  7 Dec 2013 04:13:06 +0800
Message-Id: <1386360786-17687-5-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1386360786-17687-1-git-send-email-zwu.kernel@gmail.com>
References: <1386360786-17687-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120620-9332-0000-0000-00000267B0EE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 drivers/net/tun.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 782e38b..f9c935a 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1289,8 +1289,7 @@ done:
 }
 
 static ssize_t tun_do_read(struct tun_struct *tun, struct tun_file *tfile,
-			   struct kiocb *iocb, const struct iovec *iv,
-			   ssize_t len, int noblock)
+			   const struct iovec *iv, ssize_t len, int noblock)
 {
 	DECLARE_WAITQUEUE(wait, current);
 	struct sk_buff *skb;
@@ -1353,7 +1352,7 @@ static ssize_t tun_chr_aio_read(struct kiocb *iocb, const struct iovec *iv,
 		goto out;
 	}
 
-	ret = tun_do_read(tun, tfile, iocb, iv, len,
+	ret = tun_do_read(tun, tfile, iv, len,
 			  file->f_flags & O_NONBLOCK);
 	ret = min_t(ssize_t, ret, len);
 out:
@@ -1452,7 +1451,7 @@ static int tun_recvmsg(struct kiocb *iocb, struct socket *sock,
 					 SOL_PACKET, TUN_TX_TIMESTAMP);
 		goto out;
 	}
-	ret = tun_do_read(tun, tfile, iocb, m->msg_iov, total_len,
+	ret = tun_do_read(tun, tfile, m->msg_iov, total_len,
 			  flags & MSG_DONTWAIT);
 	if (ret > total_len) {
 		m->msg_flags |= MSG_TRUNC;
-- 
1.7.6.5


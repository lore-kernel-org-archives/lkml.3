Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab3LFUzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:55:14 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:44308 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab3LFUzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:55:12 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 1/2] macvtap: remove useless codes in macvtap_aio_read() and macvtap_recvmsg()
Date: Sat,  7 Dec 2013 04:54:59 +0800
Message-Id: <1386363300-19040-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120620-1542-0000-0000-000003FC89C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

By checking related codes, it is impossible that ret > len or total_len,
so we should remove some useless coeds in both above functions.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 drivers/net/macvtap.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 4c6f84c..7f4ccdd 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -871,7 +871,6 @@ static ssize_t macvtap_aio_read(struct kiocb *iocb, const struct iovec *iv,
 	}
 
 	ret = macvtap_do_read(q, iv, len, file->f_flags & O_NONBLOCK);
-	ret = min_t(ssize_t, ret, len); /* XXX copied from tun.c. Why? */
 out:
 	return ret;
 }
@@ -1104,10 +1103,6 @@ static int macvtap_recvmsg(struct kiocb *iocb, struct socket *sock,
 		return -EINVAL;
 	ret = macvtap_do_read(q, m->msg_iov, total_len,
 			  flags & MSG_DONTWAIT);
-	if (ret > total_len) {
-		m->msg_flags |= MSG_TRUNC;
-		ret = flags & MSG_TRUNC ? ret : total_len;
-	}
 	return ret;
 }
 
-- 
1.7.6.5


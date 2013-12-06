Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab3LFGUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 01:20:20 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38900 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab3LFGUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 01:20:14 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [net-next PATCH v3 5/6] macvtap: remove unused parameter in macvtap_do_read()
Date: Fri,  6 Dec 2013 14:19:41 +0800
Message-Id: <1386310782-9378-6-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1386310782-9378-1-git-send-email-zwu.kernel@gmail.com>
References: <1386310782-9378-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120606-7182-0000-0000-0000094862D4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 drivers/net/macvtap.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index f599c47..4c6f84c 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -819,7 +819,7 @@ done:
 	return ret ? ret : copied;
 }
 
-static ssize_t macvtap_do_read(struct macvtap_queue *q, struct kiocb *iocb,
+static ssize_t macvtap_do_read(struct macvtap_queue *q,
 			       const struct iovec *iv, unsigned long len,
 			       int noblock)
 {
@@ -870,7 +870,7 @@ static ssize_t macvtap_aio_read(struct kiocb *iocb, const struct iovec *iv,
 		goto out;
 	}
 
-	ret = macvtap_do_read(q, iocb, iv, len, file->f_flags & O_NONBLOCK);
+	ret = macvtap_do_read(q, iv, len, file->f_flags & O_NONBLOCK);
 	ret = min_t(ssize_t, ret, len); /* XXX copied from tun.c. Why? */
 out:
 	return ret;
@@ -1102,7 +1102,7 @@ static int macvtap_recvmsg(struct kiocb *iocb, struct socket *sock,
 	int ret;
 	if (flags & ~(MSG_DONTWAIT|MSG_TRUNC))
 		return -EINVAL;
-	ret = macvtap_do_read(q, iocb, m->msg_iov, total_len,
+	ret = macvtap_do_read(q, m->msg_iov, total_len,
 			  flags & MSG_DONTWAIT);
 	if (ret > total_len) {
 		m->msg_flags |= MSG_TRUNC;
-- 
1.7.6.5


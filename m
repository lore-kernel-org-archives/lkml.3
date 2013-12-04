Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab3LDJ3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:29:21 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60366 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab3LDJ3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:29:17 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 2/2] macvtap: remove unused paramter in macvtap_do_read()
Date: Wed,  4 Dec 2013 17:29:01 +0800
Message-Id: <1386149341-10485-2-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1386149341-10485-1-git-send-email-zwu.kernel@gmail.com>
References: <1386149341-10485-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120409-0320-0000-0000-000001E2DB07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 drivers/net/macvtap.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 957cc5c..c0d412e 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -823,7 +823,7 @@ done:
 	return ret ? ret : copied;
 }
 
-static ssize_t macvtap_do_read(struct macvtap_queue *q, struct kiocb *iocb,
+static ssize_t macvtap_do_read(struct macvtap_queue *q,
 			       const struct iovec *iv, unsigned long len,
 			       int noblock)
 {
@@ -874,7 +874,7 @@ static ssize_t macvtap_aio_read(struct kiocb *iocb, const struct iovec *iv,
 		goto out;
 	}
 
-	ret = macvtap_do_read(q, iocb, iv, len, file->f_flags & O_NONBLOCK);
+	ret = macvtap_do_read(q, iv, len, file->f_flags & O_NONBLOCK);
 	ret = min_t(ssize_t, ret, len); /* XXX copied from tun.c. Why? */
 	if (ret > 0)
 		iocb->ki_pos = ret;
@@ -1108,7 +1108,7 @@ static int macvtap_recvmsg(struct kiocb *iocb, struct socket *sock,
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


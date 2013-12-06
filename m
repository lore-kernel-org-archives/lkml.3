Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab3LFUzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:55:21 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:53620 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab3LFUzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:55:17 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 2/2] tun: remove useless codes in tun_chr_aio_read() and tun_recvmsg()
Date: Sat,  7 Dec 2013 04:55:00 +0800
Message-Id: <1386363300-19040-2-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1386363300-19040-1-git-send-email-zwu.kernel@gmail.com>
References: <1386363300-19040-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120620-7164-0000-0000-00000403CD05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

By checking related codes, it is impossible that ret > len or total_len,
so we should remove some useless codes in both above functions.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 drivers/net/tun.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index f9c935a..d61719c 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1354,7 +1354,6 @@ static ssize_t tun_chr_aio_read(struct kiocb *iocb, const struct iovec *iv,
 
 	ret = tun_do_read(tun, tfile, iv, len,
 			  file->f_flags & O_NONBLOCK);
-	ret = min_t(ssize_t, ret, len);
 out:
 	tun_put(tun);
 	return ret;
@@ -1453,10 +1452,6 @@ static int tun_recvmsg(struct kiocb *iocb, struct socket *sock,
 	}
 	ret = tun_do_read(tun, tfile, m->msg_iov, total_len,
 			  flags & MSG_DONTWAIT);
-	if (ret > total_len) {
-		m->msg_flags |= MSG_TRUNC;
-		ret = flags & MSG_TRUNC ? ret : total_len;
-	}
 out:
 	tun_put(tun);
 	return ret;
-- 
1.7.6.5


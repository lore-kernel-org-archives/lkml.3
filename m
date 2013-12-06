Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab3LFJJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:09:11 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:45500 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab3LFJJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:09:01 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v2 1/2] macvtap: update file current position
Date: Fri,  6 Dec 2013 17:08:49 +0800
Message-Id: <1386320930-11285-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120609-3532-0000-0000-0000039A9C2C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 drivers/net/macvtap.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 9093004..e6e2dd6 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -876,6 +876,8 @@ static ssize_t macvtap_aio_read(struct kiocb *iocb, const struct iovec *iv,
 
 	ret = macvtap_do_read(q, iocb, iv, len, file->f_flags & O_NONBLOCK);
 	ret = min_t(ssize_t, ret, len); /* XXX copied from tun.c. Why? */
+	if (ret > 0)
+		iocb->ki_pos += ret;
 out:
 	return ret;
 }
-- 
1.7.6.5


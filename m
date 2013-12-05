Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab3LEW3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 17:29:25 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:35940 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab3LEW3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 17:29:16 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [net-next PATCH 5/6] macvtap: update file current position
Date: Fri,  6 Dec 2013 06:28:46 +0800
Message-Id: <1386282527-14094-6-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1386282527-14094-1-git-send-email-zwu.kernel@gmail.com>
References: <1386282527-14094-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120522-0928-0000-0000-0000042039CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 drivers/net/macvtap.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index f599c47..4914d85 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -872,6 +872,8 @@ static ssize_t macvtap_aio_read(struct kiocb *iocb, const struct iovec *iv,
 
 	ret = macvtap_do_read(q, iocb, iv, len, file->f_flags & O_NONBLOCK);
 	ret = min_t(ssize_t, ret, len); /* XXX copied from tun.c. Why? */
+	if (ret > 0)
+		iocb->ki_pos = ret;
 out:
 	return ret;
 }
-- 
1.7.6.5


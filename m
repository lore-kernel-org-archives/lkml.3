Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaAMOkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:40:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51544 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbaAMO0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:26:51 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 77/96] macvtap: update file current position
Date: Mon, 13 Jan 2014 14:24:40 +0000
Message-Id: <1389623099-18783-78-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

commit e6ebc7f16ca1434a334647aa56399c546be4e64b upstream.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/macvtap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 81fbe78a..b614ab4 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -906,6 +906,8 @@ static ssize_t macvtap_aio_read(struct kiocb *iocb, const struct iovec *iv,
 
 	ret = macvtap_do_read(q, iocb, iv, len, file->f_flags & O_NONBLOCK);
 	ret = min_t(ssize_t, ret, len); /* XXX copied from tun.c. Why? */
+	if (ret > 0)
+		iocb->ki_pos = ret;
 out:
 	return ret;
 }
-- 
1.8.3.2


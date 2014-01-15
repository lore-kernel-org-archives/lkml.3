Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaAOV5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:57:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40985 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbaAOV53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:57:29 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 143/166] tun: update file current position
Date: Wed, 15 Jan 2014 13:52:37 -0800
Message-Id: <1389822780-4729-144-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

[ Upstream commit d0b7da8afa079ffe018ab3e92879b7138977fc8f ]

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/tun.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 1bff29f..7882545 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1410,6 +1410,8 @@ static ssize_t tun_chr_aio_read(struct kiocb *iocb, const struct iovec *iv,
 	ret = tun_do_read(tun, tfile, iocb, iv, len,
 			  file->f_flags & O_NONBLOCK);
 	ret = min_t(ssize_t, ret, len);
+	if (ret > 0)
+		iocb->ki_pos = ret;
 out:
 	tun_put(tun);
 	return ret;
-- 
1.8.3.2


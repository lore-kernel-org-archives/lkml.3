Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab3LFGRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 01:17:13 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:46102 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab3LFGRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 01:17:08 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 2/2] tun: update file current position
Date: Fri,  6 Dec 2013 14:16:51 +0800
Message-Id: <1386310611-9294-2-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1386310611-9294-1-git-send-email-zwu.kernel@gmail.com>
References: <1386310611-9294-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120606-8236-0000-0000-00000499C0CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 drivers/net/tun.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 782e38b..e26cbea 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1356,6 +1356,8 @@ static ssize_t tun_chr_aio_read(struct kiocb *iocb, const struct iovec *iv,
 	ret = tun_do_read(tun, tfile, iocb, iv, len,
 			  file->f_flags & O_NONBLOCK);
 	ret = min_t(ssize_t, ret, len);
+	if (ret > 0)
+		iocb->ki_pos = ret;
 out:
 	tun_put(tun);
 	return ret;
-- 
1.7.6.5


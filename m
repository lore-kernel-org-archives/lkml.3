Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab3G3Sr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:47:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56607 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757328Ab3G3Srz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:47:55 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ding Tianhong <dingtianhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 68/75] ifb: fix oops when loading the ifb failed
Date: Tue, 30 Jul 2013 11:45:12 -0700
Message-Id: <1375209919-1768-35-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: dingtianhong <dingtianhong@huawei.com>

[ Upstream commit f2966cd5691058b8674a20766525bedeaea9cbcf ]

If __rtnl_link_register() return faild when loading the ifb, it will
take the wrong path and get oops, so fix it just like dummy.

Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ifb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 04ab337..635d01c 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -290,6 +290,8 @@ static int __init ifb_init_module(void)
 
 	rtnl_lock();
 	err = __rtnl_link_register(&ifb_link_ops);
+	if (err < 0)
+		goto out;
 
 	for (i = 0; i < numifbs && !err; i++) {
 		err = ifb_init_one(i);
@@ -297,6 +299,8 @@ static int __init ifb_init_module(void)
 	}
 	if (err)
 		__rtnl_link_unregister(&ifb_link_ops);
+
+out:
 	rtnl_unlock();
 
 	return err;
-- 
1.8.1.2


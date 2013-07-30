Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab3G3Jq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:46:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53212 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425Ab3G3JdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ding Tianhong <dingtianhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 061/106] ifb: fix oops when loading the ifb failed
Date: Tue, 30 Jul 2013 10:31:20 +0100
Message-Id: <1375176725-5825-62-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: dingtianhong <dingtianhong@huawei.com>

commit f2966cd5691058b8674a20766525bedeaea9cbcf upstream.

If __rtnl_link_register() return faild when loading the ifb, it will
take the wrong path and get oops, so fix it just like dummy.

Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.8.3.2


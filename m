Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab3IKEan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:30:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22641 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab3IKE3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:06 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=vvYQHAZVu7AA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=6XT-T4it1rMA:10 a=i0EeH86SAAAA:8 a=J1Y8HTJGAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=hPjdaMEvmhQA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042901.189678377@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ding Tianhong <dingtianhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [053/251] ifb: fix oops when loading the ifb failed
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0053-ifb-fix-oops-when-loading-the-ifb-failed.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: dingtianhong <dingtianhong@huawei.com>

[ Upstream commit f2966cd5691058b8674a20766525bedeaea9cbcf ]

If __rtnl_link_register() return faild when loading the ifb, it will
take the wrong path and get oops, so fix it just like dummy.

Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ifb.c |    4 ++++
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
1.7.10.4



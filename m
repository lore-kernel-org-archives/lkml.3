Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760534Ab3GZVSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:18:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933Ab3GZUxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:53:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ding Tianhong <dingtianhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 38/59] ifb: fix oops when loading the ifb failed
Date: Fri, 26 Jul 2013 13:53:02 -0700
Message-Id: <20130726205017.901095991@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726205013.795696531@linuxfoundation.org>
References: <20130726205013.795696531@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: dingtianhong <dingtianhong@huawei.com>

[ Upstream commit f2966cd5691058b8674a20766525bedeaea9cbcf ]

If __rtnl_link_register() return faild when loading the ifb, it will
take the wrong path and get oops, so fix it just like dummy.

Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ifb.c |    4 ++++
 1 file changed, 4 insertions(+)

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



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936356Ab3DKVVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:21:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16517 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935446Ab3DKUsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:51 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=NI5NXAJ_a9wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=tETo8_kHws8A:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=_ta70gb3Xz5DamlNlo0A:9 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202611.363753279@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Masatake YAMATO <yamato@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 153/171 ] genetlink: trigger BUG_ON if a group name is too long
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0153-genetlink-trigger-BUG_ON-if-a-group-name-is-too-long.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Masatake YAMATO <yamato@redhat.com>

[ Upstream commit f1e79e208076ffe7bad97158275f1c572c04f5c7 ]

Trigger BUG_ON if a group name is longer than GENL_NAMSIZ.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/netlink/genetlink.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index fda4974..42556ce 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -142,6 +142,7 @@ int genl_register_mc_group(struct genl_family *family,
 	int err = 0;
 
 	BUG_ON(grp->name[0] == '\0');
+	BUG_ON(memchr(grp->name, '\0', GENL_NAMSIZ) == NULL);
 
 	genl_lock();
 
-- 
1.7.10.4



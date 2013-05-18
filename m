Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab3ERDLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:11:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8107 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758728Ab3ERDAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:19 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Clw8zQFb8xAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=AiAv-u-PTuwA:10 a=wQna4SzfnuMCKa8ocsYA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021657.595880148@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ 099/136 ] netfilter: ipset: "Directory not empty" error message
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0099-netfilter-ipset-Directory-not-empty-error-message.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

[ Upstream commit dd82088dab3646ed28e4aa43d1a5b5d5ffc2afba ]

When an entry flagged with "nomatch" was tested by ipset, it
returned the error message "Kernel error received:
Directory not empty" instead of "<element> is NOT in set <setname>"
(reported by John Brendler).

The internal error code was not properly transformed before returning
to userspace, fixed.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/netfilter/ipset/ip_set_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 9730882..eaabc58 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1387,7 +1387,8 @@ ip_set_utest(struct sock *ctnl, struct sk_buff *skb,
 	if (ret == -EAGAIN)
 		ret = 1;
 
-	return ret < 0 ? ret : ret > 0 ? 0 : -IPSET_ERR_EXIST;
+	return (ret < 0 && ret != -ENOTEMPTY) ? ret :
+		ret > 0 ? 0 : -IPSET_ERR_EXIST;
 }
 
 /* Get headed data of a set */
-- 
1.7.10.4



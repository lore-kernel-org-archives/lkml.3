Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab3CZRgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:36:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31989 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab3CZRgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:14 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=242rhhkj33oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=mbU9xA1Yv7MA:10 a=fTkJtSSaAAAA:8 a=J1Y8HTJGAAAA:8 a=NzRHrjxl2qcKz10ZyG0A:9 a=9YC585TfOj4A:10 a=4N9Db7Z2_RYA:10 a=qIXnUxh24Sidp-ev:21 a=9Vzt3phcxU_sP6CV:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173605.217833672@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sarveshwar Bandi <sarveshwar.bandi@emulex.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 33/86] bridge: Pull ip header into skb->data before looking into ip header.
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0033-bridge-Pull-ip-header-into-skb-data-before-looking-i.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sarveshwar Bandi <sarveshwar.bandi@emulex.com>

[ Upstream commit 6caab7b0544e83e6c160b5e80f5a4a7dd69545c7 ]

If lower layer driver leaves the ip header in the skb fragment, it needs to
be first pulled into skb->data before inspecting ip header length or ip version
number.

Signed-off-by: Sarveshwar Bandi <sarveshwar.bandi@emulex.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/bridge/br_netfilter.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 68e8f36..fe43bc7 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -265,6 +265,9 @@ static int br_parse_ip_options(struct sk_buff *skb)
 	struct net_device *dev = skb->dev;
 	u32 len;
 
+	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+		goto inhdr_error;
+
 	iph = ip_hdr(skb);
 	opt = &(IPCB(skb)->opt);
 
-- 
1.7.10.4



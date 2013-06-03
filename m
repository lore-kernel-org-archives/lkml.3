Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488Ab3FCWQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:16:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32917 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758984Ab3FCWMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:23 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=9Xj-3rIJt8AA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=JNVLLR7WruIA:10 a=40MIqcmNAAAA:8 a=J1Y8HTJGAAAA:8 a=u6Kjp6XQMGfe5Rn6x1sA:9 a=-tENaG0q7zQA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221157.720285357@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Chen Gang <gang.chen@asianux.com>, "David S. Miller" <davem@davemloft.net>
Subject: [31/65] net: mac802154: comparision issue of type cast, finding by
 EXTRA_CFLAGS=-W
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0031-net-mac802154-comparision-issue-of-type-cast-finding.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Chen Gang <gang.chen@asianux.com>

[ Upstream commit 2c1bbbffa0b644fab4f91878cde0c2e8f52e2dcc ]

Change MAC802154_CHAN_NONE from ~(u8)0 to 0xff, or the comparison in
mac802154_wpan_xmit() for ``chan == MAC802154_CHAN_NONE'' will not
succeed.

This bug can be boiled down to ``u8 foo = 0xff; if (foo == ~(u8)0)
[...] else [...]'' where the condition will always take the else
branch.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/mac802154/mac802154.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac802154/mac802154.h b/net/mac802154/mac802154.h
index a4dcaf1..703c121 100644
--- a/net/mac802154/mac802154.h
+++ b/net/mac802154/mac802154.h
@@ -90,7 +90,7 @@ struct mac802154_sub_if_data {
 
 #define MAC802154_MAX_XMIT_ATTEMPTS	3
 
-#define MAC802154_CHAN_NONE		(~(u8)0) /* No channel is assigned */
+#define MAC802154_CHAN_NONE		0xff /* No channel is assigned */
 
 extern struct ieee802154_reduced_mlme_ops mac802154_mlme_reduced;
 extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
-- 
1.7.10.4



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab3EQVhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:37:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943Ab3EQVhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chen Gang <gang.chen@asianux.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 057/102] net: mac802154: comparision issue of type cast, finding by EXTRA_CFLAGS=-W
Date: Fri, 17 May 2013 14:36:12 -0700
Message-Id: <20130517213250.367511804@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac802154/mac802154.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac802154/mac802154.h
+++ b/net/mac802154/mac802154.h
@@ -90,7 +90,7 @@ struct mac802154_sub_if_data {
 
 #define MAC802154_MAX_XMIT_ATTEMPTS	3
 
-#define MAC802154_CHAN_NONE		(~(u8)0) /* No channel is assigned */
+#define MAC802154_CHAN_NONE		0xff /* No channel is assigned */
 
 extern struct ieee802154_reduced_mlme_ops mac802154_mlme_reduced;
 extern struct ieee802154_mlme_ops mac802154_mlme_wpan;



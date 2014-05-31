Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbaEaQon (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 12:44:43 -0400
Received: from mout.gmx.net ([212.227.17.21]:52627 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154AbaEaQol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 12:44:41 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: davem@davemloft.net
Cc: jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] dns_resolver: Do not accept domain names longer than 255 chars
Date: Sat, 31 May 2014 18:44:33 +0200
Message-Id: <1401554673-16311-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:C+LP4s1e+wKcRwW1fMaxiFEFtR8fVKHa+wLL3Tm4LRV8nh4FT9S
 IgBqGox+3IsU8heetGssEUaywvryGrdEbZSA/GtKtjldh4MGxLZTJOmgKIfsthmLEQkWR/T
 TBprelSqEbv7RfC/ZNjca9vtQW27vwzsZE4n7zBDoTsf//bkOtAVzvYaMu/U5KKB2JPTPDk
 TVPRdpvQaInoNwUZE6jwQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to RFC1035 "[...] the total length of a domain name (i.e.,
label octets and label length octets) is restricted to 255 octets or
less."

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 net/dns_resolver/dns_query.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
index e7b6d53..e0fde29 100644
--- a/net/dns_resolver/dns_query.c
+++ b/net/dns_resolver/dns_query.c
@@ -94,7 +94,7 @@ int dns_query(const char *type, const char *name, size_t namelen,
 
 	if (!namelen)
 		namelen = strlen(name);
-	if (namelen < 3)
+	if (namelen < 3 || namelen > 255)
 		return -EINVAL;
 	desclen += namelen + 1;
 
-- 
1.7.10.4


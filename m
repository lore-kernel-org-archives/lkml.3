Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaFGV6M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 17:58:12 -0400
Received: from mout.gmx.net ([212.227.15.18]:62194 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366AbaFGV5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 17:57:34 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: davem@davemloft.net
Cc: jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH v3] dns_resolver: assure that dns_query() result is null-terminated
Date: Sat,  7 Jun 2014 23:57:25 +0200
Message-Id: <1402178245-8076-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402167681-24676-1-git-send-email-manuel.schoelling@gmx.de>
References: <1402167681-24676-1-git-send-email-manuel.schoelling@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:/8wYx1zmyEz/rVw22E3qRc/Jcf1JBwIrugroPd9mj4SQiOOxy9d
 i25d+pW1G5D1hCPQxG9/Zg7IB5oyuxTh7WNsVB8bvagCx0/GZbhrYtaXEYZH2+1F9rIuftS
 kI3+GRA+lUj22jcmSuDP6GtVyDAHOOIhQlJjUbJxYSQAE/E3k6OPa+ZsgJZcpAk7riTCzVk
 +J3vEs/F0EXHDPxb8S9wQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dns_query() credulously assumes that keys are null-terminated and
returns a copy of a memory block that is off by one.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 net/dns_resolver/dns_query.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
index e7b6d53..6853d22 100644
--- a/net/dns_resolver/dns_query.c
+++ b/net/dns_resolver/dns_query.c
@@ -149,7 +149,9 @@ int dns_query(const char *type, const char *name, size_t namelen,
 	if (!*_result)
 		goto put;
 
-	memcpy(*_result, upayload->data, len + 1);
+	memcpy(*_result, upayload->data, len);
+	*_result[len] = '\0';
+
 	if (_expiry)
 		*_expiry = rkey->expiry;
 
-- 
1.7.10.4


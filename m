Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbaHHUqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:46:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40427 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757869AbaHHUqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:46:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 258/259] dns_resolver: Null-terminate the right string
Date: Fri,  8 Aug 2014 13:41:21 -0700
Message-Id: <1407530482-4483-259-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

[ Upstream commit 640d7efe4c08f06c4ae5d31b79bd8740e7f6790a ]

*_result[len] is parsed as *(_result[len]) which is not at all what we
want to touch here.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Fixes: 84a7c0b1db1c ("dns_resolver: assure that dns_query() result is null-terminated")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/dns_resolver/dns_query.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
index ede0e2d..2022b46 100644
--- a/net/dns_resolver/dns_query.c
+++ b/net/dns_resolver/dns_query.c
@@ -151,7 +151,7 @@ int dns_query(const char *type, const char *name, size_t namelen,
 		goto put;
 
 	memcpy(*_result, upayload->data, len);
-	*_result[len] = '\0';
+	(*_result)[len] = '\0';
 
 	if (_expiry)
 		*_expiry = rkey->expiry;
-- 
1.9.1


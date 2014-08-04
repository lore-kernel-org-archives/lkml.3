Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbaHDREe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:04:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56532 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751914AbaHDQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.445384128@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 62/94] dns_resolver: Null-terminate the right string
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

[ Upstream commit 640d7efe4c08f06c4ae5d31b79bd8740e7f6790a ]

*_result[len] is parsed as *(_result[len]) which is not at all what we
want to touch here.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Fixes: 84a7c0b1db1c ("dns_resolver: assure that dns_query() result is null-terminated")
Signed-off-by: David S. Miller <davem@davemloft.net>
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


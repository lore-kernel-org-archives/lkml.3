Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbaHDRE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:04:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56538 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751944AbaHDQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "=?UTF-8?q?Manuel=20Sch=C3=B6lling?=" <manuel.schoelling@gmx.de>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.416070207@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 61/94] dns_resolver: assure that dns_query() result is
  null-terminated
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Manuel Schölling <manuel.schoelling@gmx.de>

[ Upstream commit 84a7c0b1db1c17d5ded8d3800228a608e1070b40 ]

dns_query() credulously assumes that keys are null-terminated and
returns a copy of a memory block that is off by one.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/dns_resolver/dns_query.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
index c32be29..ede0e2d 100644
--- a/net/dns_resolver/dns_query.c
+++ b/net/dns_resolver/dns_query.c
@@ -150,7 +150,9 @@ int dns_query(const char *type, const char *name, size_t namelen,
 	if (!*_result)
 		goto put;
 
-	memcpy(*_result, upayload->data, len + 1);
+	memcpy(*_result, upayload->data, len);
+	*_result[len] = '\0';
+
 	if (_expiry)
 		*_expiry = rkey->expiry;
 


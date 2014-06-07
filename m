Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaFGR5D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 13:57:03 -0400
Received: from mout.gmx.net ([212.227.15.19]:52851 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbaFGR5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 13:57:01 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: davem@davemloft.net
Cc: jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] dns_resolver: assure that dns_query() result is null-terminated
Date: Sat,  7 Jun 2014 19:56:51 +0200
Message-Id: <1402163811-21604-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
X-Provags-ID: V03:K0:jcGLdxDeFMvN0DBZp4SaQBb6l+xPZWdsg9RuldVCvgtU8HfCKQY
 AI11oS873/XzzyytUPBQ2Jupgae9WrJk4I3PkgmwF0+BLoGAVbFN9N4nnYFNTuG0UNVmyI9
 6BuKzHxJ3Q2dULglxNrbUuXRxjw3wbiDyjgLS/erSnZ0VWo2itpT+oyWmCy5SF/RctE0NTO
 EQndduSu++gBwigpfFALg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dns_query() credulously assumes that keys are null-terminated and
returns a copy of a memory block that is off by one.
---
 net/dns_resolver/dns_query.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
index e7b6d53..53be635 100644
--- a/net/dns_resolver/dns_query.c
+++ b/net/dns_resolver/dns_query.c
@@ -149,7 +149,9 @@ int dns_query(const char *type, const char *name, size_t namelen,
 	if (!*_result)
 		goto put;
 
-	memcpy(*_result, upayload->data, len + 1);
+	memcpy(*_result, upayload->data, len);
+	*_result[len+1] = '\0';
+
 	if (_expiry)
 		*_expiry = rkey->expiry;
 
-- 
1.7.10.4


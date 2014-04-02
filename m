Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458AbaDBU3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:29:51 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42808 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758822AbaDBUN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexander Aring <alex.aring@gmail.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 12/40] nfs: fix dead code of ipv6_addr_scope
Date: Wed,  2 Apr 2014 22:12:58 +0200
Message-Id: <72e436e421d5f30533128c10c9e9711b2d991070.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Aring <alex.aring@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a8c2275493b866961f4429a741251c630c4fc6d7 upstream.

The correct way to check on IPV6_ADDR_SCOPE_LINKLOCAL is to check with
the ipv6_addr_src_scope function.

Currently this can't be work, because ipv6_addr_scope returns a int with
a mask of IPV6_ADDR_SCOPE_MASK (0x00f0U) and IPV6_ADDR_SCOPE_LINKLOCAL
is 0x02. So the condition is always false.

Signed-off-by: Alexander Aring <alex.aring@gmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfs/nfs4filelayoutdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4filelayoutdev.c b/fs/nfs/nfs4filelayoutdev.c
index c7c295e556ed..efac602edb37 100644
--- a/fs/nfs/nfs4filelayoutdev.c
+++ b/fs/nfs/nfs4filelayoutdev.c
@@ -95,7 +95,7 @@ same_sockaddr(struct sockaddr *addr1, struct sockaddr *addr2)
 		b6 = (struct sockaddr_in6 *)addr2;
 
 		/* LINKLOCAL addresses must have matching scope_id */
-		if (ipv6_addr_scope(&a6->sin6_addr) ==
+		if (ipv6_addr_src_scope(&a6->sin6_addr) ==
 		    IPV6_ADDR_SCOPE_LINKLOCAL &&
 		    a6->sin6_scope_id != b6->sin6_scope_id)
 			return false;
-- 
1.9.1


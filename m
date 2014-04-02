Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176AbaDBUO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:14:57 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42885 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758944AbaDBUNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Adamson <andros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 10/40] SUNRPC: do not fail gss proc NULL calls with EACCES
Date: Wed,  2 Apr 2014 22:12:56 +0200
Message-Id: <4772f72d236431ca59999a5a5b37d429a5c34bcb.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Adamson <andros@netapp.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c297c8b99b07f496ff69a719cfb8e8fe852832ed upstream.

Otherwise RPCSEC_GSS_DESTROY messages are not sent.

Signed-off-by: Andy Adamson <andros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/sunrpc/auth_gss/auth_gss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index a7f9821d1760..bb035f8451c6 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -1508,7 +1508,7 @@ out:
 static int
 gss_refresh_null(struct rpc_task *task)
 {
-	return -EACCES;
+	return 0;
 }
 
 static __be32 *
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab3IZCtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:49:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57052 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753864Ab3IZCtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:49:08 -0400
X-IronPort-AV: E=Sophos;i="4.90,982,1371052800"; 
   d="scan'208";a="8624608"
Message-ID: <5243A058.2090104@cn.fujitsu.com>
Date: Thu, 26 Sep 2013 10:47:52 +0800
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: sds@tycho.nsa.gov, james.l.morris@oracle.com, eparis@parisplace.org
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] selinux: Use kmemdup instead of kmalloc + memcpy
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/26 10:47:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/26 10:47:20,
	Serialize complete at 2013/09/26 10:47:20
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 security/selinux/xfrm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index 425b9f9..5c809c1 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -268,10 +268,10 @@ int selinux_xfrm_policy_clone(struct xfrm_sec_ctx *old_ctx,
 	if (!old_ctx)
 		return 0;
 
-	new_ctx = kmalloc(sizeof(*old_ctx) + old_ctx->ctx_len, GFP_ATOMIC);
+	new_ctx = kmemdup(old_ctx, sizeof(*old_ctx) + old_ctx->ctx_len,
+			GFP_ATOMIC);
 	if (!new_ctx)
 		return -ENOMEM;
-	memcpy(new_ctx, old_ctx, sizeof(*old_ctx) + old_ctx->ctx_len);
 	atomic_inc(&selinux_xfrm_refcount);
 	*new_ctxp = new_ctx;
 
-- 
1.8.3.1

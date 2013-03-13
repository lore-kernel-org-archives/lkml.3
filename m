Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934110Ab3CMTBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:01:09 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:55676 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236Ab3CMTBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:01:07 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] arch: s390: net: Replaced kmalloc and memset with kzalloc
Date: Wed, 13 Mar 2013 20:59:17 +0200
Message-Id: <1363201157-17545-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used kzalloc instead of kmalloc followed by memset with 0.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 arch/s390/net/bpf_jit_comp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 0972e91..e645528 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -747,10 +747,9 @@ void bpf_jit_compile(struct sk_filter *fp)
 
 	if (!bpf_jit_enable)
 		return;
-	addrs = kmalloc(fp->len * sizeof(*addrs), GFP_KERNEL);
+	addrs = kzalloc(fp->len * sizeof(*addrs), GFP_KERNEL);
 	if (addrs == NULL)
 		return;
-	memset(addrs, 0, fp->len * sizeof(*addrs));
 	memset(&jit, 0, sizeof(cjit));
 	memset(&cjit, 0, sizeof(cjit));
 
-- 
1.7.9.5


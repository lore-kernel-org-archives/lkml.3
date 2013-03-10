Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab3CJNNm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 09:13:42 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:56668 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3CJNNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 09:13:40 -0400
From: Stelian Nirlu <steliannirlu@gmail.com>
To: schwidefsky@de.ibm.com
Cc: heiko.carstens@de.ibm.com, linux390@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stelian Nirlu <steliannirlu@gmail.com>
Subject: [PATCH] s390: replace kmalloc + memset with kzalloc
Date: Sun, 10 Mar 2013 15:13:25 +0200
Message-Id: <1362921205-10295-1-git-send-email-steliannirlu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stelian Nirlu <steliannirlu@gmail.com>
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
1.7.10.4


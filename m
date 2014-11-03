Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaKCIQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:16:27 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42164 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535AbaKCIMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:12:32 -0500
X-Sasl-enc: oVMoWobqz3M5kbjqEB6rOToqRudq+57WYjnAcfSIs4Wy 1415002351
Subject: [PATCH 03/13] autofs4 - use pr print in AUTOFS prints
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 03 Nov 2014 16:12:29 +0800
Message-ID: <20141103081229.6215.69137.stgit@perseus.themaw.net>
In-Reply-To: <20141103081218.6215.85903.stgit@perseus.themaw.net>
References: <20141103081218.6215.85903.stgit@perseus.themaw.net>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the pr_*() print in AUTOFS_*() defines instead of printks.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/autofs4/autofs_i.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 0a1fcdc..b33b939 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -41,11 +41,11 @@
 		current->pid, __func__, ##__VA_ARGS__)
 
 #define AUTOFS_WARN(fmt, ...)				\
-	printk(KERN_WARNING "pid %d: %s: " fmt "\n",	\
+	pr_warn("pid %d: %s: " fmt "\n",	\
 		current->pid, __func__, ##__VA_ARGS__)
 
 #define AUTOFS_ERROR(fmt, ...)				\
-	printk(KERN_ERR "pid %d: %s: " fmt "\n",	\
+	pr_err("pid %d: %s: " fmt "\n",	\
 		current->pid, __func__, ##__VA_ARGS__)
 
 /*


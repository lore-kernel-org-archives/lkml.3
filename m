Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbaEQPOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 11:14:33 -0400
Received: from mout.gmx.net ([212.227.15.15]:55542 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbaEQPOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 11:14:32 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] fs: FAT: Cleanup string initializations (char[] instead of char *)
Date: Sat, 17 May 2014 17:14:25 +0200
Message-Id: <1400339665-22321-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:dX8lkfHLhibdOW3s+KtxlPq0qCHWFcWuguugT4piH9uQDZcOtxS
 KuekgqbPBT9FtVnuTpFijUTuRDdz1Pq5sLsoArYh/9AdE0iglmM90gkxdm7KfjaXISOB8s1
 8IOGHTzqVlqR8D16dyfPv4Yn1/v7kDTfx4+ebwanR0tpUeOQXlPVWH3etvkAun95Wg2Blue
 FNCgy3L1f2h6UPGlMeC0g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initializations like 'char *foo = "bar"' will create two variables: a static
string and a pointer (foo) to that static string. Instead 'char foo[] = "bar"'
will declare a single variable and will end up in shorter
assembly (according to Jeff Garzik on the KernelJanitor's TODO list).

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 fs/fat/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index b3361fe..8b7d00e 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -359,7 +359,7 @@ struct inode *fat_iget(struct super_block *sb, loff_t i_pos)
 
 static int is_exec(unsigned char *extension)
 {
-	unsigned char *exe_extensions = "EXECOMBAT", *walk;
+	unsigned char exe_extensions[] = "EXECOMBAT", *walk;
 
 	for (walk = exe_extensions; *walk; walk += 3)
 		if (!strncmp(extension, walk, 3))
-- 
1.7.10.4


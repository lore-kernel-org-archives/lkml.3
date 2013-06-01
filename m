Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab3FAKAN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 06:00:13 -0400
Received: from www17.your-server.de ([213.133.104.17]:33284 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599Ab3FAJ75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:59:57 -0400
Message-ID: <1370080791.29224.40.camel@localhost.localdomain>
Subject: [PATCH] [S390] hypfs: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:59:51 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/arch/s390/hypfs/hypfs_diag.c b/arch/s390/hypfs/hypfs_diag.c
--- a/arch/s390/hypfs/hypfs_diag.c
+++ b/arch/s390/hypfs/hypfs_diag.c
@@ -651,9 +651,7 @@ static int hypfs_create_cpu_files(struct
 	}
 	diag224_idx2name(cpu_info__ctidx(diag204_info_type, cpu_info), buffer);
 	rc = hypfs_create_str(sb, cpu_dir, "type", buffer);
-	if (IS_ERR(rc))
-		return PTR_ERR(rc);
-	return 0;
+	return PTR_RET(rc);
 }
 
 static void *hypfs_create_lpar_files(struct super_block *sb,
@@ -702,9 +700,7 @@ static int hypfs_create_phys_cpu_files(s
 		return PTR_ERR(rc);
 	diag224_idx2name(phys_cpu__ctidx(diag204_info_type, cpu_info), buffer);
 	rc = hypfs_create_str(sb, cpu_dir, "type", buffer);
-	if (IS_ERR(rc))
-		return PTR_ERR(rc);
-	return 0;
+	return PTR_RET(rc);
 }
 
 static void *hypfs_create_phys_files(struct super_block *sb,



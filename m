Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab3APBHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 20:07:46 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:37544 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab3APBHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 20:07:44 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Pekka Enberg <penberg@kernel.org>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] kvm: close opened file
Date: Wed, 16 Jan 2013 02:07:35 +0100
Message-Id: <1358298456-18377-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file should be closed before return.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 tools/kvm/builtin-setup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/kvm/builtin-setup.c b/tools/kvm/builtin-setup.c
index c5b0566..8b45c56 100644
--- a/tools/kvm/builtin-setup.c
+++ b/tools/kvm/builtin-setup.c
@@ -159,12 +159,12 @@ static int copy_passwd(const char *guestfs_name)
 		return -1;
 
 	ret = fprintf(file, "root:x:0:0:root:/root:/bin/sh\n");
-	if (ret < 0)
-		return ret;
+	if (ret > 0)
+		ret = 0;
 
 	fclose(file);
 
-	return 0;
+	return ret;
 }
 
 static int make_guestfs_symlink(const char *guestfs_name, const char *path)
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab3LHLux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 06:50:53 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:35910 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab3LHLur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 06:50:47 -0500
From: "ethan.zhao" <ethan.kernel@gmail.com>
To: konrad.wilk@oracle.com, stefano.stabellini@eu.citrix.com
Cc: JBeulich@suse.com, tefano.stabellini@citrix.com,
        linux-kernel@vger.kernel.org, "ethan.zhao" <ethan.kernel@gmail.com>
Subject: [PATCH] xen/p2m: Check d_mmu_debug dentry to void NULL pointer issue
Date: Sun,  8 Dec 2013 19:49:16 +0800
Message-Id: <1386503356-1286-1-git-send-email-ethan.kernel@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should check return value of debugfs_create_dir(), the d_mmu_debug
pointer before using it in function xen_p2m_debugfs().

Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>
---
 arch/x86/xen/p2m.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index a61c7d5..ac17f99 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -1172,8 +1172,13 @@ static int __init xen_p2m_debugfs(void)
 		return -ENOMEM;
 
 	d_mmu_debug = debugfs_create_dir("mmu", d_xen);
+	if (!d_mmu_debug)
+		return -ENOENT;
+
+	if (!debugfs_create_file("p2m",
+		0600, d_mmu_debug, NULL, &p2m_dump_fops))
+		return -ENOENT;
 
-	debugfs_create_file("p2m", 0600, d_mmu_debug, NULL, &p2m_dump_fops);
 	return 0;
 }
 fs_initcall(xen_p2m_debugfs);
-- 
1.8.3.4 (Apple Git-47)


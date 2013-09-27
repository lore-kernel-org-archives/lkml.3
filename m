Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab3I0JKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 05:10:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:55659 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab3I0JKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 05:10:01 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-f2-52454b678c2b
From: Weijie Yang <weijie.yang@samsung.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fs/debugfs: add declaration for no CONFIG_DEBUG_FS
Date: Fri, 27 Sep 2013 17:09:07 +0800
Message-id: <000001cebb61$57a4c100$06ee4300$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac67YThKnMgYTDqcRsKMVMK09JdVNA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t9jQd10b9cgg1t9KhbNi9ezWVzeNYfN
	gclj/9w17B6fN8kFMEVx2aSk5mSWpRbp2yVwZRxpmsZUcImz4uzzG2wNjO/Zuxg5OSQETCRe
	P2+CssUkLtxbz9bFyMUhJDCdUeLtuQmMEM4fRon53VfZQKrYBLQl7vZvZAWxRQTkJJ7c/sMM
	YjMLKEj8urcJLC4s4CyxdtZEsKksAqoSP540g9m8AnYSZ/79hrIFJX5MvsfSxcgB1KsuMWVK
	LsQYeYnNa94yg4QlgMKP/upCbNKT+Nz/kwWiRFxi45FbLBMYBWYhGTQLYdAsJINmIelYwMiy
	ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4UJ9J72Bc1WBxiFGAg1GJhzcjyyVIiDWxrLgy
	9xCjBAezkgjvAk/XICHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1utA4UE0hNLUrNTUwtSi2Cy
	TBycUg2M89ZtsN/w9eL/U+qzN9vu52FcVNLdI6nAyXDvm+7CZAe39qf6vHXPl7+58NL74M7N
	mesfGh/4qPJwX+/zo8ZHHy1b++pCzs6VZ653+droFtoULmWZqSbiWuViZTxH6ayVwG+lrf88
	3Tz6+YWlEltvXTFIjM/t/nWkb/fH3fMKNhnZWK/fY/DkgRJLcUaioRZzUXEiALCiZgNQAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two function declarations are absence if not define CONFIG_DEBUG_FS
in include/linux/debugfs.h

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 include/linux/debugfs.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 263489d..4d0b4d1 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -206,6 +206,12 @@ static inline struct dentry *debugfs_create_size_t(const char *name, umode_t mod
 	return ERR_PTR(-ENODEV);
 }
 
+static inline struct dentry *debugfs_create_atomic_t(const char *name, umode_t mode,
+				     struct dentry *parent, atomic_t *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+
 static inline struct dentry *debugfs_create_bool(const char *name, umode_t mode,
 						 struct dentry *parent,
 						 u32 *value)
@@ -227,6 +233,12 @@ static inline struct dentry *debugfs_create_regset32(const char *name,
 	return ERR_PTR(-ENODEV);
 }
 
+static inline int debugfs_print_regs32(struct seq_file *s, const struct debugfs_reg32 *regs,
+			 int nregs, void __iomem *base, char *prefix)
+{
+	return 0;
+}
+
 static inline bool debugfs_initialized(void)
 {
 	return false;
-- 
1.7.10.4



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbbAFRPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:15:34 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:51295 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbbAFRPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:15:32 -0500
From: Mark Salyzyn <salyzyn@android.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salyzyn <salyzyn@android.com>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 1/3] pstore: use snprintf
Date: Tue,  6 Jan 2015 09:15:21 -0800
Message-Id: <1420564526-24420-1-git-send-email-salyzyn@android.com>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No guarantees that the names will not exceed the
name buffer with future adjustments.

Signed-off-by: Mark Salyzyn <salyzyn@android.com>
---
 fs/pstore/inode.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 5041660..a381e6c 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -338,32 +338,34 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 
 	switch (type) {
 	case PSTORE_TYPE_DMESG:
-		sprintf(name, "dmesg-%s-%lld%s", psname, id,
+		snprintf(name, sizeof(name), "dmesg-%s-%lld%s", psname, id,
 						compressed ? ".enc.z" : "");
 		break;
 	case PSTORE_TYPE_CONSOLE:
-		sprintf(name, "console-%s-%lld", psname, id);
+		snprintf(name, sizeof(name), "console-%s-%lld", psname, id);
 		break;
 	case PSTORE_TYPE_FTRACE:
-		sprintf(name, "ftrace-%s-%lld", psname, id);
+		snprintf(name, sizeof(name), "ftrace-%s-%lld", psname, id);
 		break;
 	case PSTORE_TYPE_MCE:
-		sprintf(name, "mce-%s-%lld", psname, id);
+		snprintf(name, sizeof(name), "mce-%s-%lld", psname, id);
 		break;
 	case PSTORE_TYPE_PPC_RTAS:
-		sprintf(name, "rtas-%s-%lld", psname, id);
+		snprintf(name, sizeof(name), "rtas-%s-%lld", psname, id);
 		break;
 	case PSTORE_TYPE_PPC_OF:
-		sprintf(name, "powerpc-ofw-%s-%lld", psname, id);
+		snprintf(name, sizeof(name), "powerpc-ofw-%s-%lld", psname, id);
 		break;
 	case PSTORE_TYPE_PPC_COMMON:
-		sprintf(name, "powerpc-common-%s-%lld", psname, id);
+		snprintf(name, sizeof(name), "powerpc-common-%s-%lld",
+			psname, id);
 		break;
 	case PSTORE_TYPE_UNKNOWN:
-		sprintf(name, "unknown-%s-%lld", psname, id);
+		snprintf(name, sizeof(name), "unknown-%s-%lld", psname, id);
 		break;
 	default:
-		sprintf(name, "type%d-%s-%lld", type, psname, id);
+		snprintf(name, sizeof(name), "type%d-%s-%lld", type,
+			 psname, id);
 		break;
 	}
 
-- 
2.2.0.rc0.207.ga3a616c


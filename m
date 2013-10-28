Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab3J1NW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:22:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117Ab3J1NW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:22:57 -0400
User-agent: mu4e 0.9.9.5; emacs 24.3.1
From: Madper Xie <cxie@redhat.com>
To: Tony Luck <tony.luck@gmail.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Anton Vorontsov <cbou@mail.ru>, Colin Cross <ccross@google.com>,
        Kees Cook <kees@outflux.net>
Cc: "linux-efi\@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Differentiating names by adding a timestamp.
Date: Mon, 28 Oct 2013 21:22:25 +0800
Message-ID: <87li1dv8by.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


pstore denominate dumped file as type-psname-id. it makes many file have
the same name if there are many entries in backend have the same id.
So adding a timestamp to file name.

Signed-off-by: Madper Xie <cxie@redhat.com>
---
 fs/pstore/inode.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 1282384..bf6ed3a 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -315,32 +315,38 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 
 	switch (type) {
 	case PSTORE_TYPE_DMESG:
-		sprintf(name, "dmesg-%s-%lld%s", psname, id,
-						compressed ? ".enc.z" : "");
+		sprintf(name, "dmesg-%s-%lld-%lld%s", psname, id,
+			timespec_to_ns(&time), compressed ? ".enc.z" : "");
 		break;
 	case PSTORE_TYPE_CONSOLE:
-		sprintf(name, "console-%s", psname);
+		sprintf(name, "console-%s-%lld", psname, timespec_to_ns(&time));
 		break;
 	case PSTORE_TYPE_FTRACE:
-		sprintf(name, "ftrace-%s", psname);
+		sprintf(name, "ftrace-%s-%lld", psname, timespec_to_ns(&time));
 		break;
 	case PSTORE_TYPE_MCE:
-		sprintf(name, "mce-%s-%lld", psname, id);
+		sprintf(name, "mce-%s-%lld-%lld", psname, id,
+			timespec_to_ns(&time));
 		break;
 	case PSTORE_TYPE_PPC_RTAS:
-		sprintf(name, "rtas-%s-%lld", psname, id);
+		sprintf(name, "rtas-%s-%lld-%lld", psname, id,
+			timespec_to_ns(&time));
 		break;
 	case PSTORE_TYPE_PPC_OF:
-		sprintf(name, "powerpc-ofw-%s-%lld", psname, id);
+		sprintf(name, "powerpc-ofw-%s-%lld-%lld", psname, id,
+			timespec_to_ns(&time));
 		break;
 	case PSTORE_TYPE_PPC_COMMON:
-		sprintf(name, "powerpc-common-%s-%lld", psname, id);
+		sprintf(name, "powerpc-common-%s-%lld-%lld", psname, id,
+			timespec_to_ns(&time));
 		break;
 	case PSTORE_TYPE_UNKNOWN:
-		sprintf(name, "unknown-%s-%lld", psname, id);
+		sprintf(name, "unknown-%s-%lld-%lld", psname, id,
+			timespec_to_ns(&time));
 		break;
 	default:
-		sprintf(name, "type%d-%s-%lld", type, psname, id);
+		sprintf(name, "type%d-%s-%lld-%lld", type, psname, id,
+			timespec_to_ns(&time));
 		break;
 	}
 
-- 
1.8.4.1

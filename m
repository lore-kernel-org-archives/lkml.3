Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab3HKAzx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 20:55:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:56980 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab3HKAzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 20:55:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,853,1367996400"; 
   d="scan'208";a="360810769"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/3] Kbuild: Handle longer symbols in kallsyms.c
Date: Sat, 10 Aug 2013 17:55:32 -0700
Message-Id: <1376182533-17530-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376182533-17530-1-git-send-email-andi@firstfloor.org>
References: <1376182533-17530-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Also warn for too long symbols

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/kallsyms.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 6940f00..e5af4c5 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -27,7 +27,7 @@
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr[0]))
 #endif
 
-#define KSYM_NAME_LEN		128
+#define KSYM_NAME_LEN		256
 
 struct sym_entry {
 	unsigned long long addr;
@@ -118,6 +118,12 @@ static int read_symbol(FILE *in, struct sym_entry *s)
 			fprintf(stderr, "Read error or end of file.\n");
 		return -1;
 	}
+	if (strlen(str) > KSYM_NAME_LEN) {
+		fprintf(stderr, "Symbol %s too long for kallsyms.\n"
+                                "Please increae KSYM_NAME_LEN both in kernel and kallsyms.c",
+			str);
+		return -1;
+	}
 
 	sym = str;
 	/* skip prefix char */
-- 
1.8.3.1


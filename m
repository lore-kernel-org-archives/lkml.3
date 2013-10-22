Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab3JVPrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:47:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:12944 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab3JVPq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:46:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="311149816"
From: Andi Kleen <andi@firstfloor.org>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/3] Kbuild: Handle longer symbols in kallsyms.c
Date: Tue, 22 Oct 2013 08:46:22 -0700
Message-Id: <1382456783-22826-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382456783-22826-1-git-send-email-andi@firstfloor.org>
References: <1382456783-22826-1-git-send-email-andi@firstfloor.org>
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
index 6940f00..46264c7 100644
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
+                                "Please increase KSYM_NAME_LEN both in kernel and kallsyms.c",
+			str);
+		return -1;
+	}
 
 	sym = str;
 	/* skip prefix char */
-- 
1.8.3.1


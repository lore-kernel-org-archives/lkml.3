Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3JWNH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:07:56 -0400
Received: from one.firstfloor.org ([193.170.194.197]:44324 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab3JWNHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:07:54 -0400
Date: Wed, 23 Oct 2013 15:07:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Joe Perches <joe@perches.com>
Cc: Andi Kleen <andi@firstfloor.org>, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/3] Kbuild: Handle longer symbols in kallsyms.c v2
Message-ID: <20131023130753.GO29695@two.firstfloor.org>
References: <1382456783-22826-1-git-send-email-andi@firstfloor.org>
 <1382456783-22826-3-git-send-email-andi@firstfloor.org>
 <1382459794.2041.91.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382459794.2041.91.camel@joe-AO722>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Also warn for too long symbols

v2: Add missing newline. Use 255 max (Joe Perches)
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/kallsyms.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 6940f00..c4230a4 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -27,7 +27,7 @@
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr[0]))
 #endif
 
-#define KSYM_NAME_LEN		128
+#define KSYM_NAME_LEN		255
 
 struct sym_entry {
 	unsigned long long addr;
@@ -118,6 +118,12 @@ static int read_symbol(FILE *in, struct sym_entry *s)
 			fprintf(stderr, "Read error or end of file.\n");
 		return -1;
 	}
+	if (strlen(str) > KSYM_NAME_LEN) {
+		fprintf(stderr, "Symbol %s too long for kallsyms (%lu vs %d).\n"
+                                "Please increase KSYM_NAME_LEN both in kernel and kallsyms.c\n",
+			str, strlen(str), KSYM_NAME_LEN);
+		return -1;
+	}
 
 	sym = str;
 	/* skip prefix char */
-- 
1.8.4

-- 
ak@linux.intel.com -- Speaking for myself only.

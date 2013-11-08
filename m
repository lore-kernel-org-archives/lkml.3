Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab3KHCpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:45:21 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:34680 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab3KHCpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:45:17 -0500
From: Fabio Estevam <festevam@gmail.com>
To: mmarek@suse.cz
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] scripts: kallsyms: Use %zu to print 'size_t'
Date: Fri,  8 Nov 2013 00:45:01 -0200
Message-Id: <1383878701-17802-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Commit f3462aa95 (Kbuild: Handle longer symbols in kallsyms.c) introduced the
following warning on ARM:

scripts/kallsyms.c:121:4: warning: format '%lu' expects argument of type 'long unsigned int', but argument 4 has type 'size_t' [-Wformat]

Use %zu to print 'size_t'.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 scripts/kallsyms.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 11552e0..990695c 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -116,7 +116,7 @@ static int read_symbol(FILE *in, struct sym_entry *s)
 		return -1;
 	}
 	if (strlen(str) > KSYM_NAME_LEN) {
-		fprintf(stderr, "Symbol %s too long for kallsyms (%lu vs %d).\n"
+		fprintf(stderr, "Symbol %s too long for kallsyms (%zu vs %d).\n"
                                 "Please increase KSYM_NAME_LEN both in kernel and kallsyms.c\n",
 			str, strlen(str), KSYM_NAME_LEN);
 		return -1;
-- 
1.8.1.2


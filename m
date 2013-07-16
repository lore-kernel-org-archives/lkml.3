Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934001Ab3GPUk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:40:26 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:50062 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933952Ab3GPUkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:40:23 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Jean Delvare <jdelvare@suse.de>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 4/6] kconfig: minor style fixes in symbol-search code
Date: Tue, 16 Jul 2013 22:40:00 +0200
Message-Id: <803b3519880f255563d8590c1f5870398b9a4ea0.1374006854.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1374006854.git.yann.morin.1998@free.fr>
References: <cover.1374006854.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1374006854.git.yann.morin.1998@free.fr>
References: <cover.1374006854.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Two minor style fixes:
  - no space before/after parenthesis in function definition
  - no {} for single-line if()

And one grammar fix in a comment.

Reported-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Jean Delvare <jdelvare@suse.de>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
---
 scripts/kconfig/symbol.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 020a0ac..b664d6e 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -963,7 +963,7 @@ struct sym_match {
  * - first, symbols that match exactly
  * - then, alphabetical sort
  */
-static int sym_rel_comp( const void *sym1, const void *sym2 )
+static int sym_rel_comp(const void *sym1, const void *sym2)
 {
 	struct sym_match *s1 = *(struct sym_match **)sym1;
 	struct sym_match *s2 = *(struct sym_match **)sym2;
@@ -1014,9 +1014,8 @@ struct symbol **sym_re_search(const char *pattern)
 			void *tmp;
 			size += 16;
 			tmp = realloc(sym_match_arr, size * sizeof(struct sym_match *));
-			if (!tmp) {
+			if (!tmp)
 				goto sym_re_search_free;
-			}
 			sym_match_arr = tmp;
 		}
 		sym_calc_value(sym);
@@ -1024,7 +1023,7 @@ struct symbol **sym_re_search(const char *pattern)
 		if (!tmp_sym_match)
 			goto sym_re_search_free;
 		tmp_sym_match->sym = sym;
-		/* As regexec return 0, we know we have a match, so
+		/* As regexec returned 0, we know we have a match, so
 		 * we can use match[0].rm_[se]o without further checks
 		 */
 		tmp_sym_match->so = match[0].rm_so;
-- 
1.8.1.2


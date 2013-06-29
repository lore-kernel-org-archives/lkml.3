Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab3F2OVy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 10:21:54 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:62181 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab3F2OV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 10:21:29 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Kees Cook <keescook@chromium.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 1/1] kconfig: allow "hex" and "range" to support longs
Date: Sat, 29 Jun 2013 16:21:12 +0200
Message-Id: <b57caaaed2bd127fe656e6c145970ed6a05c0125.1372515621.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1372515621.git.yann.morin.1998@free.fr>
References: <cover.1372515621.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1372515621.git.yann.morin.1998@free.fr>
References: <cover.1372515621.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

The parsing routines for Kconfig files use strtol(), but store and
render values as int. Switch types and formating to long to support a
wider range of values. For example, 0x80000000 wasn't representable.

Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Reviewed-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
---
 scripts/kconfig/symbol.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 387d554..d550300 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -136,7 +136,7 @@ static struct property *sym_get_range_prop(struct symbol *sym)
 	return NULL;
 }
 
-static int sym_get_range_val(struct symbol *sym, int base)
+static long sym_get_range_val(struct symbol *sym, int base)
 {
 	sym_calc_value(sym);
 	switch (sym->type) {
@@ -155,7 +155,7 @@ static int sym_get_range_val(struct symbol *sym, int base)
 static void sym_validate_range(struct symbol *sym)
 {
 	struct property *prop;
-	int base, val, val2;
+	long base, val, val2;
 	char str[64];
 
 	switch (sym->type) {
@@ -179,9 +179,9 @@ static void sym_validate_range(struct symbol *sym)
 			return;
 	}
 	if (sym->type == S_INT)
-		sprintf(str, "%d", val2);
+		sprintf(str, "%ld", val2);
 	else
-		sprintf(str, "0x%x", val2);
+		sprintf(str, "0x%lx", val2);
 	sym->curr.val = strdup(str);
 }
 
@@ -594,7 +594,7 @@ bool sym_string_valid(struct symbol *sym, const char *str)
 bool sym_string_within_range(struct symbol *sym, const char *str)
 {
 	struct property *prop;
-	int val;
+	long val;
 
 	switch (sym->type) {
 	case S_STRING:
-- 
1.8.1.2


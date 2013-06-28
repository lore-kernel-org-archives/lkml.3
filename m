Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab3F1T5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:57:01 -0400
Received: from smtp.outflux.net ([198.145.64.163]:59974 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab3F1T47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:56:59 -0400
Date: Fri, 28 Jun 2013 12:56:51 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH] kconfig: allow "hex" and "range" to support longs
Message-ID: <20130628195651.GA8198@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parsing routines for Kconfig files use strtol(), but store and
render values as int. Switch types and formating to long to support a
wider range of values. For example, 0x80000000 wasn't representable.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/kconfig/symbol.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index ecc5aa5..8ee1ff58 100644
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
 
@@ -583,7 +583,7 @@ bool sym_string_valid(struct symbol *sym, const char *str)
 bool sym_string_within_range(struct symbol *sym, const char *str)
 {
 	struct property *prop;
-	int val;
+	long val;
 
 	switch (sym->type) {
 	case S_STRING:
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security

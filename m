Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbaFYIqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:46:49 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:56320 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995AbaFYIqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:46:45 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Rusty Russell <rusty@rustcorp.com.au>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] scripts/mod/modpost.c: Fix bug in number_prefix
Date: Wed, 25 Jun 2014 10:46:39 +0200
Message-Id: <1403685999-31013-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function number_prefix() can currently only return 1 if its
argument is the empty string: If line 3 is reached and *sym (now the
second character in the argument) is not '.', 0 is returned. However,
if that character is '.', the first assignment to c is that same '.',
which obviously fails to be a digit.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 scripts/mod/modpost.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 9d9c5b9..336f45f 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -778,9 +778,9 @@ static const char *sech_name(struct elf_info *elf, Elf_Shdr *sechdr)
  */
 static int number_prefix(const char *sym)
 {
-	if (*sym++ == '\0')
+	if (*sym == '\0')
 		return 1;
-	if (*sym != '.')
+	if (*sym++ != '.')
 		return 0;
 	do {
 		char c = *sym++;
-- 
1.9.2


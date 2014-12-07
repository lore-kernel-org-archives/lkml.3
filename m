Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbaLGU45 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 15:56:57 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:49342 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbaLGU44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 15:56:56 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: frv: mm: extable.c:  Remove unused function
Date: Sun,  7 Dec 2014 21:59:34 +0100
Message-Id: <1417985974-16729-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function search_one_table() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/frv/mm/extable.c |   23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/arch/frv/mm/extable.c b/arch/frv/mm/extable.c
index 2fb9b3a..8863d6c 100644
--- a/arch/frv/mm/extable.c
+++ b/arch/frv/mm/extable.c
@@ -10,29 +10,6 @@ extern const void __memset_end, __memset_user_error_lr, __memset_user_error_hand
 extern const void __memcpy_end, __memcpy_user_error_lr, __memcpy_user_error_handler;
 extern spinlock_t modlist_lock;
 
-/*****************************************************************************/
-/*
- *
- */
-static inline unsigned long search_one_table(const struct exception_table_entry *first,
-					     const struct exception_table_entry *last,
-					     unsigned long value)
-{
-        while (first <= last) {
-		const struct exception_table_entry __attribute__((aligned(8))) *mid;
-		long diff;
-
-		mid = (last - first) / 2 + first;
-		diff = mid->insn - value;
-                if (diff == 0)
-                        return mid->fixup;
-                else if (diff < 0)
-                        first = mid + 1;
-                else
-                        last = mid - 1;
-        }
-        return 0;
-} /* end search_one_table() */
 
 /*****************************************************************************/
 /*
-- 
1.7.10.4


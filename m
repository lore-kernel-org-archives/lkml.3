Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbaIPUyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:54:40 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:57006 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbaIPUwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:52:17 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "Igor M. Liplianin" <liplianin@netup.ru>
Subject: [PATCH 16/22] altera-stapl: Replace strnicmp with strncasecmp
Date: Tue, 16 Sep 2014 22:51:30 +0200
Message-Id: <1410900696-6481-17-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics
and a slightly buggy strncasecmp. The latter is the POSIX name, so
strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
for the new strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in
the future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Cc: "Igor M. Liplianin" <liplianin@netup.ru>
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/misc/altera-stapl/altera.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/altera-stapl/altera.c b/drivers/misc/altera-stapl/altera.c
index 24272e0..bca2630 100644
--- a/drivers/misc/altera-stapl/altera.c
+++ b/drivers/misc/altera-stapl/altera.c
@@ -454,7 +454,7 @@ exit_done:
 
 				name = &p[str_table + name_id];
 
-				if (strnicmp(aconf->action, name, strlen(name)) == 0) {
+				if (strncasecmp(aconf->action, name, strlen(name)) == 0) {
 					action_found = 1;
 					current_proc =
 						get_unaligned_be32(&p[action_table +
@@ -2176,7 +2176,7 @@ static int altera_get_note(u8 *p, s32 program_size,
 			key_ptr = &p[note_strings +
 					get_unaligned_be32(
 					&p[note_table + (8 * i)])];
-			if ((strnicmp(key, key_ptr, strlen(key_ptr)) == 0) &&
+			if ((strncasecmp(key, key_ptr, strlen(key_ptr)) == 0) &&
 						(key != NULL)) {
 				status = 0;
 
-- 
2.0.4


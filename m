Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030384AbaLLOoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 09:44:06 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:59048 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967919AbaLLOoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 09:44:04 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] lib: string_get_size: Remove redundant prefixes
Date: Fri, 12 Dec 2014 15:43:46 +0100
Message-Id: <1418395428-25980-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While 3c9f3681d0b4 says that Z and Y are included in preparation for
128 bit computers, they just waste .text currently. If and when we get
u128, string_get_size needs updating anyway (and ISO needs to come up
with four more prefixes).

Also there's no need to include and test for the NULL sentinel; once
we reach "E" size is at most 18. [The test is also wrong; it should be
units_str[units][i+1]; if we've reached NULL we're already doomed.]

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/string_helpers.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index 58b78ba57439..0d25f7aa732c 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -28,11 +28,10 @@ int string_get_size(u64 size, const enum string_size_units units,
 		    char *buf, int len)
 {
 	static const char *const units_10[] = {
-		"B", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB", NULL
+		"B", "kB", "MB", "GB", "TB", "PB", "EB"
 	};
 	static const char *const units_2[] = {
-		"B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB",
-		NULL
+		"B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"
 	};
 	static const char *const *const units_str[] = {
 		[STRING_UNITS_10] = units_10,
@@ -49,7 +48,7 @@ int string_get_size(u64 size, const enum string_size_units units,
 	tmp[0] = '\0';
 	i = 0;
 	if (size >= divisor[units]) {
-		while (size >= divisor[units] && units_str[units][i]) {
+		while (size >= divisor[units]) {
 			remainder = do_div(size, divisor[units]);
 			i++;
 		}
-- 
2.1.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbbAHMPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 07:15:04 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:50801 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbbAHMO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:14:57 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] lib/vsprintf.c: Replace while with do-while in skip_atoi
Date: Thu,  8 Jan 2015 13:14:47 +0100
Message-Id: <1420719287-10222-4-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420719287-10222-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1420719287-10222-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All callers of skip_atoi have already checked for the first character
being a digit. In this case, gcc generates simpler code for a do
while-loop.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/vsprintf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 1ec6a78f169b..e152da53cbd2 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -114,8 +114,9 @@ int skip_atoi(const char **s)
 {
 	int i = 0;
 
-	while (isdigit(**s))
+	do {
 		i = i*10 + *((*s)++) - '0';
+	} while (isdigit(**s));
 
 	return i;
 }
-- 
2.1.3


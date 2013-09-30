Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab3I3VKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 17:10:37 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:37951 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab3I3VKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 17:10:36 -0400
Date: Mon, 30 Sep 2013 23:10:35 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Subject: [PATCH] [IA64] aliasing-test: fix mem leaks
Message-ID: <alpine.LNX.2.00.1309302309200.4992@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a few trivial mem leaks when returning from scan_tree/scan_rom.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 Documentation/ia64/aliasing-test.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/ia64/aliasing-test.c b/Documentation/ia64/aliasing-test.c
index 62a190d..33ed7a7 100644
--- a/Documentation/ia64/aliasing-test.c
+++ b/Documentation/ia64/aliasing-test.c
@@ -96,6 +96,7 @@ static int scan_tree(char *path, char *file, off_t offset, size_t length, int to
 				fprintf(stderr, "PASS: %s 0x%lx-0x%lx not mappable\n", path2, offset, offset + length);
 			else {
 				fprintf(stderr, "FAIL: %s 0x%lx-0x%lx not accessible\n", path2, offset, offset + length);
+				free(path2);
 				return rc;
 			}
 		} else {
@@ -185,6 +186,7 @@ static int scan_rom(char *path, char *file)
 				fprintf(stderr, "PASS: %s read %d bytes\n", path2, rc);
 			else {
 				fprintf(stderr, "PASS: %s not readable\n", path2);
+				free(path2);
 				return rc;
 			}
 		} else {
-- 
1.7.1

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


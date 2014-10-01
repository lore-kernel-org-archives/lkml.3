Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbaJAXLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 19:11:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39968 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaJAXLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 19:11:40 -0400
Date: Thu, 2 Oct 2014 00:11:38 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] binfmt_misc: drop old optimisation VERBOSE_STATUS flag
Message-ID: <20141001231138.GA25689@hercules>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VERBOSE_STATUS flag doesn't seem to be relevant these days.  It is a
compile time flag that for sure doesn't "save 400 bytes kernel memory".

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/binfmt_misc.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index b60500300dd7..7560f89669d5 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -33,10 +33,6 @@
 
 #include <asm/uaccess.h>
 
-enum {
-	VERBOSE_STATUS = 1 /* make it zero to save 400 bytes kernel memory */
-};
-
 static LIST_HEAD(entries);
 static int enabled = 1;
 
@@ -424,11 +420,6 @@ static void entry_status(Node *e, char *page)
 	if (test_bit(Enabled, &e->flags))
 		status = "enabled";
 
-	if (!VERBOSE_STATUS) {
-		sprintf(page, "%s\n", status);
-		return;
-	}
-
 	sprintf(page, "%s\ninterpreter %s\n", status, e->interpreter);
 	dp = page + strlen(page);
 
-- 
2.1.0

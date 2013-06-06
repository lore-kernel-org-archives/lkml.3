Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab3FFCtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 22:49:35 -0400
Received: from smtp.outflux.net ([198.145.64.163]:58084 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756202Ab3FFCte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 22:49:34 -0400
Date: Wed, 5 Jun 2013 19:49:30 -0700
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH] doc: avoid strncpy in accounting tool
Message-ID: <20130606024930.GA24279@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid strncpy anti-pattern. Use strdup() instead, as already done for
the logfile optarg.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
Fix for -mm clean-up-scary-strncpydst-src-strlensrc-uses-fix.patch
---
 Documentation/accounting/getdelays.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index f8ebcde..1db89d3 100644
--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -272,7 +272,7 @@ int main(int argc, char *argv[])
 	char *logfile = NULL;
 	int loop = 0;
 	int containerset = 0;
-	char containerpath[1024];
+	char *containerpath = NULL;
 	int cfd = 0;
 	int forking = 0;
 	sigset_t sigset;
@@ -299,7 +299,7 @@ int main(int argc, char *argv[])
 			break;
 		case 'C':
 			containerset = 1;
-			strncpy(containerpath, optarg, strlen(optarg) + 1);
+			containerpath = strdup(optarg);
 			break;
 		case 'w':
 			logfile = strdup(optarg);
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security

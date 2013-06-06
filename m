Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3FFREg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 13:04:36 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48166 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab3FFREe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 13:04:34 -0400
Date: Thu, 6 Jun 2013 10:04:26 -0700
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2] doc: avoid strncpy in accounting tool
Message-ID: <20130606170426.GA8034@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid strncpy anti-pattern. Since optarg is stable, it can be used
directly. This avoids a needless strdup() for the "logfile" variable
as well.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
Fix for -mm clean-up-scary-strncpydst-src-strlensrc-uses-fix.patch
---
 Documentation/accounting/getdelays.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index f8ebcde..c402ac0 100644
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
@@ -299,10 +299,10 @@ int main(int argc, char *argv[])
 			break;
 		case 'C':
 			containerset = 1;
-			strncpy(containerpath, optarg, strlen(optarg) + 1);
+			containerpath = optarg;
 			break;
 		case 'w':
-			logfile = strdup(optarg);
+			logfile = optarg;
 			printf("write to file %s\n", logfile);
 			write_file = 1;
 			break;
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security

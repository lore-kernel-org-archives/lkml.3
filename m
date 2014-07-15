Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbaGODDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:03:05 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:36242 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757540AbaGODDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:03:01 -0400
Date: Tue, 15 Jul 2014 12:01:45 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] staging: dgap: remove unused a parameter in dgap_gettok()
Message-ID: <20140715030145.GA14394@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "p" as parameter is unused.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 17514c8..1e52092 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -150,7 +150,7 @@ static void dgap_firmware_reset_port(struct channel_t *ch);
 /*
  * Function prototypes from dgap_parse.c.
  */
-static int dgap_gettok(char **in, struct cnode *p);
+static int dgap_gettok(char **in);
 static char *dgap_getword(char **in);
 static struct cnode *dgap_newnode(int t);
 static int dgap_checknode(struct cnode *p);
@@ -6342,7 +6342,7 @@ static int dgap_parsefile(char **in)
 		p = p->next;
 
 	/* file must start with a BEGIN */
-	while ((rc = dgap_gettok(in, p)) != BEGIN) {
+	while ((rc = dgap_gettok(in)) != BEGIN) {
 		if (rc == 0) {
 			dgap_err("unexpected EOF");
 			return -1;
@@ -6350,7 +6350,7 @@ static int dgap_parsefile(char **in)
 	}
 
 	for (; ;) {
-		rc = dgap_gettok(in, p);
+		rc = dgap_gettok(in);
 		if (rc == 0) {
 			dgap_err("unexpected EOF");
 			return -1;
@@ -7100,7 +7100,7 @@ static char *dgap_sindex(char *string, char *group)
 /*
  * Get a token from the input file; return 0 if end of file is reached
  */
-static int dgap_gettok(char **in, struct cnode *p)
+static int dgap_gettok(char **in)
 {
 	char *w;
 	struct toklist *t;
-- 
1.7.1


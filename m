Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab3GHREM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 13:04:12 -0400
Received: from smtp.outflux.net ([198.145.64.163]:34729 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab3GHREK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 13:04:10 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Ankita Garg <ankita@in.ibm.com>,
        Simon Kagstrom <simon.kagstrom@netinsight.net>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 2/4] lkdtm: add "WARNING" trigger
Date: Mon,  8 Jul 2013 10:01:31 -0700
Message-Id: <1373302893-4990-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373302893-4990-1-git-send-email-keescook@chromium.org>
References: <1373302893-4990-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For additional testing, add "WARNING" as a trigger that calls WARN_ON(1).

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index adb6bde..b1323fc 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -68,6 +68,7 @@ enum ctype {
 	CT_NONE,
 	CT_PANIC,
 	CT_BUG,
+	CT_WARNING,
 	CT_EXCEPTION,
 	CT_LOOP,
 	CT_OVERFLOW,
@@ -95,6 +96,7 @@ static char* cp_name[] = {
 static char* cp_type[] = {
 	"PANIC",
 	"BUG",
+	"WARNING",
 	"EXCEPTION",
 	"LOOP",
 	"OVERFLOW",
@@ -284,6 +286,9 @@ static void lkdtm_do_action(enum ctype which)
 	case CT_BUG:
 		BUG();
 		break;
+	case CT_WARNING:
+		WARN_ON(1);
+		break;
 	case CT_EXCEPTION:
 		*((int *) 0) = 0;
 		break;
-- 
1.7.9.5


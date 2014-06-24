Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbaFXLIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 07:08:14 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:32869 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbaFXLIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 07:08:13 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Howard Cochran <hcochran@lexmark.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] tools: lib: traceevent: event-parse.c:  Fix a risk for doing free on uninitialized pointer
Date: Tue, 24 Jun 2014 13:09:10 +0200
Message-Id: <1403608150-13037-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a risk of doing free on an uninitialized pointer.

This was found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 tools/lib/traceevent/event-parse.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index b83184f..857675e 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2390,7 +2390,7 @@ process_flags(struct event_format *event, struct print_arg *arg, char **tok)
 {
 	struct print_arg *field;
 	enum event_type type;
-	char *token;
+	char *token = NULL;
 
 	memset(arg, 0, sizeof(*arg));
 	arg->type = PRINT_FLAGS;
@@ -2443,7 +2443,7 @@ process_symbols(struct event_format *event, struct print_arg *arg, char **tok)
 {
 	struct print_arg *field;
 	enum event_type type;
-	char *token;
+	char *token = NULL;
 
 	memset(arg, 0, sizeof(*arg));
 	arg->type = PRINT_SYMBOL;
@@ -2482,7 +2482,7 @@ process_hex(struct event_format *event, struct print_arg *arg, char **tok)
 {
 	struct print_arg *field;
 	enum event_type type;
-	char *token;
+	char *token = NULL;
 
 	memset(arg, 0, sizeof(*arg));
 	arg->type = PRINT_HEX;
-- 
1.7.10.4


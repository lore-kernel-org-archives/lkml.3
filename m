Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbaF0MVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:21:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799AbaF0MVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:21:12 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 1/5] tools lib traceevent: Fix a risk for doing free on uninitialized pointer
Date: Fri, 27 Jun 2014 14:20:57 +0200
Message-Id: <1403871661-18474-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403871661-18474-1-git-send-email-jolsa@kernel.org>
References: <1403871661-18474-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Fix a risk of doing free on an uninitialized pointer.

This was found using a static code analysis program called cppcheck.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Link: http://lkml.kernel.org/r/1403608150-13037-1-git-send-email-rickard_strandqvist@spectrumdigital.se
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/traceevent/event-parse.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 93825a1..cf3a44b 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2395,7 +2395,7 @@ process_flags(struct event_format *event, struct print_arg *arg, char **tok)
 {
 	struct print_arg *field;
 	enum event_type type;
-	char *token;
+	char *token = NULL;
 
 	memset(arg, 0, sizeof(*arg));
 	arg->type = PRINT_FLAGS;
@@ -2448,7 +2448,7 @@ process_symbols(struct event_format *event, struct print_arg *arg, char **tok)
 {
 	struct print_arg *field;
 	enum event_type type;
-	char *token;
+	char *token = NULL;
 
 	memset(arg, 0, sizeof(*arg));
 	arg->type = PRINT_SYMBOL;
@@ -2487,7 +2487,7 @@ process_hex(struct event_format *event, struct print_arg *arg, char **tok)
 {
 	struct print_arg *field;
 	enum event_type type;
-	char *token;
+	char *token = NULL;
 
 	memset(arg, 0, sizeof(*arg));
 	arg->type = PRINT_HEX;
-- 
1.8.3.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760654AbaGEKmL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:42:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57840 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbaGEKmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:42:07 -0400
Date: Sat, 5 Jul 2014 03:41:52 -0700
From: tip-bot for Rickard Strandqvist <tipbot@zytor.com>
Message-ID: <tip-21da83fb6c3ff67e969b8770bbb33138c9ede88e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, rickard_strandqvist@spectrumdigital.se,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com,
        rickard_strandqvist@spectrumdigital.se, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1403608150-13037-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1403608150-13037-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Fix a risk for doing free on uninitialized pointer
Git-Commit-ID: 21da83fb6c3ff67e969b8770bbb33138c9ede88e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  21da83fb6c3ff67e969b8770bbb33138c9ede88e
Gitweb:     http://git.kernel.org/tip/21da83fb6c3ff67e969b8770bbb33138c9ede88e
Author:     Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
AuthorDate: Tue, 24 Jun 2014 13:09:10 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Fri, 27 Jun 2014 11:14:47 +0200

tools lib traceevent: Fix a risk for doing free on uninitialized pointer

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

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964828AbaEMWMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:12:50 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:63683 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbaEMWFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:05:25 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        acme@ghostprotocols.net, dsahern@gmail.com, mingo@kernel.org
Subject: [PATCH 09/34] perf kbuild: fix a link issue if BUILTIN_TRACE is disabled
Date: Wed, 14 May 2014 00:03:04 +0200
Message-Id: <1400018609-20486-10-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
References: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 tools/perf/perf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 74a1269..588221c 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -95,7 +95,7 @@ static struct cmd_struct commands[] = {
 #ifdef CONFIG_BUILTIN_TEST
 	{ "test",	cmd_test,	0 },
 #endif
-#if defined HAVE_LIBAUDIT_SUPPORT && defined CONFIG_BUILTIN_TRACE
+#ifdef CONFIG_BUILTIN_TRACE
 	{ "trace",	cmd_trace,	0 },
 #endif
 #ifdef CONFIG_BUILTIN_INJECT
@@ -524,7 +524,7 @@ int main(int argc, const char **argv)
 		fprintf(stderr, "cannot handle %s internally", cmd);
 		goto out;
 	}
-#ifdef HAVE_LIBAUDIT_SUPPORT
+#ifdef CONFIG_BUILTIN_TRACE
 	if (!prefixcmp(cmd, "trace")) {
 		set_buildid_dir();
 		setup_path();
-- 
1.9.2


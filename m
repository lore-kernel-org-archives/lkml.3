Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965172AbaFCWIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:08:53 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:52756 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965114AbaFCWIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:08:48 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz
Subject: [PATCH 08/32] perf kbuild: fix a link issue if BUILTIN_TRACE is disabled
Date: Wed,  4 Jun 2014 00:06:01 +0200
Message-Id: <1401833185-10347-9-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
References: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
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
1.9.3


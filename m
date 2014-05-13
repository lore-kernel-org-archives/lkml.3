Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435AbaEMWNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:13:08 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:38094 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164AbaEMWFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:05:24 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        acme@ghostprotocols.net, dsahern@gmail.com, mingo@kernel.org
Subject: [PATCH 08/34] perf kbuild: remove useless #ifdef directives
Date: Wed, 14 May 2014 00:03:03 +0200
Message-Id: <1400018609-20486-9-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
References: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 tools/perf/ui/setup.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index 66ecd08..cb69740 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -71,20 +71,16 @@ void setup_browser(bool fallback_to_pager)
 
 	switch (use_browser) {
 	case 2:
-#if defined(CONFIG_GUI) || !defined(CONFIG_KBUILD)
 		if (setup_gtk_browser() == 0)
 			break;
 		printf("GTK browser requested but could not find %s\n",
 		       PERF_GTK_DSO);
 		sleep(1);
-#endif
 		/* fall through */
-#if defined(CONFIG_TUI) || !defined(CONFIG_KBUILD)
 	case 1:
 		use_browser = 1;
 		if (ui__init() == 0)
 			break;
-#endif
 		/* fall through */
 	default:
 		use_browser = 0;
@@ -100,16 +96,12 @@ void exit_browser(bool wait_for_ok __maybe_unused)
 {
 	switch (use_browser) {
 	case 2:
-#if defined(CONFIG_GUI) || !defined(CONFIG_KBUILD)
 		exit_gtk_browser(wait_for_ok);
 		break;
-#endif
 
-#if defined(CONFIG_TUI) || !defined(CONFIG_KBUILD)
 	case 1:
 		ui__exit(wait_for_ok);
 		break;
-#endif
 
 	default:
 		break;
-- 
1.9.2


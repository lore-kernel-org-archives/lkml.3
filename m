Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab3KENwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 08:52:33 -0500
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:30882 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab3KENwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 08:52:32 -0500
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Nov 2013 08:52:32 EST
Subject: [PATCH 2/3] makedumpfile: hugepage filtering: add excluding
 hugepage messages
To: ptesarik@suse.cz, d.hatayama@jp.fujitsu.com,
        kumagai-atsushi@mxc.nes.nec.co.jp
From: Jingbai Ma <jingbai.ma@hp.com>
Cc: bhe@redhat.com, tom.vaden@hp.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, lisa.mitchell@hp.com,
        anderson@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com
Date: Tue, 05 Nov 2013 21:45:53 +0800
Message-ID: <20131105134553.32112.58435.stgit@k.asiapacific.hpqcorp.net>
In-Reply-To: <20131105134532.32112.78008.stgit@k.asiapacific.hpqcorp.net>
References: <20131105134532.32112.78008.stgit@k.asiapacific.hpqcorp.net>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add messages for print_info.

Signed-off-by: Jingbai Ma <jingbai.ma@hp.com>
---
 print_info.c |   12 +++++++-----
 print_info.h |    2 ++
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/print_info.c b/print_info.c
index 06939e0..978d9fb 100644
--- a/print_info.c
+++ b/print_info.c
@@ -103,17 +103,19 @@ print_usage(void)
 	MSG("      The maximum of Dump_Level is 31.\n");
 	MSG("      Note that Dump_Level for Xen dump filtering is 0 or 1.\n");
 	MSG("\n");
-	MSG("            |         cache    cache\n");
-	MSG("      Dump  |  zero   without  with     user    free\n");
-	MSG("      Level |  page   private  private  data    page\n");
-	MSG("     -------+---------------------------------------\n");
+	MSG("            |         cache    cache                    free    active\n");
+	MSG("      Dump  |  zero   without  with     user    free    huge    huge\n");
+	MSG("      Level |  page   private  private  data    page    page    page\n");
+	MSG("     -------+----------------------------------------------------------\n");
 	MSG("         0  |\n");
 	MSG("         1  |   X\n");
 	MSG("         2  |           X\n");
 	MSG("         4  |           X        X\n");
 	MSG("         8  |                            X\n");
 	MSG("        16  |                                    X\n");
-	MSG("        31  |   X       X        X       X       X\n");
+	MSG("        32  |                                            X\n");
+	MSG("        64  |                                            X       X\n");
+	MSG("       127  |   X       X        X       X       X       X       X\n");
 	MSG("\n");
 	MSG("  [-E]:\n");
 	MSG("      Create DUMPFILE in the ELF format.\n");
diff --git a/print_info.h b/print_info.h
index 01e3706..8461df6 100644
--- a/print_info.h
+++ b/print_info.h
@@ -35,6 +35,8 @@ void print_execution_time(char *step_name, struct timeval *tv_start);
 #define PROGRESS_HOLES		"Checking for memory holes  "
 #define PROGRESS_UNN_PAGES 	"Excluding unnecessary pages"
 #define PROGRESS_FREE_PAGES 	"Excluding free pages       "
+#define PROGRESS_FREE_HUGE	"Excluding free huge pages  "
+#define PROGRESS_ACTIVE_HUGE	"Excluding active huge pages"
 #define PROGRESS_ZERO_PAGES 	"Excluding zero pages       "
 #define PROGRESS_XEN_DOMAIN 	"Excluding xen user domain  "
 


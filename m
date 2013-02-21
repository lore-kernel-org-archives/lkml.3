Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab3BUK1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 05:27:51 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:45174 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab3BUK1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 05:27:50 -0500
Date: Thu, 21 Feb 2013 11:27:48 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [perf patch] perf doesn't delete /tmp/perf-vdso.so.* file on exit
Message-ID: <20130221102748.GB2919@x4>
References: <20130221094544.GA2919@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130221094544.GA2919@x4>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf top doesn't unlink /tmp/perf-vdso.so.* on exit.
Fix this by calling vdso__exit() before exit(0).

Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c9ff395..e910d91 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -20,6 +20,7 @@
 #include "builtin.h"
 
 #include "perf.h"
+#include "vdso.h"
 
 #include "util/annotate.h"
 #include "util/cache.h"
@@ -602,6 +603,7 @@ static void *display_thread_tui(void *arg)
 				      &top->session->header.env);
 
 	exit_browser(0);
+	vdso__exit();
 	exit(0);
 	return NULL;
 }
-- 
Markus

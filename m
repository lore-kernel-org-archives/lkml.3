Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab3CLTia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:38:30 -0400
Received: from relay1.sgi.com ([192.48.179.29]:42393 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab3CLTiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:38:25 -0400
Message-Id: <20130312193823.766518369@gulag1.americas.sgi.com>
References: <20130312193823.212544181@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 12 Mar 2013 14:38:26 -0500
From: Mike Travis <travis@sgi.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        linux-kernel@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>
Subject: [PATCH 03/14] KDB: up the default LINES value
Content-Disposition: inline; filename=kdb-up-default-lines.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the default for the # of lines displayed by the KDB pager
is 24.  This does not allow all of the lines for the entry messages,
reg dump and process trace.  Increase it to something more reasonable.

Cc: Tim Bird <tim.bird@am.sony.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/debug/kdb/kdb_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/kernel/debug/kdb/kdb_io.c
+++ linux/kernel/debug/kdb/kdb_io.c
@@ -586,7 +586,7 @@ int vkdb_printf(const char *fmt, va_list
 
 	diag = kdbgetintenv("LINES", &linecount);
 	if (diag || linecount <= 1)
-		linecount = 24;
+		linecount = 60;
 
 	diag = kdbgetintenv("COLUMNS", &colcount);
 	if (diag || colcount <= 1)

-- 

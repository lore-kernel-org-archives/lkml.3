Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048Ab3CYSuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 14:50:12 -0400
Received: from relay3.sgi.com ([192.48.152.1]:55837 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932909Ab3CYSuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 14:50:09 -0400
Message-Id: <20130325185007.776886654@gulag1.americas.sgi.com>
References: <20130325185007.321022858@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 25 Mar 2013 13:50:10 -0500
From: Mike Travis <travis@sgi.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        linux-kernel@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>
Subject: [PATCH 03/15] KDB: up the default LINES value
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

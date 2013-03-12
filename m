Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab3CLTib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:38:31 -0400
Received: from relay2.sgi.com ([192.48.179.30]:48689 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755196Ab3CLTiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:38:25 -0400
Message-Id: <20130312193823.479385834@gulag1.americas.sgi.com>
References: <20130312193823.212544181@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 12 Mar 2013 14:38:24 -0500
From: Mike Travis <travis@sgi.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 01/14] KDB: fix the interrupt of the KDB btc command
Content-Disposition: inline; filename=kdb-fix-bt-break.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The KDB 'btc' (backtrace cpus) command ignores the 'quit' reply
to the 'more>' prompt.  This is quite annoying when you have a
large number of processors and thousands of lines are being
printed.  This fixes that problem.

Cc: David Howells <dhowells@redhat.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/debug/kdb/kdb_bt.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux.orig/kernel/debug/kdb/kdb_bt.c
+++ linux/kernel/debug/kdb/kdb_bt.c
@@ -123,6 +123,8 @@ kdb_bt(int argc, const char **argv)
 			kdb_ps_suppressed();
 		/* Run the active tasks first */
 		for_each_online_cpu(cpu) {
+			if (KDB_FLAG(CMD_INTERRUPT))
+				return 0;
 			p = kdb_curr_task(cpu);
 			if (kdb_bt1(p, mask, argcount, btaprompt))
 				return 0;

-- 

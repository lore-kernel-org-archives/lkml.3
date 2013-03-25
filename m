Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254Ab3CYSxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 14:53:41 -0400
Received: from relay1.sgi.com ([192.48.179.29]:37394 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932970Ab3CYSuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 14:50:09 -0400
Message-Id: <20130325185007.496292277@gulag1.americas.sgi.com>
References: <20130325185007.321022858@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 25 Mar 2013 13:50:08 -0500
From: Mike Travis <travis@sgi.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 01/15] KDB: fix the interrupt of the KDB btc command
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

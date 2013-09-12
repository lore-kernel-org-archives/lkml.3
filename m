Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab3ILNQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:16:55 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:61190 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab3ILNQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:16:53 -0400
Date: Thu, 12 Sep 2013 15:16:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: hpa@zytor.com, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: [PATCH] Fix old GCC build error in
 perf/util/trace-event-parse.c:parse_proc_kallsyms()
Message-ID: <20130912131649.GC23826@gmail.com>
References: <1375875537-4509-8-git-send-email-adrian.hunter@intel.com>
 <tip-8e0cf965f95edd41df11cca50b92b4cb6ea8d80a@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tip-8e0cf965f95edd41df11cca50b92b4cb6ea8d80a@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Old GCC (4.1) does not see through the code flow of parse_proc_kallsyms() 
and gets confused about the status of 'fmt':

 util/trace-event-parse.c: In function ‘parse_proc_kallsyms’:
 util/trace-event-parse.c:189: warning: ‘fmt’ may be used uninitialized in this function
 make: *** [util/trace-event-parse.o] Error 1

Help out GCC by initializing 'fmt' to NULL.

Thanks,

	Ingo

Signed-off-by: Ingo Molnar <mingo@kernel.org>

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index fe7a27d..e9e1c03 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -186,7 +186,7 @@ void parse_proc_kallsyms(struct pevent *pevent,
 	char *next = NULL;
 	char *addr_str;
 	char *mod;
-	char *fmt;
+	char *fmt = NULL;
 
 	line = strtok_r(file, "\n", &next);
 	while (line) {

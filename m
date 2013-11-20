Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab3KTN4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:56:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35934 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3KTN4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:56:41 -0500
Date: Wed, 20 Nov 2013 05:55:54 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-yllx4aqcg06v5n4vjpwiiuld@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools lib traceevent:
  Fix conversion of pointer to integer of different size
Git-Commit-ID: 6b5fa0ba4f85a8499287aefaf3f1375450c40c6d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 20 Nov 2013 05:56:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6b5fa0ba4f85a8499287aefaf3f1375450c40c6d
Gitweb:     http://git.kernel.org/tip/6b5fa0ba4f85a8499287aefaf3f1375450c40c6d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 19 Nov 2013 16:14:51 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Nov 2013 16:37:59 -0300

tools lib traceevent: Fix conversion of pointer to integer of different size

gcc complaint on 32-bit system:

  /home/acme/git/linux/tools/lib/traceevent/event-parse.c: In function ‘eval_num_arg’:
  /home/acme/git/linux/tools/lib/traceevent/event-parse.c:3468:9: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

This is because the eval_num_arg returns everything as an 'unsigned long long',
so it converts a void pointer to a wider integer, fix it by converting the void
pointer to an integer of the same size, 'unsigned long', before casting it to
'unsigned long long'.

Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-yllx4aqcg06v5n4vjpwiiuld@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 8a5b65d..217c82e 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3465,7 +3465,7 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 		 * is in the bottom half of the 32 bit field.
 		 */
 		offset &= 0xffff;
-		val = (unsigned long long)(data + offset);
+		val = (unsigned long long)((unsigned long)data + offset);
 		break;
 	default: /* not sure what to do there */
 		return 0;

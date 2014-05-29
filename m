Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933835AbaE2Fmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:42:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967AbaE2Eeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:34:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3.14 005/140] tools lib traceevent: Fix memory leak in pretty_print()
Date: Wed, 28 May 2014 21:32:24 -0700
Message-Id: <20140529043050.252828181@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit de04f8657de9d3351a2d5880f1f7080b23b798cf upstream.

Commit 12e55569a244 "tools lib traceevent: Use helper trace-seq in print
functions like kernel does" added a extra trace_seq helper to process
string arguments like the kernel does it. But the difference between the
kernel and the userspace library is that the kernel's trace_seq structure
has a static allocated buffer. The userspace one has a dynamically
allocated one. It requires a trace_seq_destroy(), otherwise it produces
a nasty memory leak.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20140422192330.6bb09bf8@gandalf.local.home
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/lib/traceevent/event-parse.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4321,6 +4321,7 @@ static void pretty_print(struct trace_se
 					      format, len_arg, arg);
 				trace_seq_terminate(&p);
 				trace_seq_puts(s, p.buffer);
+				trace_seq_destroy(&p);
 				arg = arg->next;
 				break;
 			default:



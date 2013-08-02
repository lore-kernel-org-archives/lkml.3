Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab3HBSrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 14:47:32 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:46578 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab3HBSrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 14:47:31 -0400
MIME-Version: 1.0
Date: Fri, 2 Aug 2013 14:47:29 -0400
Message-ID: <CAPhKKr_H=ukFnBL4WgDOVT5ay2xeF-Ho+CA0DWZX0E2JW-=vSQ@mail.gmail.com>
Subject: [PATCH] ftrace: Fixup !CONFIG_TRACING trace_dump_stack
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b3a897608521f04e2fb640e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b3a897608521f04e2fb640e
Content-Type: text/plain; charset=ISO-8859-1

Hi Steve,

And since gmail will mangle this up, I have attached it as well.

Thanks!
Dhaval

commit 6379b752b4c9e5f9edf9894723be7520a987d2b5
Author: Dhaval Giani <dhaval.giani@gmail.com>
Date:   Fri Aug 2 14:42:53 2013 -0400

    ftrace: Fixup !CONFIG_TRACING trace_dump_stack

    !TRACING does not take an argument for trace_dump_stack. Fix it.

    Signed-off-by: Dhaval Giani <dhaval.giani@gmail.com>

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e9ef6d6..4b7cc46 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -631,7 +631,7 @@ extern void ftrace_dump(enum ftrace_dump_mode
oops_dump_mode);
 static inline void tracing_start(void) { }
 static inline void tracing_stop(void) { }
 static inline void ftrace_off_permanent(void) { }
-static inline void trace_dump_stack(void) { }
+static inline void trace_dump_stack(int skip) { }

 static inline void tracing_on(void) { }
 static inline void tracing_off(void) { }

--047d7b3a897608521f04e2fb640e
Content-Type: application/octet-stream; name="trace.patch"
Content-Disposition: attachment; filename="trace.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hjvqvip90

Y29tbWl0IDYzNzliNzUyYjRjOWU1ZjllZGY5ODk0NzIzYmU3NTIwYTk4N2QyYjUKQXV0aG9yOiBE
aGF2YWwgR2lhbmkgPGRoYXZhbC5naWFuaUBnbWFpbC5jb20+CkRhdGU6ICAgRnJpIEF1ZyAyIDE0
OjQyOjUzIDIwMTMgLTA0MDAKCiAgICBmdHJhY2U6IEZpeHVwICFDT05GSUdfVFJBQ0lORyB0cmFj
ZV9kdW1wX3N0YWNrCiAgICAKICAgICFUUkFDSU5HIGRvZXMgbm90IHRha2UgYW4gYXJndW1lbnQg
Zm9yIHRyYWNlX2R1bXBfc3RhY2suIEZpeCBpdC4KICAgIAogICAgU2lnbmVkLW9mZi1ieTogRGhh
dmFsIEdpYW5pIDxkaGF2YWwuZ2lhbmlAZ21haWwuY29tPgoKZGlmZiAtLWdpdCBhL2luY2x1ZGUv
bGludXgva2VybmVsLmggYi9pbmNsdWRlL2xpbnV4L2tlcm5lbC5oCmluZGV4IGU5ZWY2ZDYuLjRi
N2NjNDYgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgva2VybmVsLmgKKysrIGIvaW5jbHVkZS9s
aW51eC9rZXJuZWwuaApAQCAtNjMxLDcgKzYzMSw3IEBAIGV4dGVybiB2b2lkIGZ0cmFjZV9kdW1w
KGVudW0gZnRyYWNlX2R1bXBfbW9kZSBvb3BzX2R1bXBfbW9kZSk7CiBzdGF0aWMgaW5saW5lIHZv
aWQgdHJhY2luZ19zdGFydCh2b2lkKSB7IH0KIHN0YXRpYyBpbmxpbmUgdm9pZCB0cmFjaW5nX3N0
b3Aodm9pZCkgeyB9CiBzdGF0aWMgaW5saW5lIHZvaWQgZnRyYWNlX29mZl9wZXJtYW5lbnQodm9p
ZCkgeyB9Ci1zdGF0aWMgaW5saW5lIHZvaWQgdHJhY2VfZHVtcF9zdGFjayh2b2lkKSB7IH0KK3N0
YXRpYyBpbmxpbmUgdm9pZCB0cmFjZV9kdW1wX3N0YWNrKGludCBza2lwKSB7IH0KIAogc3RhdGlj
IGlubGluZSB2b2lkIHRyYWNpbmdfb24odm9pZCkgeyB9CiBzdGF0aWMgaW5saW5lIHZvaWQgdHJh
Y2luZ19vZmYodm9pZCkgeyB9Cg==
--047d7b3a897608521f04e2fb640e--

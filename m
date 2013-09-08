Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab3IHM2f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 08:28:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33539 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab3IHM1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 08:27:03 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=gdDC6PIHeqgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=vZTWnjI3nDAA:10 a=380GcQh12wOJ0zuRzTgA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130908122700.545438926@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sun, 08 Sep 2013 08:25:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 06/10] hwlat-detect/trace: Export trace_clock_local for hwlat-detector
References: <20130908122545.421180629@goodmis.org>
Content-Disposition: inline; filename=0006-hwlat-detect-trace-Export-trace_clock_local-for-hwla.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The hwlat-detector needs a better clock than just ktime_get() as that
can induce its own latencies. The trace clock is perfect for it, but
it needs to be exported for use by modules.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_clock.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 3947835..1bbb1b2 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -44,6 +44,7 @@ u64 notrace trace_clock_local(void)
 
 	return clock;
 }
+EXPORT_SYMBOL_GPL(trace_clock_local);
 
 /*
  * trace_clock(): 'between' trace clock. Not completely serialized,
-- 
1.7.10.4



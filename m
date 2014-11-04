Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbaKDQCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:02:45 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:15176 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754596AbaKDQCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:02:24 -0500
Message-Id: <20141104160221.717247815@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 04 Nov 2014 10:52:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Chen Gong <gong.chen@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        Tony Luck <tony.luck@intel.com>
Subject: [RFC][PATCH 02/12 v3] RAS/tracing: Use trace_seq_buffer_ptr() helper instead of open coded
References: <20141104155237.228431433@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-RAS-tracing-Use-trace_seq_buffer_ptr-helper-instead-.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Use the helper function trace_seq_buffer_ptr() to get the current location
of the next buffer write of a trace_seq object, instead of open coding
it.

This facilitates the conversion of trace_seq to use seq_buf.

Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/firmware/efi/cper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index 5b53d6183b6b..4fd9961d552e 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -294,7 +294,7 @@ void cper_mem_err_pack(const struct cper_sec_mem_err *mem,
 const char *cper_mem_err_unpack(struct trace_seq *p,
 				struct cper_mem_err_compact *cmem)
 {
-	const char *ret = p->buffer + p->len;
+	const char *ret = trace_seq_buffer_ptr(p);
 
 	if (cper_mem_err_location(cmem, rcd_decode_str))
 		trace_seq_printf(p, "%s", rcd_decode_str);
-- 
2.1.1



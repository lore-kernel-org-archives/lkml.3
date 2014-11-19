Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575AbaKSX3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:29:31 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:23890 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756702AbaKSX1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:27:13 -0500
Message-Id: <20141119232710.073000694@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 19 Nov 2014 18:26:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>,
        Petr Mladek <pmladek@suse.cz>, Chen Gong <gong.chen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [for-next][PATCH 05/18] RAS/tracing: Use trace_seq_buffer_ptr() helper instead of open coded
References: <20141119232632.737569526@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0005-RAS-tracing-Use-trace_seq_buffer_ptr-helper-instead-.patch
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

Tested-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Petr Mladek <pmladek@suse.cz>
Cc: Chen Gong <gong.chen@linux.intel.com>
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



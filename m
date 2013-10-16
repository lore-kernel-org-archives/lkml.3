Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761712Ab3JPSLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:11:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52898 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761691Ab3JPSLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:11:32 -0400
Date: Wed, 16 Oct 2013 20:11:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>,
        "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, joe@perches.com, naveen.n.rao@linux.vnet.ibm.com,
        arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] Extended H/W error log driver
Message-ID: <20131016181117.GP13608@pd.tnic>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
 <20131016160550.GG13608@pd.tnic>
 <20131016125646.7141b580@gandalf.local.home>
 <20131016180038.GO13608@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131016180038.GO13608@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 08:00:38PM +0200, Borislav Petkov wrote:
> Right, the only difference I can see is that include/ras/ras_event.h
> doesn't have those below:
> 
> #undef TRACE_INCLUDE_PATH
> #undef TRACE_INCLUDE_FILE
> #define TRACE_INCLUDE_PATH .
> 
> Perhaps that is the problem?
> 
> Gong, what is exactly the issue you're observing?

Ok, I think I know what the issue is:

Gong has

diff --git a/drivers/acpi/extlog_trace.c b/drivers/acpi/extlog_trace.c
new file mode 100644
index 000000000000..28640807fb09
--- /dev/null
+++ b/drivers/acpi/extlog_trace.c
@@ -0,0 +1,107 @@
+#include <linux/export.h>
+#include <linux/dmi.h>
+#include "extlog_trace.h"
+
+#define CREATE_TRACE_POINTS
+#define TRACE_INCLUDE_PATH ../../include/ras
+#include <ras/ras_event.h>

for the ras tracepoint although this is done already in
drivers/edac/edac_mc.c

Gong, can you try moving the CREATE_TRACE_POINTS line to a new file -
arch/x86/ras/ras.c and define it there and not anywhere else, i.e. move
it away from edac_mc.c. Does that help?

Also, see Documentation/trace/tracepoints.txt for more info.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

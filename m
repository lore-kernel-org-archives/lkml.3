Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbaEGSHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 14:07:46 -0400
Received: from smtp.outflux.net ([198.145.64.163]:39295 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbaEGSHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 14:07:44 -0400
Date: Wed, 7 May 2014 11:07:40 -0700
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sysctl: flip file position warning to pr_warn_once
Message-ID: <20140507180740.GA13529@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid dmesg flooding, use pr_warn_once instead of pr_warn.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
(follow-up to "sysctl-allow-for-strict-write-position-handling" series)
---
 kernel/sysctl.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index e23d7017b870..3afb82cd08e4 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1783,10 +1783,10 @@ static int _proc_do_string(char *data, int maxlen, int write,
 
 static void warn_sysctl_write(struct ctl_table *table)
 {
-	pr_warn("%s wrote to %s when file position was not 0!\n",
+	pr_warn_once("%s wrote to %s when file position was not 0!\n"
+		"This will not be supported in the future. To silence this\n"
+		"warning, set kernel.sysctl_writes_strict = -1\n",
 		current->comm, table->procname);
-	pr_warn("This will not be supported in the future.\n");
-	pr_warn("To silence warning, set kernel.sysctl_writes_strict = -1\n");
 }
 
 /**
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security

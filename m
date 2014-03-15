Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbaCOULc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 16:11:32 -0400
Received: from smtp.outflux.net ([198.145.64.163]:51299 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbaCOULa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 16:11:30 -0400
Date: Sat, 15 Mar 2014 13:11:18 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-ia64@vger.kernel.org
Subject: [PATCH] ia64: keep format strings from leaking into printk
Message-ID: <20140315201118.GA29753@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The buffer being sent to printk has already had format strings
resolved. The string should not be reinterpreted again to avoid any
unintended format strings from leaking into printk.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/ia64/kernel/mca.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
index b8edfa75a83f..601502ab7141 100644
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -217,7 +217,7 @@ void ia64_mca_printk(const char *fmt, ...)
 	/* Copy the output into mlogbuf */
 	if (oops_in_progress) {
 		/* mlogbuf was abandoned, use printk directly instead. */
-		printk(temp_buf);
+		printk("%s", temp_buf);
 	} else {
 		spin_lock(&mlogbuf_wlock);
 		for (p = temp_buf; *p; p++) {
@@ -268,7 +268,7 @@ void ia64_mlogbuf_dump(void)
 		}
 		*p = '\0';
 		if (temp_buf[0])
-			printk(temp_buf);
+			printk("%s", temp_buf);
 		mlogbuf_start = index;
 
 		mlogbuf_timestamp = 0;
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security

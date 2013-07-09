Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab3GIPlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:41:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49068 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979Ab3GIPlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:41:51 -0400
Subject: [PATCH 1/3] firmware/dmi_scan: Drop obsolete comment
From: Jean Delvare <jdelvare@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <1373384438.4391.6.camel@chaos.site>
References: <1373384438.4391.6.camel@chaos.site>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Tue, 09 Jul 2013 17:41:35 +0200
Message-ID: <1373384495.4391.7.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This comment predates the introduction of early_ioremap. Since then
the missing calls to dmi_iounmap have been added by Ingo and Yinghai
in commits 0d64484f7ea12ca04211b497e94634c3d27cf3fb and
3212bff370c2f22e4987c6679ba485654cefb178. That was over 5 years ago so
it is about time to drop this now misleading comment.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
---
 drivers/firmware/dmi_scan.c |    5 -----
 1 file changed, 5 deletions(-)

--- linux-3.10-rc0.orig/drivers/firmware/dmi_scan.c	2013-05-04 11:16:44.229314442 +0200
+++ linux-3.10-rc0/drivers/firmware/dmi_scan.c	2013-05-04 11:19:17.320935301 +0200
@@ -497,11 +497,6 @@ void __init dmi_scan_machine(void)
 		}
 	}
 	else {
-		/*
-		 * no iounmap() for that ioremap(); it would be a no-op, but
-		 * it's so early in setup that sucker gets confused into doing
-		 * what it shouldn't if we actually call it.
-		 */
 		p = dmi_ioremap(0xF0000, 0x10000);
 		if (p == NULL)
 			goto error;


-- 
Jean Delvare
Suse L3


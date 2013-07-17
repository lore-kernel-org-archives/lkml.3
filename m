Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab3GQHzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 03:55:43 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37915 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab3GQHzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 03:55:42 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Ingo Molnar <mingo@kernel.org>, David Daney <david.daney@cavium.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Borislav Petkov <bp@suse.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Date: Wed, 17 Jul 2013 09:55:11 +0200
Message-Id: <1374047711-21518-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH] extable: Skip sorting if the table is empty
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least on ARM no-MMU the extable is empty and so there is nothing to
sort. So add a check for the table to be empty which effectively only
changes that the misleading pr_notice is suppressed.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

I first tried to select BUILDTIME_EXTABLE_SORT for ARM no-MMU, too, but that
failed to build with

	no __ex_table in  file: vmlinux

. I didn't dig deeper for the reasons, but maybe this is worth fixing, too?

Best regards
Uwe

 kernel/extable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/extable.c b/kernel/extable.c
index 67460b9..832cb28 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -41,7 +41,7 @@ u32 __initdata main_extable_sort_needed = 1;
 /* Sort the kernel's built-in exception table */
 void __init sort_main_extable(void)
 {
-	if (main_extable_sort_needed) {
+	if (main_extable_sort_needed && __stop___ex_table > __start___ex_table) {
 		pr_notice("Sorting __ex_table...\n");
 		sort_extable(__start___ex_table, __stop___ex_table);
 	}
-- 
1.8.3.2


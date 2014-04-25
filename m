Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaDYJs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:48:56 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:60001 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbaDYJsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:48:53 -0400
From: Mathieu Souchaud <mattieu.souchaud@free.fr>
To: tony.luck@intel.com, bp@alien8.de, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Cc: Mathieu Souchaud <mattieu.souchaud@free.fr>
Subject: [PATCH] x86/mce: Check misc_register() return code.
Date: Fri, 25 Apr 2014 11:48:15 +0200
Message-Id: <1398419295-18590-1-git-send-email-mattieu.souchaud@free.fr>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code does not check the return from misc_register() so set
the return variable with the return code of misc_register.

Signed-off-by: Mathieu Souchaud <mattieu.souchaud@free.fr>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 68317c8..45fb7aa 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2462,7 +2462,7 @@ static __init int mcheck_init_device(void)
 	cpu_notifier_register_done();
 
 	/* register character device /dev/mcelog */
-	misc_register(&mce_chrdev_device);
+	err = misc_register(&mce_chrdev_device);
 
 	return err;
 }
-- 
1.7.9.5


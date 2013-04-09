Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934600Ab3DISUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:20:32 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33258 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761186Ab3DISUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:20:31 -0400
Message-ID: <1365531571.8447.4.camel@concerto>
Subject: [PATCH] x86, mce: Print warning if MCE handler fails to register
 /dev/mcelog
From: Khalid Aziz <khalid.aziz@oracle.com>
To: tony.luck@intel.com, bp@alien8.de, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Cc: x86@kernel.org, linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 09 Apr 2013 12:19:31 -0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print a warning if machine check handler fails to register
/dev/mcelog device.


Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 7bc1263..7b4c28c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2412,7 +2412,8 @@ static __init int mcheck_init_device(void)
 	register_hotcpu_notifier(&mce_cpu_notifier);
 
 	/* register character device /dev/mcelog */
-	misc_register(&mce_chrdev_device);
+	if (misc_register(&mce_chrdev_device) != 0)
+		pr_warn("Failed to register mcelog device\n");
 
 	return err;
 }
-- 
1.7.10.4




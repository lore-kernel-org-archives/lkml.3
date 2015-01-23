Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbbAWFfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:35:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:38760 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbbAWFfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:35:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="444042024"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, linux-am33-list@redhat.com
Subject: [Resend Patch v4 07/16] smp, mn10300: Enable arch_send_call_function_ipi_mask()
Date: Fri, 23 Jan 2015 13:36:46 +0800
Message-Id: <1421991416-20297-8-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable arch_send_call_function_ipi_mask() on mn10300 to support
smp_call_function_many().

Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: linux-am33-list@redhat.com
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/mn10300/kernel/smp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/mn10300/kernel/smp.c b/arch/mn10300/kernel/smp.c
index 13aa7ac5a82b..9d21c3391374 100644
--- a/arch/mn10300/kernel/smp.c
+++ b/arch/mn10300/kernel/smp.c
@@ -356,8 +356,7 @@ void send_IPI_allbutself(int irq)
 
 void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 {
-	BUG();
-	/*send_IPI_mask(mask, CALL_FUNCTION_IPI);*/
+	send_IPI_mask(mask, CALL_FUNC_IPI);
 }
 
 void arch_send_call_function_single_ipi(int cpu)
-- 
1.7.10.4


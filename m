Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaEVUze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 16:55:34 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:57455 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751039AbaEVUzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 16:55:33 -0400
Message-ID: <1400792131.16407.33.camel@x220>
Subject: [PATCH] mfd: db8500-prcmu: remove check for
 CONFIG_DBX500_PRCMU_DEBUG
From: Paul Bolle <pebolle@tiscali.nl>
To: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 22 May 2014 22:55:31 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 May 2014 20:55:32.0005 (UTC) FILETIME=[2B913D50:01CF7600]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A check for CONFIG_DBX500_PRCMU_DEBUG was added in v3.6. But there's no
Kconfig symbol DBX500_PRCMU_DEBUG. So remove this check.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested. Note that db8500_prcmu_debug_dump() is nowhere to be found in
the tree.

This check has been in the tree for less than two years. Am I being
impatient here?

 drivers/mfd/db8500-prcmu.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 7694e0700d34..c248bde367ab 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2303,9 +2303,6 @@ int prcmu_ac_wake_req(void)
 
 	if (!wait_for_completion_timeout(&mb0_transfer.ac_wake_work,
 			msecs_to_jiffies(5000))) {
-#if defined(CONFIG_DBX500_PRCMU_DEBUG)
-		db8500_prcmu_debug_dump(__func__, true, true);
-#endif
 		pr_crit("prcmu: %s timed out (5 s) waiting for a reply.\n",
 			__func__);
 		ret = -EFAULT;
-- 
1.9.0


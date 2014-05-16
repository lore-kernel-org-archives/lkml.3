Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbaEPNe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:34:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54139 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbaEPNeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:34:23 -0400
Date: Fri, 16 May 2014 06:33:29 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-aa5125a45568f8f666f6d2f224fe8ab261b1069e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, joro@8bytes.org, peterz@infradead.org,
        tony.luck@intel.com, fenghua.yu@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, joro@8bytes.org,
        tony.luck@intel.com, fenghua.yu@intel.com, tglx@linutronix.de
In-Reply-To: <20140507154336.178850165@linutronix.de>
References: <20140507154336.178850165@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] iommu: smar: Fix return value check of create_irq(
 )
Git-Commit-ID: aa5125a45568f8f666f6d2f224fe8ab261b1069e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aa5125a45568f8f666f6d2f224fe8ab261b1069e
Gitweb:     http://git.kernel.org/tip/aa5125a45568f8f666f6d2f224fe8ab261b1069e
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:10 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:19 +0200

iommu: smar: Fix return value check of create_irq()

ia64 returns a negative error code when allocation fails andx86
returns 0. Make it handle both.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: x86@kernel.org
Acked-by: Joerg Roedel <joro@8bytes.org>
Cc: linux-ia64@vger.kernel.org
Cc: iommu@lists.linux-foundation.org
Link: http://lkml.kernel.org/r/20140507154336.178850165@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/iommu/dmar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 39f8b71..3ce1f62 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1551,7 +1551,7 @@ int dmar_set_interrupt(struct intel_iommu *iommu)
 		return 0;
 
 	irq = create_irq();
-	if (!irq) {
+	if (irq <= 0) {
 		pr_err("IOMMU: no free vectors\n");
 		return -EINVAL;
 	}

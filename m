Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab3JKTlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:41:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46265 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575Ab3JKTlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [ 060/135] iommu/arm-smmu: fix a signedness bug
Date: Fri, 11 Oct 2013 12:39:01 -0700
Message-Id: <20131011193951.797268197@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit faea13b72dbdb77e4d6ad83344596486611708b0 upstream.

Unsigned char is never equal to -1.

Tested-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/arm-smmu.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -379,6 +379,7 @@ struct arm_smmu_cfg {
 	u32				cbar;
 	pgd_t				*pgd;
 };
+#define INVALID_IRPTNDX			0xff
 
 struct arm_smmu_domain {
 	/*
@@ -830,7 +831,7 @@ static int arm_smmu_init_domain_context(
 	if (IS_ERR_VALUE(ret)) {
 		dev_err(smmu->dev, "failed to request context IRQ %d (%u)\n",
 			root_cfg->irptndx, irq);
-		root_cfg->irptndx = -1;
+		root_cfg->irptndx = INVALID_IRPTNDX;
 		goto out_free_context;
 	}
 
@@ -855,7 +856,7 @@ static void arm_smmu_destroy_domain_cont
 	if (!smmu)
 		return;
 
-	if (root_cfg->irptndx != -1) {
+	if (root_cfg->irptndx != INVALID_IRPTNDX) {
 		irq = smmu->irqs[smmu->num_global_irqs + root_cfg->irptndx];
 		free_irq(irq, domain);
 	}



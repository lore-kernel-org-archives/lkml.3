Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaBKRN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:13:29 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:25528 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752202AbaBKRKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:10:52 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Pawel Moll <pawel.moll@arm.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/12] mfd: syscon: Consider platform data a regmap config name
Date: Tue, 11 Feb 2014 17:10:31 +0000
Message-Id: <1392138636-29240-8-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the device platform data as a regmap config
name. This is particularly useful in the regmap
debugfs when there is more than one syscon device
registered, to distinguish the register blocks.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
Alternatively I could define a syscon platform data structure,
something like this:

struct syscon_platform_data {
	const char *label;
};

 drivers/mfd/syscon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index 71841f9..ea1770b 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -143,6 +143,7 @@ static int syscon_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	syscon_regmap_config.max_register = res->end - res->start - 3;
+	syscon_regmap_config.name = dev_get_platdata(&pdev->dev);
 	syscon->regmap = devm_regmap_init_mmio(dev, base,
 					&syscon_regmap_config);
 	if (IS_ERR(syscon->regmap)) {
-- 
1.8.3.2


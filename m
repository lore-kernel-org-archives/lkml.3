Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947615Ab3BIBIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 20:08:42 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:36841 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947581Ab3BIBIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 20:08:38 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 05/16] davinci: cpuidle - remove useless initialization
Date: Fri,  8 Feb 2013 20:08:09 -0500
Message-Id: <748f11772154b58426c856b7d90538a9b60ae29a.1360371180.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360372100-28482-1-git-send-email-lenb@kernel.org>
References: <1360372100-28482-1-git-send-email-lenb@kernel.org>
In-Reply-To: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
References: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Lezcano <daniel.lezcano@linaro.org>

The device->state_count is initialized in the cpuidle_register_device
function.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/arm/mach-davinci/cpuidle.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/mach-davinci/cpuidle.c b/arch/arm/mach-davinci/cpuidle.c
index 5e430bf..5ac9e93 100644
--- a/arch/arm/mach-davinci/cpuidle.c
+++ b/arch/arm/mach-davinci/cpuidle.c
@@ -96,8 +96,6 @@ static int __init davinci_cpuidle_probe(struct platform_device *pdev)
 
 	ddr2_pdown = pdata->ddr2_pdown;
 
-	device->state_count = DAVINCI_CPUIDLE_MAX_STATES;
-
 	ret = cpuidle_register_driver(&davinci_idle_driver);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register driver\n");
-- 
1.8.1.3.535.ga923c31


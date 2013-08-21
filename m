Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab3HUQyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:54:15 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24828 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab3HUQxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:53:54 -0400
X-AuditID: cbfec7f5-b7f5f6d00000105f-07-5214f0a13c03
From: Andrzej Hajda <a.hajda@samsung.com>
To: lee.jones@linaro.org
Cc: Andrzej Hajda <a.hajda@samsung.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 2/2] max77693: added device tree support
Date: Wed, 21 Aug 2013 18:53:34 +0200
Message-id: <1377104014-21910-3-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1377104014-21910-1-git-send-email-a.hajda@samsung.com>
References: <1377104014-21910-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/xa7oLP4gEGdzrYLG4te4cq8X8I0Di
	wJ8djBZveoFinWefMFucbXrDbnH/61FGi8u75rBZLL1+kcliwvS1LBaHVxxgslj3cjqQ9aad
	1eJ0N6vFq4NtLA78HmvmrWH0WPD5CrvH68kTGD1erZ7J6nHn2h42j3knAz36tqxi9Pi8Sc5j
	49zQAM4oLpuU1JzMstQifbsEroy985awF/xirzh2aBV7A+MBti5GTg4JAROJCQveMELYYhIX
	7q0HinNxCAksZZQ4+3Y7M4TTxyTx7G8LO0gVm4CmxN/NN8G6RQQkJDb+6GMBKWIWOMUiMbf1
	NhNIQljAWmLpodWsIDaLgKrE/0s9QA0cHLwCzhKbjstCbFOQ+Hn5BNgcTgEXiba/98DmCwGV
	tFxYzDKBkXcBI8MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJBA/rqDcekxq0OMAhyMSjy8
	F3aKBAmxJpYVV+YeYpTgYFYS4S08CRTiTUmsrEotyo8vKs1JLT7EyMTBKdXAOJUhIWjD/vQv
	65ftOPevf/6suz83hZiI/jAoK7rboOSb6ltleK9fTWDZ90VNe3gv95dKyG8oOXAuTkL4U116
	vIzWbeHrJX7MZ5N+m872fmwXosA2ZV2p2KOUaR8Ocwe+9FgTIlZrWPnkt8VmacXQ5bvPcFm2
	1779EcNZIRnA2sf7R4o7cF6QEktxRqKhFnNRcSIASKEvCEICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds only of_match_table.
There are no device specific properties.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/max77693.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index 27f5da3..e0b11a9 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -225,11 +225,19 @@ static const struct dev_pm_ops max77693_pm = {
 	.resume = max77693_resume,
 };
 
+#ifdef CONFIG_OF
+static struct of_device_id max77693_dt_match[] = {
+	{.compatible = "maxim,max77693"},
+	{},
+};
+#endif
+
 static struct i2c_driver max77693_i2c_driver = {
 	.driver = {
 		   .name = "max77693",
 		   .owner = THIS_MODULE,
 		   .pm = &max77693_pm,
+		   .of_match_table = of_match_ptr(max77693_dt_match),
 	},
 	.probe = max77693_i2c_probe,
 	.remove = max77693_i2c_remove,
-- 
1.8.1.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185AbaILEf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 00:35:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54255 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaILEf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 00:35:58 -0400
X-AuditID: cbfee691-f79546d0000011a1-cb-5412782b2cdc
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH] mfd: intel_soc_pmic: Add CONFIG_PM_SLEEP check for
 suspend_fn/resume_fn
Date: Fri, 12 Sep 2014 13:35:45 +0900
Message-id: <1410496545-6579-1-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsWyRsSkRFe7QijE4NozY4vrX56zWuxoOMJq
	cf/rUUaLy7vmsFmc7mZ1YPW4c20Pm8e8k4EefVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlbFz
	7z3WgjkcFS9n/2RuYPzN1sXIySEhYCKxru8zC4QtJnHh3nqwuJDAUkaJqyusYWo+7nnF1MXI
	BRSfzigxaf5VdginjUni7oHzYN1sAtoS39cvZu1i5OAQEfCSuHUnCCTMLJAv8f7VVLASYYEo
	iR8XbjGD2CwCqhIr729jBLF5Bdwl1v16D9YqIaAgMWeSDch4CYHnbBJz921ig6gXkPg2+RAL
	RI2sxKYDzBC3SUocXHGDZQKj4AJGhlWMoqkFyQXFSelFpnrFibnFpXnpesn5uZsYgQF5+t+z
	iTsY7x+wPsQowMGoxMNbwSIYIsSaWFZcmXuI0RRow0RmKdHkfGDY55XEGxqbGVmYmpgaG5lb
	mimJ8+pI/wwWEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwBgRJ7n7opWbdlO3x0cOQ41ChpfV
	u440NSsG+Z9v4otP9Pqqnlnq7Jh07bfTdqFJl1evVJqf3NZ3fC63g5Dk0zmr1iy2OqjbnNPz
	7Y77ncDbnww6JG07gnVEFbj31plu+Ms8fSLrd1X5jvDFDtfW5ufJNRzeI6C+0qHE5kZ7UrLZ
	aYM5E2NDlViKMxINtZiLihMBqDVBhEMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsVy+t9jQV3tCqEQg78duhbXvzxntdjRcITV
	4v7Xo4wWl3fNYbM43c3qwOpx59oeNo95JwM9+rasYvT4vEkugCWqgdEmIzUxJbVIITUvOT8l
	My/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2itkkJZYk4pUCggsbhYSd8O04TQ
	EDddC5jGCF3fkCC4HiMDNJCwhjFj5957rAVzOCpezv7J3MD4m62LkZNDQsBE4uOeV0wQtpjE
	hXvrgeJcHEIC0xklJs2/yg7htDFJ3D1wngWkik1AW+L7+sWsXYwcHCICXhK37gSBhJkF8iXe
	v5oKViIsECXx48ItZhCbRUBVYuX9bYwgNq+Au8S6X+/BWiUEFCTmTLKZwMi9gJFhFaNoakFy
	QXFSeq6hXnFibnFpXrpecn7uJkZwwD+T2sG4ssHiEKMAB6MSD28Fi2CIEGtiWXFl7iFGCQ5m
	JRHeJn+hECHelMTKqtSi/Pii0pzU4kOMpkDLJzJLiSbnA6MxryTe0NjEzMjSyNzQwsjYXEmc
	90CrdaCQQHpiSWp2ampBahFMHxMHp1QDY+Afr2kLVz/jV5aXnpHPWBMoZjvvrs+vhVqmBSE2
	MfU8BTOva6ddC1hcIxg2Zd+MdP3Zs9Y2mPClxIg3dSu/3PF2ydebdbrqrBs/TqvT/ZheeNT6
	bMqdnqnskVEBZwtau2+unPb1MfulcwETE0+Y/2+RLmA4q13VsuBxfNHv0J8fi9e/Z7qrrcRS
	nJFoqMVcVJwIALtdfpWOAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix warning message with CONFIG_PM_SLEEP disabled
If CONFIG_PM_SLEEP is not enabled we receive the following warning message:

drivers/mfd/intel_soc_pmic_core.c:118:12:
 warning: 'intel_soc_pmic_suspend' defined but not used

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
---
 drivers/mfd/intel_soc_pmic_core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/intel_soc_pmic_core.c b/drivers/mfd/intel_soc_pmic_core.c
index 2720922..df7b064 100644
--- a/drivers/mfd/intel_soc_pmic_core.c
+++ b/drivers/mfd/intel_soc_pmic_core.c
@@ -115,6 +115,7 @@ static void intel_soc_pmic_shutdown(struct i2c_client *i2c)
 	return;
 }
 
+#if defined(CONFIG_PM_SLEEP)
 static int intel_soc_pmic_suspend(struct device *dev)
 {
 	struct intel_soc_pmic *pmic = dev_get_drvdata(dev);
@@ -132,6 +133,7 @@ static int intel_soc_pmic_resume(struct device *dev)
 
 	return 0;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(intel_soc_pmic_pm_ops, intel_soc_pmic_suspend,
 			 intel_soc_pmic_resume);
-- 
1.7.9.5


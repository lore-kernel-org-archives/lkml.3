Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379AbaFILFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 07:05:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61390 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253AbaFILFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 07:05:35 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-fe-539594fdf4b7
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, sbkim73@samsung.com, sameo@linux.intel.com
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH] mfd: sec-core: Prepare regulators for suspend state to reduce
 power-consumption
Date: Mon, 09 Jun 2014 20:05:30 +0900
Message-id: <1402311930-24056-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsWyRsSkSPfvlKnBBo/2iVlc//Kc1eJs0xt2
	i/tfjzJaXN41h83iduMKNovT3awWF1d8YXJg97hzbQ+bx7yTgR59W1YxenzeJBfAEsVlk5Ka
	k1mWWqRvl8CV0XrgC1NBO2fF+r4L7A2MJ9m7GDk5JARMJBo+zGCEsMUkLtxbz9bFyMEhJLCU
	UWI+P0zJk85WNhBbSGARo8SCDVVdjFxAdhOTxPrNU8ESbAJaEvtf3ACzRQRcJJZ0vwOzmQVq
	JfZda2IFsYUFkiQ+f1/LBGKzCKhKXDo0A6yGV8BVYu+ZZ8wQy+QkPux5xA6yQELgM5vE7zUP
	WSAaBCS+TT7EAnKchICsxKYDUPWSEgdX3GCZwCi4gJFhFaNoakFyQXFSepGpXnFibnFpXrpe
	cn7uJkZgkJ7+92ziDsb7B6wPMSYDjZvILCWanA8M8rySeENjMyMLUxNTYyNzSzPShJXEedMf
	JQUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYDzmw9vRMfGXLoOV/bvUDyf/pX+QWv6o+5cY
	m3qw4qNQljntt9r3aEbet65Or5ZUSsp7Mfn+dOltHwSOhs247GjqcN2hokd/a/M+8RsOV6dl
	HOa95tfw9/Xti48di3MDj0/fppF4m3XO3LsH6x5yfNnCydAUVKc6M6RD8LjTooql9Ss7Twax
	7VNiKc5INNRiLipOBAADy9yJaAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t9jAd2/U6YGG5z/wGdx/ctzVouzTW/Y
	Le5/PcpocXnXHDaL240r2CxOd7NaXFzxhcmB3ePOtT1sHvNOBnr0bVnF6PF5k1wAS1QDo01G
	amJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0AFKCmWJOaVA
	oYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxozWA1+YCto5K9b3XWBvYDzJ3sXIySEh
	YCLxpLOVDcIWk7hwbz2YLSSwiFFiwYaqLkYuILuJSWL95qlgCTYBLYn9L26A2SICLhJLut+B
	2cwCtRL7rjWxgtjCAkkSn7+vZQKxWQRUJS4dmgFWwyvgKrH3zDNmiGVyEh/2PGKfwMi9gJFh
	FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwHDyT3sG4qsHiEKMAB6MSD2/E7ynBQqyJZcWV
	uYcYJTiYlUR4fXKmBgvxpiRWVqUW5ccXleakFh9iTAbaPpFZSjQ5HxijeSXxhsYmZkaWRuaG
	FkbG5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAmMomlHjz7eZHNkcS2dyl9i8W3cxp
	su3elUP6Snb7Nu79Udd818mwddqZsk/t/4TWxjDuEzQ9H77WaI5KX0bemjWXtHcmvha70dh4
	0MBSUvTrhunfVc59X3y8aI+4+NV2norb9299VehpqTM4F3lY/Hzt6/iPnXlhPmbPNT8FLA3l
	1DD5clTRXYmlOCPRUIu5qDgRAJcZ+KTHAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use regulator_suspend_prepare() function to prepare the proper state
of regulators for suspend state to remove un-necessary leakage power-consumption.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
This patch has a dependency on following patchset[1].
- [1] https://lkml.org/lkml/2014/6/9/255
  [PATCHv4 0/3] mfd: sec-core: Add support S2MPU02 PMIC device

 drivers/mfd/sec-core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 5e8784b..e3413d5 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -30,6 +30,7 @@
 #include <linux/mfd/samsung/s2mps14.h>
 #include <linux/mfd/samsung/s5m8763.h>
 #include <linux/mfd/samsung/s5m8767.h>
+#include <linux/regulator/machine.h>
 #include <linux/regmap.h>
 
 static const struct mfd_cell s5m8751_devs[] = {
@@ -406,6 +407,13 @@ static int sec_pmic_suspend(struct device *dev)
 	 */
 	disable_irq(sec_pmic->irq);
 
+	switch (sec_pmic->device_type) {
+	case S2MPS14X:
+	case S2MPU02:
+		regulator_suspend_prepare(PM_SUSPEND_MEM);
+		break;
+	};
+
 	return 0;
 }
 
-- 
1.8.0


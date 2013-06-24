Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab3GCLbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:31:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35928 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab3GCLbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:31:52 -0400
X-AuditID: cbfee691-b7fef6d000002d62-88-51d40ba6d3cd
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: yadi.brar01@gmail.com, sbkim73@samsung.com, broonie@kernel.org,
        lgirdwood@gmail.com, sameo@linux.intel.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH 2/4] regulator: s2mps11: Implement set_voltage_time_sel() ops
 for bucks
Date: Mon, 24 Jun 2013 16:50:56 +0530
Message-id: <1372072858-6559-3-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1372072858-6559-1-git-send-email-yadi.brar@samsung.com>
References: <1372072858-6559-1-git-send-email-yadi.brar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSp7uM+0qgwYmtWhZTHz5hszjwZwej
	xbcrHUwWl3fNYbM4vOIAk8XpblaLiyu+MFnM/d3IajFn+jsmB06PBZ+vsHvsnHWX3WPTqk42
	jzvX9rB5zDsZ6NG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZFz9tYy2YL1Jxcc561gbGVwJd
	jJwcEgImEmfaNrBA2GISF+6tZ+ti5OIQEljKKLFw1V9GmKKXv3vZIRLTGSXm/r3CBOG0MUm8
	avgO1M7BwSZgJPHqmB1Ig4iAgsTm3mesIDXMApcYJabtPcIKkhAWiJT439IBZrMIqEo87D0H
	toFXwEVi65Yb7BDbFCRalx0CszkFXCVaX15gBpkvBFTT/JEFZKaEwC52ieVdf9gg5ghIfJt8
	COwGCQFZiU0HmCHGSEocXHGDZQKj8AJGhlWMoqkFyQXFSelFpnrFibnFpXnpesn5uZsYgbFw
	+t+ziTsY7x+wPsSYDDRuIrOUaHI+MJbySuINjc2MLExNTI2NzC3NSBNWEudVb7EOFBJITyxJ
	zU5NLUgtii8qzUktPsTIxMEp1cA4b464Rrm+yGknldoFtX+NOy+o/eJvkv8+5Tv3hqhKI2+p
	Ih2rWzufuCrxKU47eq9v1/aU54bfrfYF1P48nmWcHnlyw8ILGc6cy5/kqdQ3Z/n0T6udl5bp
	92D/FgdvRp3HBm9X71l181WDwYQHyyXck9X2nt7B8Sxm4Te+bQKTLOv+2SdatJ1XYinOSDTU
	Yi4qTgQA3No8lJsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jQd1l3FcCDS4eUbCY+vAJm8WBPzsY
	Lb5d6WCyuLxrDpvF4RUHmCxOd7NaXFzxhcli7u9GVos5098xOXB6LPh8hd1j56y77B6bVnWy
	edy5tofNY97JQI++LasYPT5vkgtgj2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0
	tDBXUshLzE21VXLxCdB1y8wBukxJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEa
	SFjDmHHx0zbWgvkiFRfnrGdtYHwl0MXIySEhYCLx8ncvO4QtJnHh3nq2LkYuDiGB6YwSc/9e
	YYJw2pgkXjV8Z+li5OBgEzCSeHXMDqRBREBBYnPvM1aQGmaBS4wS0/YeYQVJCAtESvxv6QCz
	WQRUJR72nmMEsXkFXCS2brkBtU1BonXZITCbU8BVovXlBWaQ+UJANc0fWSYw8i5gZFjFKJpa
	kFxQnJSea6RXnJhbXJqXrpecn7uJERxpz6R3MK5qsDjEKMDBqMTD6/DsUqAQa2JZcWXuIUYJ
	DmYlEd6Jfy4HCvGmJFZWpRblxxeV5qQWH2JMBjpqIrOUaHI+MAnklcQbGpuYmxqbWppYmJhZ
	kiasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVANj0SL5hQJGH17sOu2dkWuodvAcs9quANlQ
	z437jKsTuruMd2s3Jh+uqVUw7hbd+Fi30WWyAssRidqQB+07xRZ9ZJ539kMR37Mt+nEKlYYX
	OzT1likt0pCuV/nPV7I/PeRMWeAizvUM5tp1E4QrhYuNZG7yz5iseVkmYfXq4rbPXtO+P+av
	ZlBiKc5INNRiLipOBAB/mX+V+AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently driver uses local struct s2mps11_info to store ramp rate for bucks
whic its getting through platform data, so instead of using regulator
constraints it should use s2mps11_info to calculate ramp delay.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/regulator/s2mps11.c |   53 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 0ec9aea..d42ad2a 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -54,6 +54,57 @@ static int get_ramp_delay(int ramp_delay)
 	return cnt;
 }
 
+static int s2mps11_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
+				   unsigned int old_selector,
+				   unsigned int new_selector)
+{
+	struct s2mps11_info *s2mps11 = rdev_get_drvdata(rdev);
+	unsigned int ramp_delay = 0;
+	int old_volt, new_volt;
+
+	switch (rdev->desc->id) {
+	case S2MPS11_BUCK2:
+		if (!s2mps11->buck2_ramp)
+			return 0;
+		ramp_delay = s2mps11->ramp_delay2;
+		break;
+	case S2MPS11_BUCK3:
+		if (!s2mps11->buck3_ramp)
+			return 0;
+		ramp_delay = s2mps11->ramp_delay34;
+		break;
+	case S2MPS11_BUCK4:
+		if (!s2mps11->buck4_ramp)
+			return 0;
+		ramp_delay = s2mps11->ramp_delay34;
+		break;
+	case S2MPS11_BUCK5:
+		ramp_delay = s2mps11->ramp_delay5;
+		break;
+	case S2MPS11_BUCK6:
+		if (!s2mps11->buck6_ramp)
+			return 0;
+	case S2MPS11_BUCK1:
+		ramp_delay = s2mps11->ramp_delay16;
+		break;
+	case S2MPS11_BUCK7:
+	case S2MPS11_BUCK8:
+	case S2MPS11_BUCK10:
+		ramp_delay = s2mps11->ramp_delay7810;
+		break;
+	case S2MPS11_BUCK9:
+		ramp_delay = s2mps11->ramp_delay9;
+	}
+
+	if (ramp_delay == 0)
+		ramp_delay = rdev->desc->ramp_delay;
+
+	old_volt = rdev->desc->min_uV + (rdev->desc->uV_step * old_selector);
+	new_volt = rdev->desc->min_uV + (rdev->desc->uV_step * new_selector);
+
+	return DIV_ROUND_UP(abs(new_volt - old_volt), ramp_delay);
+}
+
 static struct regulator_ops s2mps11_ldo_ops = {
 	.list_voltage		= regulator_list_voltage_linear,
 	.map_voltage		= regulator_map_voltage_linear,
@@ -73,7 +124,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.disable		= regulator_disable_regmap,
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
-	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
+	.set_voltage_time_sel	= s2mps11_regulator_set_voltage_time_sel,
 };
 
 #define regulator_desc_ldo1(num)	{		\
-- 
1.7.0.4


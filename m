Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbaIQD6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 23:58:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44629 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbaIQD6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 23:58:49 -0400
X-AuditID: cbfee68e-f79536d000000fd1-05-541906f7093d
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, r.baldyga@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH v3] extcon: max77693: Fix a bug occured at changing ADC
 debounce time.
Date: Wed, 17 Sep 2014 12:58:43 +0900
Message-id: <1410926323-8234-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsWyRsSkQPc7m2SIwctjvBbXvzxnteg8+4TZ
	4vKuOWwWtxtXsFk8OLyT3YHVo2/LKkaPz5vkApiiuGxSUnMyy1KL9O0SuDL2f3rNXrCKp2LC
	tc+MDYytXF2MnBwSAiYS7TtuMELYYhIX7q1n62Lk4hASWMooser5R3aYoh3PvrJAJKYzSmxt
	6WGGcNqYJL5+u8kMUsUmoCPxf99NsA4RAQWJzb3PWEFsZoESicVn/oLZwgIREv97HrGA2CwC
	qhKPJ3WB9fIKuEtcvnUDaDUH0DYFiTmTbEDmSwjcZpO49Gw1E0S9gMS3yYdYIGpkJTYdYIY4
	TlLi4IobLBMYBRcwMqxiFE0tSC4oTkovMtIrTswtLs1L10vOz93ECAzC0/+e9e1gvHnA+hCj
	AAejEg/vhssSIUKsiWXFlbmHGE2BNkxklhJNzgeGel5JvKGxmZGFqYmpsZG5pZmSOG+C1M9g
	IYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYzOP7Vj7DWKr4bvZbyRvifEQWNXi8ha3yv9elMv
	i4T4n18ovHZu4I4KxcAJLzeu/Ku1h+9il5Svx/kn+89/79xuwLoocM522Un/k6MOO+3/rXZE
	TGGiwBLN0o3Xqk9+naNaHxU1+8LNozt12c5Y7L0zy9ziq8+al48Kqh4dL/4pZH7gugWHa32L
	EktxRqKhFnNRcSIABkZH3D0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t9jQd3vbJIhBn9OsVlc//Kc1aLz7BNm
	i8u75rBZ3G5cwWbx4PBOdgdWj74tqxg9Pm+SC2CKamC0yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFap6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGHM2P/pNXvBKp6KCdc+MzYwtnJ1MXJySAiYSOx49pUFwhaTuHBvPVsXIxeH
	kMB0RomtLT3MEE4bk8TXbzeZQarYBHQk/u+7yQ5iiwgoSGzufcYKYjMLlEgsPvMXzBYWiJD4
	3/MIbCqLgKrE40ldYL28Au4Sl2/dANrAAbRNQWLOJJsJjNwLGBlWMYqmFiQXFCel5xrpFSfm
	Fpfmpesl5+duYgSH+DPpHYyrGiwOMQpwMCrx8G64LBEixJpYVlyZe4hRgoNZSYRX5B5QiDcl
	sbIqtSg/vqg0J7X4EKMp0PKJzFKiyfnA+MsriTc0NjEzsjQyN7QwMjZXEuc92GodKCSQnliS
	mp2aWpBaBNPHxMEp1cCoyKJ7eBdPoPjZ+2/e3/C8Mt3Es/SR2Poz3Bvc7yVZfzq/PGPrh6L5
	VbFrnglaMznNCH6/ud7/VtOXBdJXrqt//NqtJrH1/lRWwY8sS/4771t9vHqFS6iQeV+CeG9R
	w6Ho0rZd6bdkp293qTAVnMP4qrciZG/J52W2949/CttWyx7ExXH3atcKJZbijERDLeai4kQA
	MbJzeIcCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When it writes some value other than 0 to BTLDset and JIGset, muic device
will be reset automatically. And it happens during updating ADC debounce time,
because it shares same register. To update ADC debounce time without reset,
set value only to ADCDbset and 0 to BTLDset and JIGset.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
Changes:
v3:	- Fix typo (regmap_write_bits -> regmap_write)
v2:	- Fix comments.

 drivers/extcon/extcon-max77693.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 77460f2..132540e 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -255,10 +255,15 @@ static int max77693_muic_set_debounce_time(struct max77693_muic_info *info,
 	case ADC_DEBOUNCE_TIME_10MS:
 	case ADC_DEBOUNCE_TIME_25MS:
 	case ADC_DEBOUNCE_TIME_38_62MS:
-		ret = regmap_update_bits(info->max77693->regmap_muic,
-					  MAX77693_MUIC_REG_CTRL3,
-					  CONTROL3_ADCDBSET_MASK,
-					  time << CONTROL3_ADCDBSET_SHIFT);
+		/*
+		 * Don't touch BTLDset, JIGset when you want to change adc
+		 * debounce time. If it writes other than 0 to BTLDset, JIGset
+		 * muic device will be reset and loose current state.
+		 */
+		ret = regmap_write(info->max77693->regmap_muic,
+				  MAX77693_MUIC_REG_CTRL3,
+				  (CONTROL3_ADCDBSET_MASK &
+				  time << CONTROL3_ADCDBSET_SHIFT));
 		if (ret) {
 			dev_err(info->dev, "failed to set ADC debounce time\n");
 			return ret;
-- 
1.7.9.5


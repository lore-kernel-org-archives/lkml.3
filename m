Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab3FAHNL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 03:13:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60002 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab3FAHND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 03:13:03 -0400
X-AuditID: cbfee68f-b7f436d000000f81-9a-51a99efdf2f5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Lee Jones'" <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Subject: [PATCH] mfd: replace strict_strtoul() with kstrtoul()
Date: Sat, 01 Jun 2013 16:13:01 +0900
Message-id: <000501ce5e97$73e05f40$5ba11dc0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5elzSknGmK6MVJTYO1JGDAngwDtg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zI92/81YGGnx4Y2VxeeElVov7X48y
	Wkz5s5zJ4vKuOWwWp7tZLW5taWJzYPO4c20Pm8e8k4EefVtWMXp8X7qG3ePzJrkA1igum5TU
	nMyy1CJ9uwSujEPz97IVPBWoeDNxNVsD40neLkZODgkBE4lHi48yQ9hiEhfurWfrYuTiEBJY
	xijxcs9ZNpiiB/++QyUWMUpMuHgAyvnFKPFs+UQmkCo2ATWJL18Os4PYIgJaEt3HzoMVMQuc
	YJRYcXY22A5hATuJ89tXs4DYLAKqEq8ubgUq4uDgFbCUeD3PFiTMKyAo8WPyPbASZqA563ce
	Z4Kw5SU2r3kLdaqCxI6zrxkhdulJzO/+BlUjIrHvxTtGkL0SAsfYJTbfWc4KsUtA4tvkQywg
	uyQEZCU2HYCaIylxcMUNlgmMYrOQrJ6FZPUsJKtnIVmxgJFlFaNoakFyQXFSepGxXnFibnFp
	Xrpecn7uJkZIDPbvYLx7wPoQYzLQ+onMUqLJ+cAYziuJNzQ2M7IwNTE1NjK3NCNNWEmcV63F
	OlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo/MG8+L56n13d32t876lJ5jkc+LtRZPfxVVJ
	mzelFj3axvjDP3HzwvDE+e8yFk51jFqmEmB6eSWP159Ps1tqAi/KMX4OKNkq+dbtZEZzW2ak
	TaNJ+E7OXzb/9vFrTKmxT1iw58+bjOMi9fOT67nWBeUYq18TeJcgdr337nw9ZmnPcMc5rvxL
	lFiKMxINtZiLihMBXe7OnNcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jAd2/81YGGrw/a2ZxeeElVov7X48y
	Wkz5s5zJ4vKuOWwWp7tZLW5taWJzYPO4c20Pm8e8k4EefVtWMXp8X7qG3ePzJrkA1qgGRpuM
	1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoAOUFMoSc0qB
	QgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBmH5u9lK3gqUPFm4mq2BsaTvF2MnBwS
	AiYSD/59Z4OwxSQu3FsPZHNxCAksYpSYcPEAlPOLUeLZ8olMIFVsAmoSX74cZgexRQS0JLqP
	nQcrYhY4wSix4uxsZpCEsICdxPntq1lAbBYBVYlXF7cCFXFw8ApYSryeZwsS5hUQlPgx+R5Y
	CTPQnPU7jzNB2PISm9e8ZYa4SEFix9nXjBC79CTmd3+DqhGR2PfiHeMERoFZSEbNQjJqFpJR
	s5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHOHPpHYwrmywOMQowMGoxMNrsGJF
	oBBrYllxZe4hRgkOZiUR3vw5QCHelMTKqtSi/Pii0pzU4kOMyUCPTmSWEk3OByafvJJ4Q2MT
	MyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgDGIOkxIy3/i/b1HZRu/j
	kUkfwiojnh369JNT7vG/WJ4DX972xxgZGT/Vcc5IMZ14a5/d1QcGWbcWtuwuLSm7wvdd5HGV
	h9TTRwcyDKU0rGe1nXjhZ8Q+N+7e34f1GY/n7krhuipiJ88tXP+F40cv+9z3gZ0Ox9RPcrk3
	9G15bl7o/Dzk/jwLJZbijERDLeai4kQAYUTTAjQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of strict_strtoul() is not preferred, because
strict_strtoul() is obsolete. Thus, kstrtoul() should be
used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/aat2870-core.c   |    2 +-
 drivers/mfd/ab3100-core.c    |    6 +++---
 drivers/mfd/ab8500-debugfs.c |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/aat2870-core.c b/drivers/mfd/aat2870-core.c
index dfdb0a2..5fd81b9 100644
--- a/drivers/mfd/aat2870-core.c
+++ b/drivers/mfd/aat2870-core.c
@@ -312,7 +312,7 @@ static ssize_t aat2870_reg_write_file(struct file *file,
 	while (*start == ' ')
 		start++;
 
-	if (strict_strtoul(start, 16, &val))
+	if (kstrtoul(start, 16, &val))
 		return -EINVAL;
 
 	ret = aat2870->write(aat2870, (u8)addr, (u8)val);
diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index a9bb140..49cc17e 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -514,13 +514,13 @@ static ssize_t ab3100_get_set_reg(struct file *file,
 	/*
 	 * Advance pointer to end of string then terminate
 	 * the register string. This is needed to satisfy
-	 * the strict_strtoul() function.
+	 * the kstrtoul() function.
 	 */
 	while ((i < buf_size) && (buf[i] != ' '))
 		i++;
 	buf[i] = '\0';
 
-	err = strict_strtoul(&buf[regp], 16, &user_reg);
+	err = kstrtoul(&buf[regp], 16, &user_reg);
 	if (err)
 		return err;
 	if (user_reg > 0xff)
@@ -557,7 +557,7 @@ static ssize_t ab3100_get_set_reg(struct file *file,
 			i++;
 		buf[i] = '\0';
 
-		err = strict_strtoul(&buf[valp], 16, &user_value);
+		err = kstrtoul(&buf[valp], 16, &user_value);
 		if (err)
 			return err;
 		if (user_reg > 0xff)
diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 37b7ce4..11656c2 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -2757,7 +2757,7 @@ static ssize_t show_irq(struct device *dev,
 	unsigned int irq_index;
 	int err;
 
-	err = strict_strtoul(attr->attr.name, 0, &name);
+	err = kstrtoul(attr->attr.name, 0, &name);
 	if (err)
 		return err;
 
-- 
1.7.10.4



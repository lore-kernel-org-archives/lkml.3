Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab3FCJBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:01:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17527 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab3FCJBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:01:47 -0400
X-AuditID: cbfee68f-b7f436d000000f81-ed-51ac5b74fefc
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Lee Jones'" <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        "'Andy Shevchenko'" <andy.shevchenko@gmail.com>
Subject: [PATCH] mfd: replace strict_strtoul() with kstrtoul()
Date: Mon, 03 Jun 2013 18:01:40 +0900
Message-id: <000701ce6038$f64a42a0$e2dec7e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5gOH/y5awrs2VjSbC0PMlveBn5cQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t8zY92S6DWBBnfazS1eTjjMaHF54SVW
	i/tfjzJaTPmznMni8q45bBanu1ktbm1pYnNg99g56y67x51re9g85p0M9OjbsorR4/vSNewe
	nzfJBbBFcdmkpOZklqUW6dslcGX875vDXnBHomLr5S7mBsYzwl2MnBwSAiYSWzc8ZYOwxSQu
	3FsPZHNxCAksY5S48KWFBaZo1tX9zBCJ6YwSV9pnskM4vxgljry6xQhSxSagJvHly2F2EFtE
	QEui+9h5sFHMAj8ZJdrn7wRLCAvYSZzfvhpsLIuAqsS5GXfBbF4BS4m+t7/YIWxBiR+T74HF
	mYEGrd95nAnClpfYvOYtM8RJChI7zr5mhFimJ3Gw8wAjRI2IxL4X7xhBFksIXGKXWLFrCTvE
	MgGJb5MPAQ3lAErISmw6ADVHUuLgihssExjFZiFZPQvJ6llIVs9CsmIBI8sqRtHUguSC4qT0
	ImO94sTc4tK8dL3k/NxNjJDI7N/BePeA9SHGZKD1E5mlRJPzgZGdVxJvaGxmZGFqYmpsZG5p
	RpqwkjivWot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGhwLNJ3M+Tp4esT5TRC6oyIL3
	8ax/596FSbL1LnhV7fjzUMKJP6vPzv5441Kezn2exqvGu6zZk4Lz2nneTJyQrJpkyWLs/Oeo
	RH7Hv6O27lz9PlqMDhteKD9KOKzH8FVoRvd5u2mPMssecgZd+56rdPXu5ebvU2Seukj1eZ69
	usZ77fqzDbt4lViKMxINtZiLihMBYYQU6uICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t9jQd2S6DWBBr8XGlm8nHCY0eLywkus
	Fve/HmW0mPJnOZPF5V1z2CxOd7Na3NrSxObA7rFz1l12jzvX9rB5zDsZ6NG3ZRWjx/ela9g9
	Pm+SC2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
	zAE6RUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8b9vDnvBHYmKrZe7
	mBsYzwh3MXJySAiYSMy6up8ZwhaTuHBvPVsXIxeHkMB0Rokr7TPZIZxfjBJHXt1iBKliE1CT
	+PLlMDuILSKgJdF97DxYB7PAT0aJ9vk7wRLCAnYS57evZgGxWQRUJc7NuAtm8wpYSvS9/cUO
	YQtK/Jh8DyzODDRo/c7jTBC2vMTmNW+hTlKQ2HH2NSPEMj2Jg50HGCFqRCT2vXjHOIFRYBaS
	UbOQjJqFZNQsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgTH/TPpHYyrGiwOMQpw
	MCrx8AZ4rAkUYk0sK67MPcQowcGsJMJ7JRAoxJuSWFmVWpQfX1Sak1p8iDEZ6NOJzFKiyfnA
	lJRXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYzV0069cC/c
	8rP7RzZLk0VX/MmF2zZc3RF4rSCpi0PEZYlb7VL782YXPgvyhr/dkJu/J/fhoS1WVxeKGk6Y
	5coQMflvvclaQ04hobrHYvsNbZJunppRWM3r+MasYrboL9mt12yuRm30bylZ8ML10+tHSndO
	nTdWquUtlA2oyZof9OG8x435xouVWIozEg21mIuKEwEUt5nQPwMAAA==
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
Changes since v1:
- Used return code from kstrtoul().
- Changed the type of 'user_reg' from 'unsigned long' to 'u8'.
- Replaced kstrtoul() with kstrtou8() to handle u8 variable.

 drivers/mfd/aat2870-core.c   |    5 +++--
 drivers/mfd/ab3100-core.c    |   16 ++++++----------
 drivers/mfd/ab8500-debugfs.c |    2 +-
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/aat2870-core.c b/drivers/mfd/aat2870-core.c
index dfdb0a2..d4f5945 100644
--- a/drivers/mfd/aat2870-core.c
+++ b/drivers/mfd/aat2870-core.c
@@ -312,8 +312,9 @@ static ssize_t aat2870_reg_write_file(struct file *file,
 	while (*start == ' ')
 		start++;
 
-	if (strict_strtoul(start, 16, &val))
-		return -EINVAL;
+	ret = kstrtoul(start, 16, &val);
+	if (ret)
+		return ret;
 
 	ret = aat2870->write(aat2870, (u8)addr, (u8)val);
 	if (ret)
diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index a9bb140..9cc1bd3 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -491,7 +491,7 @@ static ssize_t ab3100_get_set_reg(struct file *file,
 	char buf[32];
 	ssize_t buf_size;
 	int regp;
-	unsigned long user_reg;
+	u8 user_reg;
 	int err;
 	int i = 0;
 
@@ -514,22 +514,20 @@ static ssize_t ab3100_get_set_reg(struct file *file,
 	/*
 	 * Advance pointer to end of string then terminate
 	 * the register string. This is needed to satisfy
-	 * the strict_strtoul() function.
+	 * the kstrtou8() function.
 	 */
 	while ((i < buf_size) && (buf[i] != ' '))
 		i++;
 	buf[i] = '\0';
 
-	err = strict_strtoul(&buf[regp], 16, &user_reg);
+	err = kstrtou8(&buf[regp], 16, &user_reg);
 	if (err)
 		return err;
-	if (user_reg > 0xff)
-		return -EINVAL;
 
 	/* Either we read or we write a register here */
 	if (!priv->mode) {
 		/* Reading */
-		u8 reg = (u8) user_reg;
+		u8 reg = user_reg;
 		u8 regvalue;
 
 		ab3100_get_register_interruptible(ab3100, reg, &regvalue);
@@ -540,7 +538,7 @@ static ssize_t ab3100_get_set_reg(struct file *file,
 	} else {
 		int valp;
 		unsigned long user_value;
-		u8 reg = (u8) user_reg;
+		u8 reg = user_reg;
 		u8 value;
 		u8 regvalue;
 
@@ -557,11 +555,9 @@ static ssize_t ab3100_get_set_reg(struct file *file,
 			i++;
 		buf[i] = '\0';
 
-		err = strict_strtoul(&buf[valp], 16, &user_value);
+		err = kstrtoul(&buf[valp], 16, &user_value);
 		if (err)
 			return err;
-		if (user_reg > 0xff)
-			return -EINVAL;
 
 		value = (u8) user_value;
 		ab3100_set_register_interruptible(ab3100, reg, value);
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



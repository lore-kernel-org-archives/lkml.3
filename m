Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab3FDEL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 00:11:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10723 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3FDELx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 00:11:53 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-f4-51ad690777d7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Srinidhi Kasagar'" <srinidhi.kasagar@stericsson.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "'Andy Shevchenko'" <andy.shevchenko@gmail.com>
Subject: [PATCH V3] mfd: replace strict_strtoul() with kstrtoul()
Date: Tue, 04 Jun 2013 13:11:50 +0900
Message-id: <001101ce60d9$a39936a0$eacba3e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5g2Y0ybS5S7ftnQBagu4lAgReeDg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zfV32zLWBBqen8Vu8nHCY0eLywkus
	Fve/HmW0mPJnOZPF5V1z2CxOd7Na3NrSxObA7rFz1l12jzvX9rB5zDsZ6NG3ZRWjx/ela9g9
	Pm+SC2CL4rJJSc3JLEst0rdL4Mro65rAVNAjX7F1bw9bA+N7iS5GTg4JAROJu32/WSFsMYkL
	99azdTFycQgJLGOUaHj8ih2maO6WbnaIxCJGiWNfHjBCOL8YJfpvbmIEqWITUJP48uUwWIeI
	gJZE97HzbCA2s8BfRonnu8tAbGEBR4k9S8+BrWMRUJV4e/UIM4jNK2Ap8fPYA1YIW1Dix+R7
	LBC9WhLrdx5ngrDlJTavecsMcZGCxI6zrxkhdulJTF5zmRWiRkRi34t3YMdJCFxjl1j8fDoj
	xDIBiW+TDwEN5QBKyEpsOgA1R1Li4IobLBMYxWYhWT0LyepZSFbPQrJiASPLKkbR1ILkguKk
	9CITveLE3OLSvHS95PzcTYyQuJywg/HeAetDjMlA6ycyS4km5wPjOq8k3tDYzMjC1MTU2Mjc
	0ow0YSVxXvUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjPX7mA3FrrLa3r3RdKfiT0mw
	/C+/xNkxFvbrNZ8euJlfv8Sv7INz8qPnn8xOHn75PXzCSSepjR0sUzwSHA0EzBcytVq1/j+x
	IyvnqejtC41bUuQS/Nr/LrEI1J/9eN+2s90p28S+/N8SN/W+h/y9rf0aj5lFLulUbeBddu5X
	fJzFin/h80oOb1FiKc5INNRiLipOBAB96LW84QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jAV32zLWBBhf+clq8nHCY0eLywkus
	Fve/HmW0mPJnOZPF5V1z2CxOd7Na3NrSxObA7rFz1l12jzvX9rB5zDsZ6NG3ZRWjx/ela9g9
	Pm+SC2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
	zAE6RUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY0dc1gamgR75i694e
	tgbG9xJdjJwcEgImEnO3dLND2GISF+6tZ+ti5OIQEljEKHHsywNGCOcXo0T/zU2MIFVsAmoS
	X74cBusQEdCS6D52ng3EZhb4yyjxfHcZiC0s4CixZ+k5VhCbRUBV4u3VI8wgNq+ApcTPYw9Y
	IWxBiR+T77FA9GpJrN95nAnClpfYvOYtM8RFChI7zr5mhNilJzF5zWVWiBoRiX0v3jFOYBSY
	hWTULCSjZiEZNQtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwVH/THoH46oGi0OM
	AhyMSjy8ClvWBAqxJpYVV+YeYpTgYFYS4e11WRsoxJuSWFmVWpQfX1Sak1p8iDEZ6NOJzFKi
	yfnAhJRXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYyS312a
	mC91fEysY0sx3Lk+/vRMG+UpCvzT7wmdO8oiF+pw4cD83NSC2h3Vf9bZfLsSFPikZc9yRY4C
	01lTJvPOedUrcaik/LPZhZQr7oW6k70vfCs2VZPg3TJHx9d87f81Tr/7nngG+ykYLHseXzPr
	iMC0uc4PcucKRyQu/Vl9avm6hqZmO0YlluKMREMt5qLiRABmlLPnPgMAAA==
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
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
Changes since v1:
- Removed redundant variables 'u8 reg'.
- Changed the type of 'user_value' from 'unsigned long' to 'u8'.
- Replaced kstrtoul() with kstrtou8() to handle u8 variable.
- Added Andy Shevchenko's Reviewed-by.

Changes since v1:
- Used return code from kstrtoul().
- Changed the type of 'user_reg' from 'unsigned long' to 'u8'.
- Replaced kstrtoul() with kstrtou8() to handle u8 variable.

 drivers/mfd/aat2870-core.c   |    5 +++--
 drivers/mfd/ab3100-core.c    |   28 ++++++++++------------------
 drivers/mfd/ab8500-debugfs.c |    2 +-
 3 files changed, 14 insertions(+), 21 deletions(-)

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
index a9bb140..ddc669d 100644
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
 
@@ -514,34 +514,29 @@ static ssize_t ab3100_get_set_reg(struct file *file,
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
 		u8 regvalue;
 
-		ab3100_get_register_interruptible(ab3100, reg, &regvalue);
+		ab3100_get_register_interruptible(ab3100, user_reg, &regvalue);
 
 		dev_info(ab3100->dev,
 			 "debug read AB3100 reg[0x%02x]: 0x%02x\n",
-			 reg, regvalue);
+			 user_reg, regvalue);
 	} else {
 		int valp;
-		unsigned long user_value;
-		u8 reg = (u8) user_reg;
-		u8 value;
+		u8 user_value;
 		u8 regvalue;
 
 		/*
@@ -557,20 +552,17 @@ static ssize_t ab3100_get_set_reg(struct file *file,
 			i++;
 		buf[i] = '\0';
 
-		err = strict_strtoul(&buf[valp], 16, &user_value);
+		err = kstrtou8(&buf[valp], 16, &user_value);
 		if (err)
 			return err;
-		if (user_reg > 0xff)
-			return -EINVAL;
 
-		value = (u8) user_value;
-		ab3100_set_register_interruptible(ab3100, reg, value);
-		ab3100_get_register_interruptible(ab3100, reg, &regvalue);
+		ab3100_set_register_interruptible(ab3100, user_reg, user_value);
+		ab3100_get_register_interruptible(ab3100, user_reg, &regvalue);
 
 		dev_info(ab3100->dev,
 			 "debug write reg[0x%02x] with 0x%02x, "
 			 "after readback: 0x%02x\n",
-			 reg, value, regvalue);
+			 user_reg, user_value, regvalue);
 	}
 	return buf_size;
 }
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



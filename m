Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab3FCJET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:04:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:8715 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab3FCJES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:04:18 -0400
X-AuditID: cbfee68e-b7f276d000002279-bc-51ac5c0f3ac9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Srinidhi Kasagar'" <srinidhi.kasagar@stericsson.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "'Andy Shevchenko'" <andy.shevchenko@gmail.com>
Subject: [PATCH V2] mfd: replace strict_strtoul() with kstrtoul()
Date: Mon, 03 Jun 2013 18:04:15 +0900
Message-id: <000801ce6039$526d9a00$f748ce00$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5gOUvXV7YQ6ccrSoK4xN8jkywViQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zY13+mDWBBnum2li8nHCY0eLywkus
	Fve/HmW0mPJnOZPF5V1z2CxOd7Na3NrSxObA7rFz1l12jzvX9rB5zDsZ6NG3ZRWjx/ela9g9
	Pm+SC2CL4rJJSc3JLEst0rdL4Mr43zeHveCORMXWy13MDYxnhLsYOTkkBEwkVr45zwxhi0lc
	uLeerYuRi0NIYBmjxI39W5hgin5svMoKkZjOKDGxewczhPOLUeLb1d/sIFVsAmoSX74cBrNF
	BLQkuo+dZwOxmQX+Mko8310GYgsLOEpc+n4arIZFQFXi6tGpYDavgKXEgYbNLBC2oMSPyfdY
	IHq1JNbvPM4EYctLbF7zFupUBYkdZ18zQuzSk9jxaD4jRI2IxL4X7xhBjpMQuMQu0bzsJxPE
	MgGJb5MPAQ3lAErISmw6ADVHUuLgihssExjFZiFZPQvJ6llIVs9CsmIBI8sqRtHUguSC4qT0
	IiO94sTc4tK8dL3k/NxNjJC47NvBePOA9SHGZKD1E5mlRJPzgXGdVxJvaGxmZGFqYmpsZG5p
	RpqwkjivWot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGnElttgqsompfFk1t931i/8xi
	2x/PSJGZ2UXbj/t6XKoqY3ryLPHoxjX7Xxr4zf++QfqYLo9qke/6ec7bKzt0v+vrv7zGHJUz
	v617j6LJky6HoKyyvWff39gv38j5hOfc9uaAVz6m+W3fuVsffKzj/Ki481RZpoNhiq/Ba/Xy
	b2fu90ecFCpXYinOSDTUYi4qTgQAFg2J1eECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jQV3+mDWBBtefmFu8nHCY0eLywkus
	Fve/HmW0mPJnOZPF5V1z2CxOd7Na3NrSxObA7rFz1l12jzvX9rB5zDsZ6NG3ZRWjx/ela9g9
	Pm+SC2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
	zAE6RUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8b9vDnvBHYmKrZe7
	mBsYzwh3MXJySAiYSPzYeJUVwhaTuHBvPVsXIxeHkMB0RomJ3TuYIZxfjBLfrv5mB6liE1CT
	+PLlMJgtIqAl0X3sPBuIzSzwl1Hi+e4yEFtYwFHi0vfTYDUsAqoSV49OBbN5BSwlDjRsZoGw
	BSV+TL7HAtGrJbF+53EmCFteYvOat8wQFylI7Dj7mhFil57EjkfzGSFqRCT2vXjHOIFRYBaS
	UbOQjJqFZNQsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRH/TPpHYyrGiwOMQpw
	MCrx8AZ4rAkUYk0sK67MPcQowcGsJMJ7JRAoxJuSWFmVWpQfX1Sak1p8iDEZ6NOJzFKiyfnA
	hJRXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYx6Sx3ec/9z
	SphR7LxlScAlw/6Pbxas3aS3l61qq+zBTQ4JK2KvBzz1NQvazeSz9lLMzlkGxmmMvG68F0pK
	miJUJijGPog/lu/wcK1T/61znInHVgm2uxxaP0dd+P/dlNtF62+IfZt2KFAodF8Wj9OzyBo/
	7SIWH8+Kry8PMvmX/D30eF3G8jolluKMREMt5qLiRADwVATfPgMAAA==
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



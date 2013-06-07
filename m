Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab3FGBA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 21:00:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19637 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab3FGBA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 21:00:56 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-19-51b130c73ef0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Andy Shevchenko'" <andy.shevchenko@gmail.com>
Subject: [PATCH V3] rtc: rtc-pcf2123: replace strict_strtoul() with kstrtoul()
Date: Fri, 07 Jun 2013 10:00:54 +0900
Message-id: <000001ce631a$769f1640$63dd42c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5jGkB/3TuJY7MRTY62toTFRtOCUA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zY93jBhsDDQ495bNYcvEqu8Wc9WvY
	LF5OOMxocXnhJVaLy7vmsFns7+xgdGDz2DnrLrvHnokn2TxOzPjN4tG3ZRWjx/R5P5k8Pm+S
	C2CL4rJJSc3JLEst0rdL4MpoX7WAreAnd8WD1sVsDYwPOLsYOTkkBEwk7v+6yQZhi0lcuLce
	yObiEBJYxihxb0s7C0xR39cZLBCJRYwSRxpWgnUICfxilLjzQQDEZhNQk/jy5TB7FyMHh4iA
	vkRbiwZIPbPAPkaJc6e+M4LEhQX8JD43x4KUswioSkxdPJURxOYVsJQ48X0tM4QtKPFj8j2w
	vcwCWhLrdx5ngrDlJTavecsMcY+CxI6zr8F6RQT0JOae2csKUSMise/FO0aQvRICt9gldv3Y
	wQyxTEDi2+RDLCA3SAjISmw6ADVHUuLgihssExjFZiFZPQvJ6llIVs9CsmIBI8sqRtHUguSC
	4qT0IkO94sTc4tK8dL3k/NxNjJBo7N3BePuA9SHGZKD1E5mlRJPzgdGcVxJvaGxmZGFqYmps
	ZG5pRpqwkjivWot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGha9dR8QbpTXEskzP5Sy3
	OLRU/cIyk5K91gKMasdnRq/KNIz/LnowPqmsZn7ZkjLWrgf+bzprTtvaTxd8en074zbbRWc2
	X9UTmN9zOXvXqdmaO++nJqd/zLk+1+tczR7uR5+2H6zccFnw/rFH129tb1j6p/OBxr69bAdl
	F2QEODs19cx8Z30mSomlOCPRUIu5qDgRAPaYOh/cAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAd3jBhsDDY7c4LJYcvEqu8Wc9WvY
	LF5OOMxocXnhJVaLy7vmsFns7+xgdGDz2DnrLrvHnokn2TxOzPjN4tG3ZRWjx/R5P5k8Pm+S
	C2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6
	Q0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY0b5qAVvBT+6KB62L2RoY
	H3B2MXJySAiYSPR9ncECYYtJXLi3nq2LkYtDSGARo8SRhpVsIAkhgV+MEnc+CIDYbAJqEl++
	HGbvYuTgEBHQl2hr0QCpZxbYxyhx7tR3RpC4sICfxOfmWJByFgFViamLpzKC2LwClhInvq9l
	hrAFJX5Mvge2l1lAS2L9zuNMELa8xOY1b5kh7lGQ2HH2NViviICexNwze1khakQk9r14xziB
	UWAWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx/oz6R2Mqxos
	DjEKcDAq8fD+WLUhUIg1say4MvcQowQHs5II7ymNjYFCvCmJlVWpRfnxRaU5qcWHGJOBPp3I
	LCWanA9MQ3kl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwFgy
	bZ6i1HX1d1NNjp79oTL1hMuK1anVJt1OV6+3fGv2WxX4fv88hw33F5x9frTCUvH0gqV+5xO8
	bk8vaL4crGhmveigyguf9Sx33ZgV61u6px5jusziclaVlYdTcPdi37rMwvS3XrtTKgv67y9e
	Va67iJ9L8L7/e14l4dWhBx+7VXYZV9a8e67EUpyRaKjFXFScCAB1zoztOQMAAA==
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
Changes since v2:
- Split to two sequential checks.
- Added Andy Shevchenko's Reviewed-by.

Changes since v1:
- Used return code from kstrtoul().

 drivers/rtc/rtc-pcf2123.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-pcf2123.c b/drivers/rtc/rtc-pcf2123.c
index b2a78a0..1725b50 100644
--- a/drivers/rtc/rtc-pcf2123.c
+++ b/drivers/rtc/rtc-pcf2123.c
@@ -94,8 +94,9 @@ static ssize_t pcf2123_show(struct device *dev, struct device_attribute *attr,
 
 	r = container_of(attr, struct pcf2123_sysfs_reg, attr);
 
-	if (strict_strtoul(r->name, 16, &reg))
-		return -EINVAL;
+	ret = kstrtoul(r->name, 16, &reg);
+	if (ret)
+		return ret;
 
 	txbuf[0] = PCF2123_READ | reg;
 	ret = spi_write_then_read(spi, txbuf, 1, rxbuf, 1);
@@ -117,9 +118,13 @@ static ssize_t pcf2123_store(struct device *dev, struct device_attribute *attr,
 
 	r = container_of(attr, struct pcf2123_sysfs_reg, attr);
 
-	if (strict_strtoul(r->name, 16, &reg)
-		|| strict_strtoul(buffer, 10, &val))
-		return -EINVAL;
+	ret = kstrtoul(r->name, 16, &reg);
+	if (ret)
+		return ret;
+
+	ret = kstrtoul(buffer, 10, &val);
+	if (ret)
+		return ret;
 
 	txbuf[0] = PCF2123_WRITE | reg;
 	txbuf[1] = val;
-- 
1.7.10.4



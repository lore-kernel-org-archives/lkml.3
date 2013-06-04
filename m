Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab3FDEM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 00:12:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21134 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3FDEMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 00:12:53 -0400
X-AuditID: cbfee691-b7fef6d000002d62-05-51ad6944c487
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        "'Eric Piel'" <eric.piel@tremplin-utc.net>,
        "'Dimitri Sivanich'" <sivanich@sgi.com>, "'Robin Holt'" <holt@sgi.com>,
        "'Andy Shevchenko'" <andy.shevchenko@gmail.com>
Subject: [PATCH V3] rtc: rtc-pcf2123: replace strict_strtoul() with kstrtoul()
Date: Tue, 04 Jun 2013 13:12:52 +0900
Message-id: <001201ce60d9$c815e190$5841a4b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5g2bD3wVgLUFTeR1ixX2XEahq85A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zY12XzLWBBiePi1i8nHCY0eLvpGPs
	Fof/XmKxaF68ns2if1oHq8XlhZeAxK45bBYTDm9mt5i8pY3dgdPj1VVHj9+/JjF67Jx1l91j
	/9w17B59W1Yxety9/pLJ40ILt8fnTXIBHFFcNimpOZllqUX6dglcGdPWzWAq+MNdsWv5MqYG
	xsecXYycHBICJhJLn19ghbDFJC7cW88GYgsJLGOU+LXAGqbmwskbjF2MXEDx6YwSLWfWM0MU
	/WKU2LU4HMRmE1CT+PLlMDuILSJgKrHx/RSwBmaBPUwST7ZtB9rAwSEs4CfxuTkWpIZFQFWi
	8/A+sMW8ApYS39dPYoKwBSV+TL7HAmIzC2hJrN95nAnClpfYvOYtM8RBChI7zr5mhNilJ7Hn
	02qoGhGJfS/ege2VEPjJLjFz818miGUCEt8mH2IBuUFCQFZi0wGoOZISB1fcYJnAKDYLyepZ
	SFbPQrJ6FpIVCxhZVjGKphYkFxQnpReZ6hUn5haX5qXrJefnbmKExO7EHYz3D1gfYkwGWj+R
	WUo0OR8Y+3kl8YbGZkYWpiamxkbmlmakCSuJ86q3WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi
	4JRqYDRYcHGtkt7WYu/PEdMFp8TMd1/WKOO2n08/fUHbTwGHdVdtUs4GNyem6jAGRF17ybvl
	xEnF+JvnjPJX6MZf1TQKYJFYelGqXf6jx4ab1w0Mz7qamh083F2o6DRh1xLR/yG+HAVJzpty
	Go9tdddarbzjkdqHBm4BZg0z0+UPblTNmrks+FWttRJLcUaioRZzUXEiAG+V7vDzAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jQV2XzLWBBnsaBSxeTjjMaPF30jF2
	i8N/L7FYNC9ez2bRP62D1eLywktAYtccNosJhzezW0ze0sbuwOnx6qqjx+9fkxg9ds66y+6x
	f+4ado++LasYPe5ef8nkcaGF2+PzJrkAjqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMD
	Q11DSwtzJYW8xNxUWyUXnwBdt8wcoPOUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1
	GBmggYR1jBnT1s1gKvjDXbFr+TKmBsbHnF2MnBwSAiYSF07eYISwxSQu3FvP1sXIxSEkMJ1R
	ouXMemaQhJDAL0aJXYvDQWw2ATWJL18Os4PYIgKmEhvfT2EEaWAW2MMk8WTbdtYuRg4OYQE/
	ic/NsSA1LAKqEp2H97GC2LwClhLf109igrAFJX5MvscCYjMLaEms33mcCcKWl9i85i0zxEEK
	EjvOvmaE2KUnsefTaqgaEYl9L94xTmAUmIVk1Cwko2YhGTULScsCRpZVjKKpBckFxUnpuYZ6
	xYm5xaV56XrJ+bmbGMGp4ZnUDsaVDRaHGAU4GJV4eCu2rQkUYk0sK67MPcQowcGsJMLb67I2
	UIg3JbGyKrUoP76oNCe1+BBjMtCnE5mlRJPzgWkrryTe0NjEzMjSyMzCyMTcnDRhJXHeA63W
	gUIC6YklqdmpqQWpRTBbmDg4pRoY3S53rp1+d9kDpwdbrtu4X8qcob9wwuaUH2aS1c+DDPUM
	+ZNkWbSEyp4pnfs6+3Sfac2jme/vSqZnvBJJvcg8Jz1bJuoBc7vbtpb32azfvx8xmaHkMnGb
	QwlryLGHMmXxBvt3H/7DWaMQubNHU/KxbruST7sog5zLbGOXftsP1Xcvypba3lVUYinOSDTU
	Yi4qTgQAC3wTElEDAAA=
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
- Splitted to two sequential checks.
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



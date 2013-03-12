Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab3CLFxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:53:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:31063 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab3CLFxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:53:47 -0400
X-AuditID: cbfee68e-b7f946d000001e37-58-513ec2ea1dad
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
In-reply-to: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
Subject: [PATCH 14/14] backlight: tdo24m: convert tdo24m to dev_pm_ops
Date: Tue, 12 Mar 2013 14:53:46 +0900
Message-id: <004b01ce1ee5$f612bbd0$e2383370$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4e5UhyF7eo33BPTaGekL6G0bVCBQAAJ6EA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t8zY91Xh+wCDY5e0LW4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZjXO2MBe08VU8OT+HsYHxDHcXIyeHhICJxKmfXxghbDGJC/fW
	s4HYQgLLGCV2nCmEqdk9cRlzFyMXUHwRo8TD3dtYIYpmM0l8aXcEsdkE1CS+fDnM3sXIwSEi
	oC/R1qIBEmYWKJXY+uA9C0S5rcTd9c8ZQUo4BewktvzNAgkLC7hJvJyzgB3EZhFQlXi9eAYT
	iM0LVN7e3w9lC0r8mHyPBWKklsT6nceZIGx5ic1r3jKDjJQQUJd49FcXJCwiYCSx8sNVNogS
	EYl9L95BfbiMXWLDqSKIVQIS3yYfYoFolZXYdIAZokRS4uCKGywTGCVmIVk8C8niWUgWz0Ky
	YQEjyypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MkIjq28F484D1IcZkoPUTmaVEk/OBEZlX
	Em9obGZkYWpiamxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkapu5uC
	BK6+PNlwLva5qd79NVqX7U8cunW09LgiQ7fwx1M2kz8kZi8Sui9klOw4ubI9U+7uGRarlzmK
	69SPem154fv4Cethz3t+Cer7xNcnX/tvcnDGQwXHr3VlzbGeonmc66MjWRpuLxbas27fkwN3
	11T7rHRMkFXtZLnfW9Yt+/PtTod9Hh1KLMUZiYZazEXFiQAQsUBnvgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgO6rQ3aBBn/3aFhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjMY5W5gL2vgqnpyfw9jA
	eIa7i5GTQ0LARGL3xGXMELaYxIV769m6GLk4hAQWMUo83L2NFSQhJDCbSeJLuyOIzSagJvHl
	y2H2LkYODhEBfYm2Fg2QMLNAqcTWB+9ZIMptJe6uf84IUsIpYCex5W8WSFhYwE3i5ZwF7CA2
	i4CqxOvFM5hAbF6g8vb+fihbUOLH5HssECO1JNbvPM4EYctLbF7zlhlkpISAusSjv7ogYREB
	I4mVH66yQZSISOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L
	10vOz93ECI7ZZ9I7GFc1WBxiFOBgVOLhVfhmGyjEmlhWXJl7iFGCg1lJhDdjs12gEG9KYmVV
	alF+fFFpTmrxIcZkoEcnMkuJJucD00leSbyhsYmZkaWRmYWRibk5acJK4rwHW60DhQTSE0tS
	s1NTC1KLYLYwcXBKNTAy/uC589unZ1Gd0mIhg8y8iGU6VrN/qG6sXV7769l52+QPqbvZHQPn
	NDAuL/H++WK220Smyh1svspV2T/Uty8569XP3em03VTKKqd4FqsDx4Qc/4PRX58/SC2U9Wjy
	cD9UILyH//PpSnm91U9Z5BbfMjnoKnGuY93uhlX6BZvXmHvWNSWrhiuxFGckGmoxFxUnAgDn
	IpUZHQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/tdo24m.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/video/backlight/tdo24m.c b/drivers/video/backlight/tdo24m.c
index 0016208..18cdf46 100644
--- a/drivers/video/backlight/tdo24m.c
+++ b/drivers/video/backlight/tdo24m.c
@@ -412,25 +412,24 @@ static int tdo24m_remove(struct spi_device *spi)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int tdo24m_suspend(struct spi_device *spi, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int tdo24m_suspend(struct device *dev)
 {
-	struct tdo24m *lcd = spi_get_drvdata(spi);
+	struct tdo24m *lcd = dev_get_drvdata(dev);
 
 	return tdo24m_power(lcd, FB_BLANK_POWERDOWN);
 }
 
-static int tdo24m_resume(struct spi_device *spi)
+static int tdo24m_resume(struct device *dev)
 {
-	struct tdo24m *lcd = spi_get_drvdata(spi);
+	struct tdo24m *lcd = dev_get_drvdata(dev);
 
 	return tdo24m_power(lcd, FB_BLANK_UNBLANK);
 }
-#else
-#define tdo24m_suspend	NULL
-#define tdo24m_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(tdo24m_pm_ops, tdo24m_suspend, tdo24m_resume);
+
 /* Power down all displays on reboot, poweroff or halt */
 static void tdo24m_shutdown(struct spi_device *spi)
 {
@@ -443,12 +442,11 @@ static struct spi_driver tdo24m_driver = {
 	.driver = {
 		.name		= "tdo24m",
 		.owner		= THIS_MODULE,
+		.pm		= &tdo24m_pm_ops,
 	},
 	.probe		= tdo24m_probe,
 	.remove		= tdo24m_remove,
 	.shutdown	= tdo24m_shutdown,
-	.suspend	= tdo24m_suspend,
-	.resume		= tdo24m_resume,
 };
 
 module_spi_driver(tdo24m_driver);
-- 
1.7.2.5



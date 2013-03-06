Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab3CFFay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:30:54 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:28652 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab3CFFax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:30:53 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-a7-5136d48c1e02
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 11/30] rtc: rtc-lp8788: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:30:51 +0900
Message-id: <004d01ce1a2b$c44f99b0$4ceecd10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAAH6Ig
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zQ92eK2aBBt3n+C0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGxhvfmApmcVQ82ridrYHxA1sXIyeHhICJxL+N2xkhbDGJC/fW
	A8W5OIQEljFKnP75lrWLkQOsaHUrD0R8EaPExTsfmSCc2UwSS6YvZwXpZhNQk/jy5TA7SIOI
	gL5EW4sGSA2zQC+jxJne3ewgNUICthJXu1cxg9icAnYSyx/PYgGxhQXcJE5N/QtmswioAtXc
	ZQKxeYHqN9/sY4ewBSV+TL4HVsMsoCWxfudxJghbXmLzmrfMEIeqSzz6qwsSFhEwktjyfg0j
	RImIxL4X7xhB7pEQWMYu0bvtORPELgGJb5MPsUD0ykpsOsAMCQhJiYMrbrBMYJSYhWTzLCSb
	ZyHZPAvJigWMLKsYRVMLkguKk9KLjPSKE3OLS/PS9ZLzczcxQiKrbwfjzQPWhxiTgdZPZJYS
	Tc4HRmZeSbyhsbGJmYmpibmlqbkpacJK4rzyl2QChQTSE0tSs1NTC1KL4otKc1KLDzEycXBK
	NTBK9b9/LKPFdHi2zgrThNYLllG7l4TvaJ4jHeG5tt8/6Ovn268tY2J6r2jLf1WQa+X8s9FR
	cnPmO98Ku3TtyuZ1y8t5nNdIef/6aJv8smuN1fFXRWLej1w22zlEXv8RpjnpwmWHj0oJZbbs
	i7bXPX3G335h7+OtJQrvjs/fUM35x7SdRX7SiRtKLMUZiYZazEXFiQB0x6inwgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgG7PFbNAg9ajnBaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY+ONb0wFszgqHm3cztbA
	+IGti5GDQ0LARGJ1K08XIyeQKSZx4d56oDAXh5DAIkaJi3c+MkE4s5kklkxfzgpSxSagJvHl
	y2F2kGYRAX2JthYNkBpmgV5GiTO9u9lBaoQEbCWudq9iBrE5Bewklj+exQJiCwu4SZya+hfM
	ZhFQBaq5ywRi8wLVb77Zxw5hC0r8mHwPrIZZQEti/c7jTBC2vMTmNW+ZIY5Wl3j0VxckLCJg
	JLHl/RpGiBIRiX0v3jFOYBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnp
	esn5uZsYwXH7THoH46oGi0OMAhyMSjy8E1TMAoVYE8uKK3MPMUpwMCuJ8HKdAQrxpiRWVqUW
	5ccXleakFh9iTAZ6dCKzlGhyPjCl5JXEGxqbmBlZGplZGJmYm5MmrCTOy3jqSYCQQHpiSWp2
	ampBahHMFiYOTqkGRhHJlK3mkmvil76ZlrW+3mz/xQuTb57eyieQ9v8pw/qYxKfHXtvwKz9L
	u330VEv49ZIy2ye/k3d6fHoUv9PigpHXxRslD/i2Nhb7HpTamsjuqdxh3fLFdVbQBtknARce
	KNtw3DPvuTL7Ld+aDUL50R7bxY/zCgtm/VpkUFu3R+Ah+86I2IffJimxFGckGmoxFxUnAgAj
	/3G8HwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-lp8788.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-lp8788.c b/drivers/rtc/rtc-lp8788.c
index 9a46312..b399a41 100644
--- a/drivers/rtc/rtc-lp8788.c
+++ b/drivers/rtc/rtc-lp8788.c
@@ -299,7 +299,7 @@ static int lp8788_rtc_probe(struct platform_device *pdev)
 
 	device_init_wakeup(dev, 1);
 
-	rtc->rdev = rtc_device_register("lp8788_rtc", dev,
+	rtc->rdev = devm_rtc_device_register("lp8788_rtc", dev,
 					&lp8788_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rdev)) {
 		dev_err(dev, "can not register rtc device\n");
@@ -314,9 +314,6 @@ static int lp8788_rtc_probe(struct platform_device *pdev)
 
 static int lp8788_rtc_remove(struct platform_device *pdev)
 {
-	struct lp8788_rtc *rtc = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(rtc->rdev);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.7.2.5



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab3FGC1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 22:27:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14920 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab3FGC1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 22:27:49 -0400
X-AuditID: cbfee68f-b7f436d000000f81-d0-51b145234e58
From: Jingoo Han <jg1.han@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        shuah.kh@samsung.com, shuahkhan@gmail.com,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V2] drivers/rtc/class: convert from Legacy pm ops to dev_pm_ops
Date: Fri, 07 Jun 2013 11:27:46 +0900
Message-id: <000301ce6326$98df9660$ca9ec320$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5jJncjaDTr8BPFT+qb2qZHilxBvA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zQ11l142BBge3KFgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORosvn7ksvv50cGD32DnrLrvHnokn2TxOzPjN4tG3ZRWjx/R5P5k8
	Pm+SC2CL4rJJSc3JLEst0rdL4MqYMnsqW8FxwYp/974wNzBe5+ti5OSQEDCRWL7uLCOELSZx
	4d56ti5GLg4hgWWMEq/m7GaFKVrSc50VIrGIUaJv42ewhJDAL0aJP39EQWw2ATWJL18Os4PY
	IgK6Eque72IGaWAWuMMoMeXrJBaQhLCAv8T/11fAilgEVCU+PfzMBGLzClhK9D35xgxhC0r8
	mHwPrJ5ZQEti/c7jTBC2vMTmNW+ZIS5SkNhx9jUjxDI9idn7OtkhakQk9r14xwiyWELgFrvE
	7ZO9UMsEJL5NPgQ0lAMoISux6QDUHEmJgytusExgFJuFZPUsJKtnIVk9C8mKBYwsqxhFUwuS
	C4qT0ouM9YoTc4tL89L1kvNzNzFC4rJ/B+PdA9aHGJOB1k9klhJNzgfGdV5JvKGxmZGFqYmp
	sZG5pRlpwkrivGot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGB1i+E6byYQpBWpPE+/6
	o/VA8XFIxi0lw46l0pvYVjKXz5ecbmYt+PwmI9sHriV7OXU2ZG0Wm3Dut+J3ptd2wUeZv0yO
	unU4Zn71C+adCz5N3KvHyGJaf2num4ZUfueTKz0qqwPc1IODnH7tmrHhTYPk/wxhmzlvJk3Z
	63Tkzb5rafvcl/nVpymxFGckGmoxFxUnAgDP3SMH4QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jAV1l142BBu9apC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHo8WXz1wWX386OLB77Jx1l91jz8STbB4nZvxm8ejbsorRY/q8n0we
	nzfJBbBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl
	5gCdoqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMmDJ7KlvBccGKf/e+
	MDcwXufrYuTkkBAwkVjSc50VwhaTuHBvPVsXIxeHkMAiRom+jZ/BEkICvxgl/vwRBbHZBNQk
	vnw5zA5iiwjoSqx6vosZpIFZ4A6jxJSvk1hAEsIC/hL/X18BK2IRUJX49PAzE4jNK2Ap0ffk
	GzOELSjxY/I9sHpmAS2J9TuPM0HY8hKb17xlhrhIQWLH2deMEMv0JGbv62SHqBGR2PfiHeME
	RoFZSEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHPXPpHYwrmyw
	OMQowMGoxMP7c9WGQCHWxLLiytxDjBIczEoivKc0NgYK8aYkVlalFuXHF5XmpBYfYkwG+nQi
	s5Rocj4wIeWVxBsam5gZWRqZWRiZmJuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dUAyP3
	653ly7c8dp9yw7m3xPJCq7PdPp7Xl9d3mhbZNHueT+Cc47qw99bFaQt3fdv6QsB2X3dFsVpe
	u5ff0oIzyvumlK3aHu0psr2++Lz2YY3ey9enbA4sOmhq9ODw4n6mD2emPVw+bU3gjRmLdR8x
	lF7gEVnS4cN89ezRZFn/BdvOXHSzX1P26CKLEktxRqKhFnNRcSIAkPONhT4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shuah Khan <shuah.kh@samsung.com>

Convert drivers/rtc/class to use dev_pm_ops for power management and
remove Legacy PM ops hooks.  With this change, rtc class registers
suspend/resume callbacks via class->pm (dev_pm_ops) instead of Legacy
class->suspend/resume.  When __device_suspend() runs call-backs, it will
find class->pm ops for the rtc class.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Shuah Khan <shuahkhan@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
---
Changes since v1:
- Added 'RTC_CLASS_DEV_PM_OPS' to fix buill errors.
- Replaced '#if defined(CONFIG_PM)' with '#if defined(CONFIG_PM_SLEEP)'.

 drivers/rtc/class.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 6638540..0242681 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -38,7 +38,7 @@ static void rtc_device_release(struct device *dev)
 int rtc_hctosys_ret = -ENODEV;
 #endif
 
-#if defined(CONFIG_PM) && defined(CONFIG_RTC_HCTOSYS_DEVICE)
+#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_RTC_HCTOSYS_DEVICE)
 /*
  * On suspend(), measure the delta between one RTC and the
  * system's wall clock; restore it on resume().
@@ -47,7 +47,7 @@ int rtc_hctosys_ret = -ENODEV;
 static struct timespec old_rtc, old_system, old_delta;
 
 
-static int rtc_suspend(struct device *dev, pm_message_t mesg)
+static int rtc_suspend(struct device *dev)
 {
 	struct rtc_device	*rtc = to_rtc_device(dev);
 	struct rtc_time		tm;
@@ -135,9 +135,10 @@ static int rtc_resume(struct device *dev)
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(rtc_class_dev_pm_ops, rtc_suspend, rtc_resume);
+#define RTC_CLASS_DEV_PM_OPS	(&rtc_class_dev_pm_ops)
 #else
-#define rtc_suspend	NULL
-#define rtc_resume	NULL
+#define RTC_CLASS_DEV_PM_OPS	NULL
 #endif
 
 
@@ -336,8 +337,7 @@ static int __init rtc_init(void)
 		pr_err("couldn't create class\n");
 		return PTR_ERR(rtc_class);
 	}
-	rtc_class->suspend = rtc_suspend;
-	rtc_class->resume = rtc_resume;
+	rtc_class->pm = RTC_CLASS_DEV_PM_OPS;
 	rtc_dev_init();
 	rtc_sysfs_init(rtc_class);
 	return 0;
-- 
1.7.10.4



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbaKDPMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:12:54 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57614 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbaKDPKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:10:54 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-6f-5458ec7c7e7d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
Cc: Anton Vorontsov <anton@enomsg.org>, Pavel Machek <pavel@ucw.cz>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND v2 7/7] mfd: ab8500: Decrement the power supply's device
 reference counter
Date: Tue, 04 Nov 2014 16:10:36 +0100
Message-id: <1415113836-26098-8-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415113836-26098-1-git-send-email-k.kozlowski@samsung.com>
References: <1415113836-26098-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t/xy7o1byJCDK7+57Q4uFXTYuOM9awW
	S5oyLCY9ec9sMXHlZGaLaRvFLV6/MLRYtvgpo8XZpjfsFve/HmW0mPJnOZPFpsfXWC0u75rD
	ZvG59wijxcelG1gt1h65y25x6cACJou7p46yWTxe8Zbd4nQ3q8Xp3SUWmzdNZbb4seExq4O4
	x4T+T4weO2fdZfdYsKnUY/MKLY/Fe14yeWxa1cnmcefaHjaPd+fOsXvMOxnosXlJvcfHp7dY
	PN7vu8rm0bdlFaPHitXf2T0+b5LzONHyhTVAIIrLJiU1J7MstUjfLoEro+NUJ1PBNvaKHadu
	szQw9rJ1MXJySAiYSExcP40FwhaTuHBvPVCci0NIYCmjxMbJu9ghnD4miZlty8A62ASMJTYv
	XwJWJSLQyCpxbusbJhCHWaCDSeJ2y05WkCphgWSJKwc2MncxcnCwCKhK3LoTARLmFXCX+Hfp
	MDPEOjmJk8cmg5VzCnhI7Gz5zw5iCwHVvNm4nXUCI+8CRoZVjKKppckFxUnpuUZ6xYm5xaV5
	6XrJ+bmbGCEx9XUH49JjVocYBTgYlXh4V8RHhAixJpYVV+YeYpTgYFYS4VV/DBTiTUmsrEot
	yo8vKs1JLT7EyMTBKdXAGBqtKpeZ2z+rhe3Qgfqsf03XLh3+YnHzgFZ7ke06NaVlG578+3dL
	gtldTeNl96/pAmHrtov4n952U/FsufbypwnvWrc9ub41tepVatebdzvWRgV5zEkv2LhuSWqg
	86W1j8u2PbTo2Ohq/qXoi/4UXcsJR7PMpqu47bbplohhEzGft9KJfUG8pxJLcUaioRZzUXEi
	ADCcKpyHAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use power_supply_put() to decrement the power supply's device reference
counter.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-sysctrl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
index f7f44b34896a..962f32492647 100644
--- a/drivers/mfd/ab8500-sysctrl.c
+++ b/drivers/mfd/ab8500-sysctrl.c
@@ -51,6 +51,7 @@ static void ab8500_power_off(void)
 
 		ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_ONLINE,
 				&val);
+		power_supply_put(psy);
 
 		if (!ret && val.intval) {
 			charger_present = true;
@@ -73,6 +74,7 @@ static void ab8500_power_off(void)
 			       pss[i]);
 			machine_restart("charging");
 		}
+		power_supply_put(psy);
 	}
 
 shutdown:
-- 
1.9.1


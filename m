Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaJPHm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:42:29 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36874 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaJPHmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:42:24 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-69-543f76deadfa
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
Cc: Anton Vorontsov <anton@enomsg.org>, Pavel Machek <pavel@ucw.cz>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v2 7/7] mfd: ab8500: Decrement the power supply's device
 reference counter
Date: Thu, 16 Oct 2014 09:42:07 +0200
Message-id: <1413445327-24862-8-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413445327-24862-1-git-send-email-k.kozlowski@samsung.com>
References: <1413445327-24862-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsVy+t/xa7r3yuxDDHZfkLc4uFXTYuOM9awW
	S5oyLCY9ec9sMXHlZGaLaRvFLV6/MLRYtvgpo8XZpjfsFve/HmW0mPJnOZPFpsfXWC0u75rD
	ZvG59wijxcelG1gt1h65y25x6cACJou7p46yWTxe8Zbd4nQ3q8Xp3SUWmzdNZbb4seExq4O4
	x4T+T4weO2fdZfdYsKnUY/MKLY/Fe14yeWxa1cnmcefaHjaPd+fOsXvMOxnosXlJvcfHp7dY
	PN7vu8rm0bdlFaPHitXf2T0+b5LzONHyhTVAIIrLJiU1J7MstUjfLoEr403fWraCa2wVX069
	YWpg3M7axcjJISFgIvH13iIWCFtM4sK99WxdjFwcQgJLGSXe35/ECuH0MUl09z0B62ATMJbY
	vHwJWJWIwCZWiW0rFjCBOMwC1xklVl+9zd7FyMEhLBAjMfV2KYjJIqAqMWe1JIjJK+Auseit
	O8QyOYmTxyaDjeQU8JD43zuXCcQWAiq5+6addQIj7wJGhlWMoqmlyQXFSem5hnrFibnFpXnp
	esn5uZsYIfH0ZQfj4mNWhxgFOBiVeHg1gu1DhFgTy4orcw8xSnAwK4nwNhcChXhTEiurUovy
	44tKc1KLDzEycXBKNTA2H09Jr3QxWH4zdOdfnpBPTcm//Ku3hLf2C77pE5Zs2vVrybI5tdqc
	RnOOpn5UcAo6prxmWqmE1r7ZZ/X7GXq/MHGIZSj9DOnQ+a404WY19/SVZ8yn3Au5Hca2f9G2
	FNZ74RpzxJ7yzDLZeOm896Poq5MWL2j5bb9q+rK+JJ+tCg0n473sG9mVWIozEg21mIuKEwHR
	v5mVhQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use power_supply_put() to decrement the power supply's device reference
counter.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/mfd/ab8500-sysctrl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
index 93b2d2c32ca3..d05a5719cfc4 100644
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


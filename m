Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbaJPHdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:33:47 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33231 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaJPHdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:33:38 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-02-543f74d01c73
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Anton Vorontsov <anton@enomsg.org>, Guenter Roeck <linux@roeck-us.net>,
        Pavel Machek <pavel@ucw.cz>, Myungjoo Ham <myungjoo.ham@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 6/8] power: apm_power: Use power_supply_*() API for
 accessing function attrs
Date: Thu, 16 Oct 2014 09:32:55 +0200
Message-id: <1413444777-24107-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413444777-24107-1-git-send-email-k.kozlowski@samsung.com>
References: <1413444777-24107-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xy7oXSuxDDB5dYrM4uFXTYuOM9awW
	k568Z7aYuHIys0Xn2SfMFq9fGFqcbXrDbnH/61FGiyl/ljNZbHp8jdXi8q45bBafe48wWjxZ
	eIbJYu2Ru+wWtxtXsFncPXWUzeJ0N6vF6d0lDkIeE/o/MXrsnHWX3WPzCi2PTas62TzuXNvD
	5jHvZKDH5iX1Hju/N7B79G1ZxeixYvV3do/Pm+QCuKO4bFJSczLLUov07RK4MiYt+MBY8I+j
	4vumr4wNjNfYuxg5OSQETCTufp7GCGGLSVy4t56ti5GLQ0hgKaNE19efzBBOH5PEzkuXwDrY
	BIwlNi9fAlYlInCdSaJzxQQWEIdZoJFZ4l1DMxNIlbBAokT3uTNAczk4WARUJV6d4gIJ8wq4
	S2zpvMsKsU5O4uSxyWA2p4CHxPSzV8EWCAHVNE7YzzaBkXcBI8MqRtHU0uSC4qT0XCO94sTc
	4tK8dL3k/NxNjJCg/7qDcekxq0OMAhyMSjy8GsH2IUKsiWXFlbmHGCU4mJVEeJsLgUK8KYmV
	ValF+fFFpTmpxYcYmTg4pRoYtwq2zmk1/bFHjmeSvGhF227pYMfougtFilc9m/hPr5W9vO7k
	wQnhqz/cny/6QuOKm9CEHU9ca9Y7LzFP+dl75EZI42Uvbe9ZJ0yL7V5ddfOwOJkqtYspgn1+
	7Qf//dO2n7lft3D+WiW1XavXr7794/CclzPUCieELaySOajLyvCtzSCFa5rtESWW4oxEQy3m
	ouJEAFfrvaFYAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace direct calls to power supply function attributes with wrappers.
Wrappers provide safe access in case of unregistering the power
supply (e.g. by removing the driver). Replace:
 - get_property -> power_supply_get_property

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Jonghwa Lee <jonghwa3.lee@samusng.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/power/apm_power.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/apm_power.c b/drivers/power/apm_power.c
index 39763015b360..2206f9ff6488 100644
--- a/drivers/power/apm_power.c
+++ b/drivers/power/apm_power.c
@@ -15,10 +15,10 @@
 #include <linux/apm-emulation.h>
 
 
-#define PSY_PROP(psy, prop, val) (psy->get_property(psy, \
+#define PSY_PROP(psy, prop, val) (power_supply_get_property(psy, \
 			 POWER_SUPPLY_PROP_##prop, val))
 
-#define _MPSY_PROP(prop, val) (main_battery->get_property(main_battery, \
+#define _MPSY_PROP(prop, val) (power_supply_get_property(main_battery, \
 							 prop, val))
 
 #define MPSY_PROP(prop, val) _MPSY_PROP(POWER_SUPPLY_PROP_##prop, val)
-- 
1.9.1


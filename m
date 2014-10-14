Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbaJNMWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:22:03 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:14505 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194AbaJNMVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:21:07 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-07-543d1530042a
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
Subject: [PATCH 6/8] power: apm_power: Use power_supply_*() API for accessing
 function attrs
Date: Tue, 14 Oct 2014 14:20:44 +0200
Message-id: <1413289246-31650-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413289246-31650-1-git-send-email-k.kozlowski@samsung.com>
References: <1413289246-31650-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t/xq7oGorYhBleOWloc3KppsXHGelaL
	SU/eM1tMXDmZ2aLz7BNmi9cvDC3ONr1ht7j/9SijxZQ/y5ksNj2+xmpxedccNovPvUcYLZ4s
	PMNksfbIXXaL240r2CzunjrKZnG6m9Xi9O4SByGPCf2fGD12zrrL7rF5hZbHplWdbB53ru1h
	85h3MtBj85J6j53fG9g9+rasYvRYsfo7u8fnTXIB3FFcNimpOZllqUX6dglcGR+3shas4ahY
	PbWVuYGxl72LkZNDQsBE4vyE+WwQtpjEhXvrwWwhgaWMEjfWJHUxcgHZfUwS06b0MIMk2ASM
	JTYvX8IGkhARuM4k0bliAguIwyzQyCzxrqGZCaRKWCBO4tmCqWAdLAKqEo8nXGAFsXkF3CVW
	HJnDArFOTuLksclgcU4BD4mVi46wQKx2l2g/eZttAiPvAkaGVYyiqaXJBcVJ6bmGesWJucWl
	eel6yfm5mxghIf9lB+PiY1aHGAU4GJV4eAsibUKEWBPLiitzDzFKcDArifAqcNiGCPGmJFZW
	pRblxxeV5qQWH2Jk4uCUamDMWrN4gVSn2+wv7zkLWSx2uG0SmOi6eGZk3UFtGc652cK34nyb
	p+2fvUtm8t4n3xPinla9/KM0VZ6392TSlYm1ExdH3wj5svy2mdQsr8XZqcZ/w0yPmTLP3XNK
	i/2FzRuPc6E+ZYrCt2O+Lvu5LtB3Y+MZ3tnF3vlKnVuW9Zn12rHHldZoyj1UYinOSDTUYi4q
	TgQAwuf121cCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace direct calls to power supply function attributes with wrappers.
Wrappers provide safe access access in case of unregistering the power
supply (.e.g by removing the driver). Replace:
 - get_property -> power_supply_get_property

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
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


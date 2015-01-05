Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbbAEPs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:48:28 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:55683 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbbAEPsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:48:23 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-ad-54aab245b0b2
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCHv2 08/19] power: apm_power: Use power_supply_*() API for
 accessing function attrs
Date: Mon, 05 Jan 2015 16:47:51 +0100
Message-id: <1420472882-10463-9-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
References: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t/xa7qum1aFGKydzmkx6cl7ZouJKycz
	W7x+YWix8+FbNovl+/oZLTY9vsZqcXnXHDaLz71HGC3unjrKZnHm9CVWi9O7Sxy4PXbOusvu
	sXmFlsemVZ1sHpuX1HtsudrO4tG3ZRWjx4rV39k9Pm+SC+CI4rJJSc3JLEst0rdL4MqYtOAD
	Y8E/jorvm74yNjBeY+9i5OSQEDCROPttDwuELSZx4d56NhBbSGApo8Tc8/ZdjFxAdh+TROOz
	DUwgCTYBY4nNy5ewgSREBJ4wSUxvPQnWzSxgKPHz3R+wqcICaRKrJ35n7mLk4GARUJV438oD
	EuYVcJeYdXUJ1DI5iZPHJrOC2JwCHhJNfy+wQCx2l/jw7BfrBEbeBYwMqxhFU0uTC4qT0nMN
	9YoTc4tL89L1kvNzNzFCQvLLDsbFx6wOMQpwMCrx8HqcWBkixJpYVlyZe4hRgoNZSYT3Vfqq
	ECHelMTKqtSi/Pii0pzU4kOMTBycUg2MkXrVEg48K1Yc4peVqdt4/0PYFp3k60fzS8Sm29yR
	iN//5/AfPtsP0mKiRtnLyhUvhgS+KVllGuhtPm+ywnM3i6arFoFzmtW2J7OoqnLG2ZUEPDoy
	L5b9ZOWPI8+0mVXWhvlq9S/08G3IPHE2vCp1/pmb8f/dko886P249TXnLKEV1Tev18YpsRRn
	JBpqMRcVJwIAV03ZaycCAAA=
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


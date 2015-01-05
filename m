Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbbAEPsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:48:36 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:55683 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbbAEPs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:48:29 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-d2-54aab24a1739
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCHv2 19/19] arm: mach-pxa: Decrement the power supply's device
 reference counter
Date: Mon, 05 Jan 2015 16:48:02 +0100
Message-id: <1420472882-10463-20-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
References: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsVy+t/xa7pem1aFGJx6a2Ax6cl7ZouJKycz
	W7x+YWix8+FbNovl+/oZLTY9vsZqcXnXHDaLz71HGC3unjrKZnHm9CVWi9O7Sxy4PXbOusvu
	sXmFlsemVZ1sHpuX1HtsudrO4tG3ZRWjx4rV39k9Pm+SC+CI4rJJSc3JLEst0rdL4Mp4d2IV
	e8FX1oonZ7exNzA2sXYxcnJICJhIPHzRzgZhi0lcuLceyObiEBJYyihx+v5idginj0ni4pEn
	jCBVbALGEpuXLwGrEhF4wiQxvfUkC0iCWcBQ4ue7P0AdHBzCAskS0xZpgYRZBFQlvk/rYQKx
	eQU8JNperIfaJidx8thksCs4geJNfy+AjREScJf48OwX6wRG3gWMDKsYRVNLkwuKk9JzDfWK
	E3OLS/PS9ZLzczcxQoLyyw7GxcesDjEKcDAq8fB6nFgZIsSaWFZcmXuIUYKDWUmE91X6qhAh
	3pTEyqrUovz4otKc1OJDjEwcnFINjNMsDyndrj3J2CWULjbPkHO+2/RFSrJbmrOsVl5TmXcn
	NHvDjR19F3hPFDvWtG7oWFVg9P2ZeY/qsdYZWtMqLuZOVNi8bGfGjcnr5XdFHJhvFaa49TWb
	WFW680/d2K3zOtqan3NOUvSftUp3zhyDoI7HX3tn1Fie+rb9JoNAQeQNW6f1u+/K5iqxFGck
	GmoxFxUnAgB24/7FKAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use power_supply_put() to decrement the power supply's device reference
counter.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/mach-pxa/raumfeld.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-pxa/raumfeld.c b/arch/arm/mach-pxa/raumfeld.c
index a762b23ac830..6dc4f025e674 100644
--- a/arch/arm/mach-pxa/raumfeld.c
+++ b/arch/arm/mach-pxa/raumfeld.c
@@ -758,8 +758,10 @@ static void raumfeld_power_signal_charged(void)
 	struct power_supply *psy =
 		power_supply_get_by_name(raumfeld_power_supplicants[0]);
 
-	if (psy)
+	if (psy) {
 		power_supply_set_battery_charged(psy);
+		power_supply_put(psy);
+	}
 }
 
 static int raumfeld_power_resume(void)
-- 
1.9.1


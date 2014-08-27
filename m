Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935147AbaH0PUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:20:41 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:24390 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934523AbaH0PUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:20:31 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-f1-53fdf73dc558
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 8/8] Documentation: charger: max14577: Document exported
 sysfs entry
Date: Wed, 27 Aug 2014 17:20:14 +0200
Message-id: <1409152814-17302-9-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409152814-17302-1-git-send-email-k.kozlowski@samsung.com>
References: <1409152814-17302-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t/xy7q23/8GG+ycIGCxccZ6VoupD5+w
	WUx68p7ZYuLKycwW/W8Wslqce7WS0eL1C0OLs01v2C3ufz3KaPHtSgeTxebvHWwWl3fNYbP4
	3HuE0WLtkbvsFkuvX2SymDB9LYtF694j7Banu1ktTu8ucRD2WDNvDaPH5b5eJo+ds+6ye6xc
	/oXNY/MKLY9NqzrZPO5c28PmMe9koEffllWMHp83yQVwRXHZpKTmZJalFunbJXBlnJ3PVfCU
	s+L/0znsDYxzOLoYOTkkBEwkFl+eyQJhi0lcuLeerYuRi0NIYCmjxJQv/6GcPiaJ7s8vGEGq
	2ASMJTYvX8IGYosILGCSuLguF8RmFjjDLDF1NdhUYYFIiUen1rCD2CwCqhIf2x6B1fMKuEsc
	P7CBCWKbnMTJY5NZQWxOAQ+Jl70XgOIcQMvcJe7O45/AyLuAkWEVo2hqaXJBcVJ6rpFecWJu
	cWleul5yfu4mRkjIf93BuPSY1SFGAQ5GJR5ehdN/goVYE8uKK3MPMUpwMCuJ8JYd+BssxJuS
	WFmVWpQfX1Sak1p8iJGJg1OqgZFth/Ix9YsXNzMGZEvWbl5rNq3gSveaSK1fcQtCru1tyurZ
	c+Lw/GW2cv4fKkxLwjIu+jg4VYQ5arq5NQjZtWm/O7K8NHzXgcKHjHYVSqvu//Gwl6rx+3Tu
	wqcX5Vk+XH/n6EjGsi2++7Z8tc/z61JXFk66qnTEIfbT8bjyGBOzhJVvr60JEFJiKc5INNRi
	LipOBACwIKjkVwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the 'fast charge timer' setting exported by max14577 driver
through sysfs entry.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/ABI/testing/sysfs-class-power | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-power b/Documentation/ABI/testing/sysfs-class-power
index 78c7baca3587..83ee67ebf0e9 100644
--- a/Documentation/ABI/testing/sysfs-class-power
+++ b/Documentation/ABI/testing/sysfs-class-power
@@ -18,3 +18,17 @@ Description:
 		This file is writeable and can be used to set the assumed
 		battery 'full level'. As batteries age, this value has to be
 		amended over time.
+
+What:		/sys/class/power_supply/max14577-charger/device/fast_charge_timer
+Date:		July 2014
+KernelVersion:	3.17.0
+Contact:	Krzysztof Kozlowski <k.kozlowski@samsung.com>
+Description:
+		This entry shows and sets the maximum time the max14577
+		charger operates in fast-charge mode. When the timer expires
+		the device will terminate fast-charge mode (charging current
+		will drop to 0 A) and will trigger interrupt.
+
+		Valid values:
+		- 5, 6 or 7 (hours),
+		- 0: disabled.
-- 
1.9.1


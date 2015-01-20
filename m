Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbbATKFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:05:13 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32488 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbbATKFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:05:07 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-b7-54be28476951
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-api@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 4/5] Documentation: power: max77693-charger: Document
 exported sysfs entry
Date: Tue, 20 Jan 2015 11:00:55 +0100
Message-id: <1421748056-25735-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1421748056-25735-1-git-send-email-k.kozlowski@samsung.com>
References: <1421748056-25735-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t/xa7ruGvtCDCbNtbLYOGM9q8WkJ++Z
	LeYfOcdqMXHlZGaL1y8MLc42vWG3uP/1KKPF5u8dbBaXd81hs/jce4TR4nQ3q8Xp3SUOPB47
	Z91l99i8Qstj06pONo871/awecw7GejRt2UVo8fnTXIB7FFcNimpOZllqUX6dglcGV0THrIX
	LBeqWHLvAGsD4zz+LkZODgkBE4m9x3+wQthiEhfurWfrYuTiEBJYyihxZMMJdpCEkEAfk0T7
	OSkQm03AWGLz8iVgRSICe5gkPr1YwQriMAtMY5S4cOo7cxcjB4ewQLzEpSMaICaLgKpE/7QA
	kF5eAXeJyysOsEMsk5M4eWwy2GJOAQ+JH3OPskDscpdY/6+HaQIj7wJGhlWMoqmlyQXFSem5
	hnrFibnFpXnpesn5uZsYIQH5ZQfj4mNWhxgFOBiVeHg1cvaECLEmlhVX5h5ilOBgVhLh7ZHY
	FyLEm5JYWZValB9fVJqTWnyIkYmDU6qBsfDf5HtuLm3y35beKNdPccgSzexdab5tyyRO2/lz
	dlUkvLSXZfRWUV4j+Spwv0d7+dIwo2NaDq9b7LL2efMwxZSFrjZTCtl/2HDFRSnP2sz27M7l
	Eo8qNdWWXuO+f52r5f3W3sir6caXkk5+qF/cWFrM/9fJWtkkSnl+t42Jm3fBmrLVDT5KLMUZ
	iYZazEXFiQAlL60IJgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the settings exported by max77693 charger driver through sysfs
entries:
 - fast_charge_timer
 - top_off_threshold_current
 - top_off_timer

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 Documentation/ABI/testing/sysfs-class-power | 42 +++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-power b/Documentation/ABI/testing/sysfs-class-power
index 909e7602c717..369d2a2d7d3e 100644
--- a/Documentation/ABI/testing/sysfs-class-power
+++ b/Documentation/ABI/testing/sysfs-class-power
@@ -32,3 +32,45 @@ Description:
 		Valid values:
 		- 5, 6 or 7 (hours),
 		- 0: disabled.
+
+What:		/sys/class/power_supply/max77693-charger/device/fast_charge_timer
+Date:		January 2015
+KernelVersion:	3.19.0
+Contact:	Krzysztof Kozlowski <k.kozlowski@samsung.com>
+Description:
+		This entry shows and sets the maximum time the max77693
+		charger operates in fast-charge mode. When the timer expires
+		the device will terminate fast-charge mode (charging current
+		will drop to 0 A) and will trigger interrupt.
+
+		Valid values:
+		- 4 - 16 (hours), step by 2 (rounded down)
+		- 0: disabled.
+
+What:		/sys/class/power_supply/max77693-charger/device/top_off_threshold_current
+Date:		January 2015
+KernelVersion:	3.19.0
+Contact:	Krzysztof Kozlowski <k.kozlowski@samsung.com>
+Description:
+		This entry shows and sets the charging current threshold for
+		entering top-off charging mode. When charging current in fast
+		charge mode drops below this value, the charger will trigger
+		interrupt and start top-off charging mode.
+
+		Valid values:
+		- 100000 - 200000 (microamps), step by 25000 (rounded down)
+		- 200000 - 350000 (microamps), step by 50000 (rounded down)
+		- 0: disabled.
+
+What:		/sys/class/power_supply/max77693-charger/device/top_off_timer
+Date:		January 2015
+KernelVersion:	3.19.0
+Contact:	Krzysztof Kozlowski <k.kozlowski@samsung.com>
+Description:
+		This entry shows and sets the maximum time the max77693
+		charger operates in top-off charge mode. When the timer expires
+		the device will terminate top-off charge mode (charging current
+		will drop to 0 A) and will trigger interrupt.
+
+		Valid values:
+		- 0 - 70 (minutes), step by 10 (rounded down)
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbbAEKR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:17:56 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36401 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbbAEKRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:17:21 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-98-54aa64ad5851
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-api@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 4/4] Documentation: power: max77693-charger: Document
 exported sysfs entry
Date: Mon, 05 Jan 2015 11:16:59 +0100
Message-id: <1420453019-28614-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420453019-28614-1-git-send-email-k.kozlowski@samsung.com>
References: <1420453019-28614-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e/4Vd21KatCDE5P4rWY9OQ9s8X8I+dY
	LSaunMxs8fqFocX9r0cZLTZ/72CzuLxrDpvF594jjBanu1ktTu8uceDy2DnrLrvH5hVaHptW
	dbJ53Lm2h81j3slAj74tqxg9Pm+SC2CP4rJJSc3JLEst0rdL4MromvCQvWC5UMWSewdYGxjn
	8XcxcnJICJhItK3fxQphi0lcuLeerYuRi0NIYCmjRMfpn0wQTh+TxJNrO8Cq2ASMJTYvXwJW
	JSKwh0ni04sVYAlmAUOJn+/+sIPYwgLxEg+OrWQDsVkEVCW2zNzGBGLzCrhLHHzUxgixTk7i
	5LHJYL2cAh4S819+ZwaxhYBqDux7zDyBkXcBI8MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxN
	jJAA/LqDcekxq0OMAhyMSjy8HidWhgixJpYVV+YeYpTgYFYS4V13CyjEm5JYWZValB9fVJqT
	WnyIkYmDU6qBcYPkab7EJa07Sm2LfhXeYLn/QXUz02W5OdvWeNqLLIoqkC3Uu3WPfRbDjLkn
	MmeWnHV7UN35qyL2W4ilYMaLnZV7FyRf+z+163V+ZWj13NfMqu8Kwrqs6/JuzWsSDdI9pWS8
	ljM1c/nxY5Nv5hs3Pzwx5RPzB3+2zRn7gq92Fr27d6TTJCdVWImlOCPRUIu5qDgRADzuRMMe	AgAA
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


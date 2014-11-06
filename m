Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbaKFPPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:15:19 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33317 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaKFPMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:12:16 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-59-545b8fcb912d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-api@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND v3 4/4] Documentation: power: max77693-charger: Document
 exported sysfs entry
Date: Thu, 06 Nov 2014 16:12:00 +0100
Message-id: <1415286720-6358-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415286720-6358-1-git-send-email-k.kozlowski@samsung.com>
References: <1415286720-6358-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsVy+t/xK7qn+6NDDOZ2ClhsnLGe1WLSk/fM
	FvOPnGO1mLhyMrPF6xeGFmeb3rBb3P96lNFi8/cONotNj6+xWlzeNYfN4nPvEUaLGef3MVms
	PXKX3eJ0N6vF6d0lFqt2/WF0EPDYOesuu8fmFVoem1Z1snncubaHzWPeyUCPzUvqPfq2rGL0
	+LxJLoAjissmJTUnsyy1SN8ugSuja8JD9oLlQhVL7h1gbWCcx9/FyMkhIWAi8fbEZCYIW0zi
	wr31bF2MXBxCAksZJSbtu8UI4fQxSbQtXM8KUsUmYCyxefkSsCoRgT1MEp9erGAFcZgFtjNJ
	/Pk2AaxKWCBN4u+uJYwgNouAqsTai4tYQGxeATeJ41sOMELsk5M4eWwyUD0HB6eAu0T3t0qQ
	sBBQyfOv8xgnMPIuYGRYxSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESxF93MC49ZnWIUYCD
	UYmHN4I9OkSINbGsuDL3EKMEB7OSCG91D1CINyWxsiq1KD++qDQntfgQIxMHp1QDY13+3qpV
	jiqnKu7ue6D/se63Y/5iJz+GUypKCqcT0w692XV3LsO3llM72kWKFb9+vHFO8Y55mVSE9tT+
	tGP5a9s9jfm271h6fIUtu5X53Wy3rOjznybYyBZXN2ev3LJ93vqHiSeqH0z8vHb7iuhVxnP5
	1jvwtsf9mfjwW3lv88S+NbG8kbfurlNiKc5INNRiLipOBACfP9YLQAIAAA==
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


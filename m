Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaH1NGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:06:32 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26790 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbaH1NGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:06:17 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-b8-53ff29458368
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
Subject: [PATCH v5 8/8] Documentation: charger: max14577: Document exported
 sysfs entry
Date: Thu, 28 Aug 2014 15:05:50 +0200
Message-id: <1409231150-2701-9-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409231150-2701-1-git-send-email-k.kozlowski@samsung.com>
References: <1409231150-2701-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t/xy7qumv+DDU5f0LfYOGM9q8XUh0/Y
	LCY9ec9sMXHlZGaL/jcLWS3OvVrJaPH6haHF2aY37Bb3vx5ltPh2pYPJYvP3DjaLy7vmsFl8
	7j3CaLH2yF12i6XXLzJZTJi+lsWide8RdovT3awWp3eXOAh7rJm3htHjcl8vk8fOWXfZPVYu
	/8LmsXmFlsemVZ1sHneu7WHzmHcy0KNvyypGj8+b5AK4orhsUlJzMstSi/TtErgyzs7nKnjK
	WfH/6Rz2BsY5HF2MnBwSAiYSh9ouMUPYYhIX7q1n62Lk4hASWMoosf36KhYIp49J4uC/H4wg
	VWwCxhKbly9hA7FFBBYwSVxclwtiMwucYZaYuhpsqrBApMSUmXPZQWwWAVWJ5uWfWEBsXgE3
	iTXz2hghtslJnDw2mRXE5hRwl/jQtA/I5gBa5iaxuSdkAiPvAkaGVYyiqaXJBcVJ6blGesWJ
	ucWleel6yfm5mxghIf91B+PSY1aHGAU4GJV4eBVO/wkWYk0sK67MPcQowcGsJMK7SfJ/sBBv
	SmJlVWpRfnxRaU5q8SFGJg5OqQbG9bt8o2c2rGoOcLLe8/G2iz1PxIkncZJHU7f0Hv66ceWr
	y8fzt13Zn3a0YltBqHVr5ByxrDWbVgq8m9fLuVHV9uPdpP+bfym8bzEr4PAVXjOJ52jYmk0J
	86Z+DKrzNlyg9VqOy7xMl3kTy7pkvUyBg8Ls3BfLjm+o/fdDL+Cdqni/dlj/zLOZSizFGYmG
	WsxFxYkA5H2tx1cCAAA=
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


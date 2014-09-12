Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbaILGyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 02:54:41 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:37334 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbaILGyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 02:54:21 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-2e-5412989b0b3d
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
        devicetree@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v6 8/8] Documentation: charger: max14577: Document exported
 sysfs entry
Date: Fri, 12 Sep 2014 08:54:00 +0200
Message-id: <1410504840-23543-9-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410504840-23543-1-git-send-email-k.kozlowski@samsung.com>
References: <1410504840-23543-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t/xy7qzZwiFGGzaK2MxZ/0aNouNM9az
	Wkx9+ITNYtKT98wW84+cY7WYuHIys0X/m4WsFuderWS0eP3C0OJs0xt2i/tfjzJafLvSwWSx
	+XsHm8XlXXPYLD73HmG0WHvkLrvF0usXmSwmTF/LYtG69wi7xeluVovTu0scRD3WzFvD6HG5
	r5fJY+esu+weK5d/YfPYvELLY9OqTjaPO9f2sHmcmPGbxWPeyUCPvi2rGD0+b5IL4I7isklJ
	zcksSy3St0vgyrjb0cNcMIurYu2BO0wNjGc4uhg5OSQETCSurepgg7DFJC7cWw9kc3EICSxl
	lPi/fQOU08cksWZRAytIFZuAscTm5UvAOkQEFjBJXFyXC1LELDCVRWLSyhZ2kISwQKTE/187
	mboYOThYBFQlprySAgnzCrhLLHu7CGqbnMTJY5PBZnIKeEjsuryUGcQWAqrZtKWZaQIj7wJG
	hlWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIVHxdQfj0mNWhxgFOBiVeHg/5AqGCLEmlhVX
	5h5ilOBgVhLhTZ0qFCLEm5JYWZValB9fVJqTWnyIkYmDU6qBsfjfyqz16nFzHyvd5v7hxBao
	wXdtmQD7ktrfTg8aTaf99LM/v+LzgoW7nwcx7D01NZv1z32eoMXT9PnPt4gW7bybeET2B/PL
	zgxHrrfT2b7PKGj17hN58tXyWNzbN7UPlO1W7lsqqOq6vlLWysfLPrbR2q7S13tCtt6Nzpav
	bGfcjzjunlGwXomlOCPRUIu5qDgRAP7DHXVoAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the 'fast charge timer' setting exported by max14577 driver
through sysfs entry.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
---
 Documentation/ABI/testing/sysfs-class-power | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-power b/Documentation/ABI/testing/sysfs-class-power
index 78c7baca3587..ad4fb90ab23d 100644
--- a/Documentation/ABI/testing/sysfs-class-power
+++ b/Documentation/ABI/testing/sysfs-class-power
@@ -18,3 +18,17 @@ Description:
 		This file is writeable and can be used to set the assumed
 		battery 'full level'. As batteries age, this value has to be
 		amended over time.
+
+What:		/sys/class/power_supply/max14577-charger/device/fast_charge_timer
+Date:		July 2014
+KernelVersion:	3.18.0
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


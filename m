Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934602AbaH0Nbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:31:41 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32943 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934415AbaH0Nbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:31:37 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-c6-53fdddb7abc2
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RESEND PATCH v3 6/6] Documentation: charger: max14577: Document
 exported sysfs entry
Date: Wed, 27 Aug 2014 15:31:22 +0200
Message-id: <1409146282-25075-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409146282-25075-1-git-send-email-k.kozlowski@samsung.com>
References: <1409146282-25075-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t/xq7rb7/4NNrh7x9Ri44z1rBZTHz5h
	s5j05D2zxcSVk5kt+t8sZLU492olo8XrF4YWZ5vesFvc/3qU0eLblQ4mi83fO9gsLu+aw2bx
	ufcIo8XaI3fZLZZev8hkMWH6WhaL1r1H2C1Od7NanN5d4iDssWbeGkaPy329TB47Z91l91i5
	/Aubx+YVWh6bVnWyedy5tofNY97JQI++LasYPT5vkgvgiuKySUnNySxLLdK3S+DKWPPqO3PB
	Ns6KaZsXMTUwfmLvYuTkkBAwkdj/8AaULSZx4d56ti5GLg4hgaWMEosfroNy+pgklly+zQRS
	xSZgLLF5+RKwhIjANUaJKw1zwRxmgWksEv/udoBVCQskSGy6O4sVxGYRUJWY+HYhWJxXwF2i
	ZcZWVoh9chInj00GszkFPCTW3nwDViMEVHPryUS2CYy8CxgZVjGKppYmFxQnpeca6hUn5haX
	5qXrJefnbmKEhP6XHYyLj1kdYhTgYFTi4WVY/ydYiDWxrLgy9xCjBAezkghv2YG/wUK8KYmV
	ValF+fFFpTmpxYcYmTg4pRoYjcO/Xdvss/61udyNon0KKROtS7i9186Ynlm8nSti6TeFN/kd
	Gj+6kxlkXDfdvL58ZuaDQiYF7uMR9XZ/YjM2eDVPMmaO6Fp40JBVRF8lJHl+5MzZygInpdS5
	LW6pybZtL7f+fHHnPddQye2NTm/+5lZ8r6hyYP75tKlN4TSruNGRF4pHgk8rsRRnJBpqMRcV
	JwIAlCb/A1sCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the 'fast charge timer' setting exported by max14577 driver
through sysfs entry.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
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


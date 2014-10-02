Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaJBMWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:22:34 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:28183 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaJBMWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:22:23 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-57-542d437c538e
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-api@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 4/7] Documentation: charger: max77693: Document exported sysfs
 entry
Date: Thu, 02 Oct 2014 14:22:05 +0200
Message-id: <1412252528-30148-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1412252528-30148-1-git-send-email-k.kozlowski@samsung.com>
References: <1412252528-30148-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVy+t/xq7o1zrohBqcPalpsnLGe1WLSugNM
	FpOevGe2mH/kHKvFxJWTmS363yxktTj3aiWjxdHfBRavXxha9C64ymZxtukNu8X9r0cZLTZ/
	72Cz2PT4GqvF5V1z2Cw+9x5htJhxfh+Txe3LvBZrj9xlt1h6/SKTxYTpa1ksWvceYbc43c1q
	cXp3icWqXX8YHSQ91sxbw+jR0tzD5nG5r5fJ4+/z6ywef1e9YPbYOesuu8fK5V/YPDav0PLY
	tKqTzePOtT1sHvNOBnpsXlLv0bdlFaPH501yAXxRXDYpqTmZZalF+nYJXBldEx6yFywXqlhy
	7wBrA+M8/i5GTg4JAROJG7+3sUHYYhIX7q0Hsrk4hASWMkp0rvvICOH0MUm8mnGAFaSKTcBY
	YvPyJWBVIgJ/mSUmfH/FBOIwCzxllji3YQtYlbBAmMTk7svsIDaLgKpE77Q/TCA2r4C7xM/W
	66wQ++QkTh6bDGZzCnhIzH07EaxeCKimrWkV2wRG3gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS
	9ZLzczcxQiLryw7GxcesDjEKcDAq8fBmNOiECLEmlhVX5h5ilOBgVhLhfWKvGyLEm5JYWZVa
	lB9fVJqTWnyIkYmDU6qBcUbd8V73yxdNNOpeXMxVeBXUH7ZCj2GJQuqjZy6H2OZLSB6Y/khp
	pkzNvLwr3PsLpbdUL+2tnvvjQNhEaxnRo+8THfZp3N3DNJmr9rXD//WVi/fYxPNn612OmrPc
	sHOt+O4Fi9+93JU4+YviRmax085Sinze76zaN7LKBC7jWnHz2XaWkt+zM5VYijMSDbWYi4oT
	Ab3ztbyKAgAA
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


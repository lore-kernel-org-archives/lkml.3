Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaJTMgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:36:13 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23382 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaJTMfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:35:24 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-b6-54450189ef3e
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-api@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 5/5] Documentation: charger: max77693: Document exported
 sysfs entry
Date: Mon, 20 Oct 2014 14:34:49 +0200
Message-id: <1413808489-3524-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413808489-3524-1-git-send-email-k.kozlowski@samsung.com>
References: <1413808489-3524-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t/xa7qdjK4hBrv6pCw2zljPajHpyXtm
	i/lHzrFaTFw5mdni9QtDi7NNb9gt7n89ymix+XsHm8XlXXPYLD73HmG0WHvkLrvF6W5Wi9O7
	Sxx4PXbOusvusXmFlsemVZ1sHneu7WHzmHcy0KNvyypGj8+b5ALYo7hsUlJzMstSi/TtErgy
	uiY8ZC9YLlSx5N4B1gbGefxdjJwcEgImEre+H2eDsMUkLtxbD2RzcQgJLGWU2HTrF5TTxyQx
	f94nVpAqNgFjic3Ll4AlRAT2MUmcev6WGcRhFjjKKDG99y0TSJWwQKTEg3PnGUFsFgFViYWX
	XoB18wq4Sdy9f5kZYp+cxMljk8HinALuEvO3d4DVCwHVnLp4iHkCI+8CRoZVjKKppckFxUnp
	uUZ6xYm5xaV56XrJ+bmbGCEB+nUH49JjVocYBTgYlXh4d5i5hAixJpYVV+YeYpTgYFYS4XX5
	DxTiTUmsrEotyo8vKs1JLT7EyMTBKdXA2PhU73fDprUtt0WvXG954apcctL21GRRBdvYk1Lb
	v6WodKqsuaBi+Nqp7v316y87nRZ1BM60+vKVUY2p6//V64E2X1sZ5qyrWFevoiC8QWr9SlXm
	Ceeb7bdzPBU5XV+0MmPJr/ff1ZRSfoatbvN9Zv7z3NZHyyXXfry51UuIaVZAo12BVKe5lBJL
	cUaioRZzUXEiAOFHv2IuAgAA
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


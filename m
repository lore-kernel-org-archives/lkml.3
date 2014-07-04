Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964938AbaGDKOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:14:04 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:14937 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025AbaGDKNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:13:02 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-f9-53b67e2b98a8
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
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
Subject: [PATCH v3 6/6] Documentation: charger: max14577: Document exported
 sysfs entry
Date: Fri, 04 Jul 2014 12:12:45 +0200
Message-id: <1404468765-10818-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1404468765-10818-1-git-send-email-k.kozlowski@samsung.com>
References: <1404468765-10818-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t/xK7radduCDeYeEbDYOGM9q8XUh0/Y
	LCY9ec9sMXHlZGaL/jcLWS3OvVrJaPH6haHF2aY37Bb3vx5ltPh2pYPJYvP3DjaLy7vmsFms
	PXKX3WLp9YtMFhOmr2WxaN17hN3idDerg6DHmnlrGD0u9/UyeeycdZfdY+XyL2wem1doeWxa
	1cnmcefaHjaPeScDPfq2rGL0+LxJLoArissmJTUnsyy1SN8ugStjzavvzAXbOCumbV7E1MD4
	ib2LkZNDQsBE4t/0DlYIW0ziwr31bF2MXBxCAksZJQ5MbmaBcPqYJHYu+8AIUsUmYCyxefkS
	sCoRgWmMEos3TGQEcZgFprFI/LvbwQRSJSwQKTF33yFmEJtFQFWiedZBMJtXwF3i1tkrUPvk
	JE4emwxmcwp4SKxoOwa2QQio5lHLN9YJjLwLGBlWMYqmliYXFCel5xrpFSfmFpfmpesl5+du
	YoQE+tcdjEuPWR1iFOBgVOLhfaG/KViINbGsuDL3EKMEB7OSCO/b6m3BQrwpiZVVqUX58UWl
	OanFhxiZODilGhj5c6tvPWHvlU4J2bZBRnXLi+2b7xwx35PGtaN4zY/5B3+IFpUm/d2t5j+X
	a//nr7G7Xyf/VnURbIlb4aZVynb7aJCYhLbD04KEpP2qWy43/fpueb97mkN9Uf/a5bM3Ho67
	PtdRd8nBf9lpk0TDZ7x7abT0wU7DW1WTCvwOzhF/PUE0KLhpxUVhJZbijERDLeai4kQAr92s
	W1ICAAA=
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


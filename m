Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaGVHle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:41:34 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:15093 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbaGVHlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:41:31 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-fb-53ce15a785ec
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
Subject: [RESEND PATCH v3 6/6] Documentation: charger: max14577: Document
 exported sysfs entry
Date: Tue, 22 Jul 2014 09:41:06 +0200
Message-id: <1406014866-17744-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1406014866-17744-1-git-send-email-k.kozlowski@samsung.com>
References: <1406014866-17744-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xK7rLRc8FG/Q+lbDYOGM9q8XUh0/Y
	LCY9ec9sMXHlZGaL/jcLWS3OvVrJaPH6haHF2aY37Bb3vx5ltPh2pYPJYvP3DjaLy7vmsFms
	PXKX3WLp9YtMFhOmr2WxaN17hN3idDerg6DHmnlrGD0u9/UyeeycdZfdY+XyL2wem1doeWxa
	1cnmcefaHjaPeScDPfq2rGL0+LxJLoArissmJTUnsyy1SN8ugStjzavvzAXbOCumbV7E1MD4
	ib2LkZNDQsBE4u2Xk0wQtpjEhXvr2boYuTiEBJYySpz6fY0dwuljkjj/9jIrSBWbgLHE5uVL
	wKpEBKYxSizeMJERxGEWmMYi8e9uB9gsYYEEiU13Z4F1sAioSpxd8JoFxOYVcJf4OHM6M8Q+
	OYmTxyaD1XAKeEh0LmgA6uUAWucusWRp+ARG3gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLz
	czcxQsL8yw7GxcesDjEKcDAq8fAyPDwVLMSaWFZcmXuIUYKDWUmEt33P2WAh3pTEyqrUovz4
	otKc1OJDjEwcnFINjHM+ixfObON7sfayF9v3XUpNNj8z9efenTk7fNOP/VzX/Rk6p07vmHb3
	m/XhF7YemXW9nMvOyIe1MSzhd5zQUHPS+gNPGP+X/K8TEprTK84tYf33Umf7smyTi/PSFnkd
	c3jJKbIpVOZR/McXIoqzGSdf2vBXd9uxgwd9fgetPWHwagmjllr0Uz8lluKMREMt5qLiRACg
	6wuNUQIAAA==
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


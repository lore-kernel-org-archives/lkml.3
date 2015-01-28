Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbbA1URR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:17:17 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43114 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbbA1URA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:17:00 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-99-54c8ec5f0346
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>, Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH v5 2/5] iio: sensorhub: Add sensorhub bindings
Date: Wed, 28 Jan 2015 15:05:51 +0100
Message-id: <1422453954-27317-3-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1422453954-27317-1-git-send-email-k.wrona@samsung.com>
References: <1422453954-27317-1-git-send-email-k.wrona@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xy7rxb06EGOw5pG6xccZ6Vov5R86x
	WvS/Wchqce7VSkaLB02rmCxOLdvPZLHr/xtmi7NNb9gtlkyez2ox78g7FovLu+awWSy9fpHJ
	YsL0tSwWv3cdY7do3XuE3WLPui1MDgIea+atYfS43NfL5LFz1l12jw8f4zxWLv/C5rFpVSeb
	x5I3h1g9zjcfYfTo27KK0ePzJrkArigum5TUnMyy1CJ9uwSujL9P29kLNnBXHDh5lK2B8Thn
	FyMnh4SAiUTvsofMELaYxIV769m6GLk4hASWMkpsfdHCBOH0MUk8PX2GFaSKTUBdonnHYrAO
	EYE6iSOrt7KAFDEL3GaW6Gj+wA6SEBawk5gysxPMZhFQlWh9NZ8NxOYVcJY4sPs9UJwDaJ2C
	xJxJNiBhTgEXiSnb/oKVCAGVnNx+n3UCI+8CRoZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmb
	GCEB/mUH4+JjVocYBTgYlXh4X5idCBFiTSwrrsw9xCjBwawkwvt4L1CINyWxsiq1KD++qDQn
	tfgQIxMHp1QDY/MTuwuyh9ruCVovOt0/rdf6OPPCcHXruZkrWH+WfJGcuHqRZP2zoxa7mefM
	PdXANv0Fu963BWHc14xchd4VJl5ZvGVHf5DB/Bun4luOSavzqTOpBufb79h2JDyr/meLglnN
	/sCTpld2mjflpWZsFfexVTEOT9p7JedH7dK5S5LY9YzTBa+0KrEUZyQaajEXFScCANNNMgFO	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sensorhub bindings for sensorhub on Galaxy Gear 2.

Signed-off-by: Karol Wrona <k.wrona@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/iio/sensorhub.txt          |   25 ++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iio/sensorhub.txt

diff --git a/Documentation/devicetree/bindings/iio/sensorhub.txt b/Documentation/devicetree/bindings/iio/sensorhub.txt
new file mode 100644
index 0000000..8d57571
--- /dev/null
+++ b/Documentation/devicetree/bindings/iio/sensorhub.txt
@@ -0,0 +1,25 @@
+Samsung Sensorhub driver
+
+Sensorhub is a MCU which manages several sensors and also plays the role
+of a virtual sensor device.
+
+Required properties:
+- compatible: "samsung,sensorhub-rinato" or "samsung,sensorhub-thermostat"
+- spi-max-frequency: max SPI clock frequency
+- interrupt-parent: interrupt parent
+- interrupts: communication interrupt
+- ap-mcu-gpios: [out] ap to sensorhub line - used during communication
+- mcu-ap-gpios: [in] sensorhub to ap - used during communication
+- mcu-reset-gpios: [out] sensorhub reset
+
+Example:
+
+	shub_spi: shub {
+		compatible = "samsung,sensorhub-rinato";
+		spi-max-frequency = <5000000>;
+		interrupt-parent = <&gpx0>;
+		interrupts = <2 0>;
+		ap-mcu-gpios = <&gpx0 0 0>;
+		mcu-ap-gpios = <&gpx0 4 0>;
+		mcu-reset-gpios = <&gpx0 5 0>;
+	};
-- 
1.7.9.5


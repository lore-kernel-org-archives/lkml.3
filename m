Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbbANQQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:16:40 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24732 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbbANQQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:16:38 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-c2-54b696658a28
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH v4 2/5] iio: sensorhub: Add sensorhub bindings
Date: Wed, 14 Jan 2015 17:16:12 +0100
Message-id: <1421252172-26797-1-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsVy+t/xa7qp07aFGGw8xWqxccZ6Vov5R86x
	WvS/Wchqce7VSkaLB02rmCxOLdvPZLHr/xtmi7NNb9gtlkyez2ox78g7FovLu+awWSy9fpHJ
	YsL0tSwWv3cdY7do3XuE3WLPui1MDgIea+atYfS43NfL5LFz1l12jw8f4zxWLv/C5rFpVSeb
	x5I3h1g9zjcfYfTo27KK0ePzJrkArigum5TUnMyy1CJ9uwSujL9P29kLNnBXHDh5lK2B8Thn
	FyMnh4SAicTipQ+ZIGwxiQv31rN1MXJxCAksZZToaTzJBOH0MUlM6Z7OClLFJqAu0bxjMTNI
	QkTgAqPE8UNbWEAcZoF2Zon9q96AVQkL2Els/XIYzGYRUJWYv+YJM4jNK+As8f/9CqAdHED7
	FCTmTLKZwMi9gJFhFaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZIyH7dwbj0mNUhRgEORiUe
	XocjW0OEWBPLiitzDzFKcDArifA+Ld8WIsSbklhZlVqUH19UmpNafIiRiYNTCujVqf2Z7IHu
	Hee/fq5RPrIoJjeeocgi/vLEz+Vfsjbt7NZ0qjGYxrKXV3SfTS6H9hK9mcELMmpD+/ZJm0U5
	1bwz2ed02/k724EfEdoJu/y3SzVzz1BskhUx6FS79/Ot1LpXmXcC/uQlNU/UZL7BsD6abXW2
	/I65Fp5Lwp7avp/gx85ffcmlSImlOCPRUIu5qDgRAFDbgY83AgAA
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


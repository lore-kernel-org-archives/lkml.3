Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934674AbaH0Nc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:32:26 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36526 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933931AbaH0Nbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:31:36 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-bc-53fdddb52d3f
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
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>
Subject: [RESEND PATCH v3 4/6] power: max17040: Add ID for MAX77836 Fuel Gauge
 block
Date: Wed, 27 Aug 2014 15:31:20 +0200
Message-id: <1409146282-25075-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409146282-25075-1-git-send-email-k.kozlowski@samsung.com>
References: <1409146282-25075-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t/xq7pb7/4NNnjSp2VxcKumxcYZ61kt
	pj58wmYx6cl7ZouJKyczW/S/Wchqce7VSkaL1y8MLc42vWG3uP/1KKPFtysdTBabv3ewWVze
	NYfN4nPvEUaLtUfuslssvX6RyWLC9LUsFq17j7BbnO5mtTi9u8RBxGPNvDWMHpf7epk8JvR/
	YvTYOesuu8fK5V/YPDav0PLYtKqTzePOtT1sHvNOBnr0bVnF6PF5k1wAdxSXTUpqTmZZapG+
	XQJXxotz+9kL9rJXzD/9ir2BcRNbFyMnh4SAicSBi81QtpjEhXvrgWwuDiGBpYwSN3ddYIdw
	+pgkHp8/zgJSxSZgLLF5+RKwKhGBa4wSVxrmgjnMAntYJE5v/gE2S1ggTGL5lPlMIDaLgKrE
	jqXHwGxeAXeJfQ+6WSH2yUmcPDYZzOYU8JBYe/MNWI0QUM2tJxPZJjDyLmBkWMUomlqaXFCc
	lJ5rqFecmFtcmpeul5yfu4kREg1fdjAuPmZ1iFGAg1GJh5dh/Z9gIdbEsuLK3EOMEhzMSiK8
	ZQf+BgvxpiRWVqUW5ccXleakFh9iZOLglGpgzGAXejit+N6L95P2fHHN2zJ3VecGVlO1x7mG
	WaIVtqc0Dj+6xrIweJLbgg0mO+LCrytxic+9+8xW/8mskqw9qq3blrUtkWjacb/a4MGdu3dP
	6H59PJF1pZXUaeHaovJ30ce7lyrWsGb0vrtXcHL555+vPtQL3t5+QnnP6ij+2tQIg11KRYVd
	zUosxRmJhlrMRcWJABrWCgFkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX77836 has the same Fuel Gauge as MAX17040/17048. The max17040 driver
can be safely re-used. The patch adds MAX77836 ID to array of
i2c_device_id.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/power/max17040_battery.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/max17040_battery.c b/drivers/power/max17040_battery.c
index 0fbac861080d..165ffe381803 100644
--- a/drivers/power/max17040_battery.c
+++ b/drivers/power/max17040_battery.c
@@ -278,6 +278,7 @@ static SIMPLE_DEV_PM_OPS(max17040_pm_ops, max17040_suspend, max17040_resume);
 
 static const struct i2c_device_id max17040_id[] = {
 	{ "max17040", 0 },
+	{ "max77836-battery", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max17040_id);
-- 
1.9.1


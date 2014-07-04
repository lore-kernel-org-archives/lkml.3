Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbaGDH7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:59:14 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22032 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbaGDH7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:59:04 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-d3-53b65ec5c2c9
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
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
Subject: [PATCH v2 4/5] power: max17040: Add ID for MAX77836 Fuel Gauge block
Date: Fri, 04 Jul 2014 09:58:28 +0200
Message-id: <1404460709-17178-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1404460709-17178-1-git-send-email-k.kozlowski@samsung.com>
References: <1404460709-17178-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t/xq7pH47YFG0xdJm5xcKumxcYZ61kt
	pj58wmYx6cl7ZouJKyczW/S/Wchqce7VSkaL1y8MLc42vWG3uP/1KKPFtysdTBaXd81hs1h7
	5C67xdLrF5ksJkxfy2LRuvcIu8XpblYHQY8189Ywelzu62XymND/idFj56y77B4rl39h89i8
	Qstj06pONo871/awecw7GejRt2UVo8fnTXIB3FFcNimpOZllqUX6dglcGS/O7Wcv2MteMf/0
	K/YGxk1sXYycHBICJhIHd31nhrDFJC7cWw8U5+IQEljKKDFh/mwWCKePSWLHw4/sIFVsAsYS
	m5cvAesWEaiU+Hb6BFgRs8AeFonTm3+AJYQFfCX2btsKNpZFQFXiwIUJYM28Au4Sne+2Q62W
	kzh5bDIriM0p4CHx6fQ7sLgQUE3DgslMExh5FzAyrGIUTS1NLihOSs810itOzC0uzUvXS87P
	3cQICfevOxiXHrM6xCjAwajEw/tCf1OwEGtiWXFl7iFGCQ5mJRHeKqVtwUK8KYmVValF+fFF
	pTmpxYcYmTg4pRoYrQ2Enkq9P7xhnnS/6OeAkqg9U1WOuHDO4D+bvnKDj9+HHJd+rec7siuO
	+/Qb851Z8eB7m8L+qanRF2Uzo8KEVt/5UrtBSl2HS3PNXtW+BQ9buArk/eNf3n56RXllT9hv
	s8/sIhHnrtze0iHDsf/tndxl+l92vhNfd2nivUNPlQ84JE7xV1SbqMRSnJFoqMVcVJwIAIGp
	h1FVAgAA
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


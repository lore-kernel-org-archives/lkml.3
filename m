Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbaJPHeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:34:50 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33231 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaJPHdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:33:39 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-f8-543f74d0ac5a
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Anton Vorontsov <anton@enomsg.org>, Guenter Roeck <linux@roeck-us.net>,
        Pavel Machek <pavel@ucw.cz>, Myungjoo Ham <myungjoo.ham@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 7/8] power: bq2415x_charger: Use power_supply_*() API for
 accessing function attrs
Date: Thu, 16 Oct 2014 09:32:56 +0200
Message-id: <1413444777-24107-8-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413444777-24107-1-git-send-email-k.kozlowski@samsung.com>
References: <1413444777-24107-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t/xy7oXSuxDDPY/MbE4uFXTYuOM9awW
	k568Z7aYuHIys0Xn2SfMFq9fGFqcbXrDbnH/61FGiyl/ljNZbHp8jdXi8q45bBafe48wWjxZ
	eIbJYu2Ru+wWtxtXsFncPXWUzeJ0N6vF6d0lDkIeE/o/MXrsnHWX3WPzCi2PTas62TzuXNvD
	5jHvZKDH5iX1Hju/N7B79G1ZxeixYvV3do/Pm+QCuKO4bFJSczLLUov07RK4Mr70XmAqaOeo
	+PNDvYHxPVsXIyeHhICJxKr1d1ggbDGJC/fWA8W5OIQEljJKdE/Zwgrh9DFJ7Lx0iR2kik3A
	WGLz8iVgVSIC15kkOldMYAFxmAUamSXeNTQzgVQJC6RLTL8+kxnEZhFQlfgw+RBQEQcHr4C7
	ROMWcYh1chInj01mBbE5BTwkpp+9CrZACKRkwn62CYy8CxgZVjGKppYmFxQnpeca6hUn5haX
	5qXrJefnbmKEhPyXHYyLj1kdYhTgYFTi4dUItg8RYk0sK67MPcQowcGsJMLbXAgU4k1JrKxK
	LcqPLyrNSS0+xMjEwSnVwJh3flWncvKRox4WERzJ/xtS0iyWNx9zmtf61WVqwLIu/0IP3W2n
	11Y/cQ1cciXpp+eixJnBv3JVduQ3zt/p0259I1L3w7KE2Tv8++bNiouzKwtsKvzF0Oqk+FSn
	WlXziHhV9qwtUXe5wzfIdbLpt5j/UfvjsO9E1rw7k/Yqf1JiNrecPefrTSWW4oxEQy3mouJE
	AM3ar/5XAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace direct calls to power supply function attributes with wrappers.
Wrappers provide safe access in case of unregistering the power
supply (e.g. by removing the driver). Replace:
 - get_property -> power_supply_get_property

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Jonghwa Lee <jonghwa3.lee@samusng.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/power/bq2415x_charger.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index d9c457217b6a..81a3a78b92d8 100644
--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -816,7 +816,8 @@ static int bq2415x_notifier_call(struct notifier_block *nb,
 
 	dev_dbg(bq->dev, "notifier call was called\n");
 
-	ret = psy->get_property(psy, POWER_SUPPLY_PROP_CURRENT_MAX, &prop);
+	ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_CURRENT_MAX,
+			&prop);
 	if (ret != 0)
 		return NOTIFY_OK;
 
-- 
1.9.1


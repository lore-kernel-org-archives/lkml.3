Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbbAEPtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:49:52 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57063 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbbAEPsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:48:30 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-d3-54aab24b05e2
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCHv2 18/19] mfd: ab8500: Decrement the power supply's device
 reference counter
Date: Mon, 05 Jan 2015 16:48:01 +0100
Message-id: <1420472882-10463-19-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
References: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t/xa7rem1aFGEydp24x6cl7ZouJKycz
	W7x+YWix8+FbNovl+/oZLTY9vsZqcXnXHDaLz71HGC3unjrKZnHm9CVWi9O7Sxy4PXbOusvu
	sXmFlsemVZ1sHpuX1HtsudrO4tG3ZRWjx4rV39k9Pm+SC+CI4rJJSc3JLEst0rdL4MrYu2AC
	W8E29opj724zNjD2snUxcnJICJhITP+3ggnCFpO4cG89UJyLQ0hgKaPE2vtbWSGcPiaJi0ee
	MIJUsQkYS2xevgSsSkTgCZPE9NaTLCAJZgFDiZ/v/rCD2MICiRLbN18Fs1kEVCX+TXrADGLz
	CnhINPQ/Z4RYJydx8thkVhCbEyje9PcC2BwhAXeJD89+sU5g5F3AyLCKUTS1NLmgOCk910iv
	ODG3uDQvXS85P3cTIyQsv+5gXHrM6hCjAAejEg+vx4mVIUKsiWXFlbmHGCU4mJVEeF+lrwoR
	4k1JrKxKLcqPLyrNSS0+xMjEwSnVwHiOP9epSupDXdrxmoxbi7xdUhzLmedlmjhbfnoT+e++
	WB7L9zNxLxtbvp4+eU1ybub6g02LM5uvGa5bnTztxtcFXjt5z57t2fQh8fueef//By+e+1nY
	4DDLpWwvhej05p/ap7+2Ovh/dP76tT/rQtCVH0VLDRrPhcZna8X5Xn+5/dZu717jc9pKLMUZ
	iYZazEXFiQCDy+mXKQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use power_supply_put() to decrement the power supply's device reference
counter.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-sysctrl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
index d4a4b24be7c6..0d1825696153 100644
--- a/drivers/mfd/ab8500-sysctrl.c
+++ b/drivers/mfd/ab8500-sysctrl.c
@@ -51,6 +51,7 @@ static void ab8500_power_off(void)
 
 		ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_ONLINE,
 				&val);
+		power_supply_put(psy);
 
 		if (!ret && val.intval) {
 			charger_present = true;
@@ -73,6 +74,7 @@ static void ab8500_power_off(void)
 			       pss[i]);
 			machine_restart("charging");
 		}
+		power_supply_put(psy);
 	}
 
 shutdown:
-- 
1.9.1


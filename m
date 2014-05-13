Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbaEMLCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:02:42 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58814 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760554AbaEMK7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:59:05 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-69-5371faf54bc1
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH 10/16] mfd: omap-usb-host: Make of_device_id array const
Date: Tue, 13 May 2014 12:58:47 +0200
Message-id: <1399978733-13662-10-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
References: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsVy+t/xy7pffxUGG2zqVrJ4/cLQ4v7Xo4wW
	l3fNYbPoeaRlcbqb1YHV4861PWwe804GevRtWcXocfzGdiaPz5vkAlijuGxSUnMyy1KL9O0S
	uDIm3H3FWNDHVtG5pYutgXEiaxcjJ4eEgIlE9+OlTBC2mMSFe+vZuhi5OIQEljJKvNm9mQnC
	6WOS+HVlLzNIFZuAscTm5UvYQGwRgSyJH9NWs4DYzAIBEo3Ld7KD2MICHhK/p88GqufgYBFQ
	lVix2wckzAsU7jl/gAVimZzEyWOTwY7gBIq/uH0WzBYScJe4sWoSywRG3gWMDKsYRVNLkwuK
	k9JzjfSKE3OLS/PS9ZLzczcxQgLn6w7GpcesDjEKcDAq8fB6MBcEC7EmlhVX5h5ilOBgVhLh
	df9UGCzEm5JYWZValB9fVJqTWnyIkYmDU6qB0adOTWV9jKi0sPcljY/rM34v5Qu/xXmXKbll
	QnfiraOPqjhPrRe/x3E2fon/ZCsV1QClqstb7kyKy8w8w7Zu+3O+w5NLA+dw9rz6Potz3w/p
	KPmcFZM8Pe8yf5qrvNLZqjzFtKL4fsOxgJcdR2bOvh2w+O684zdtnRaE+tzUZoj/EmksMXeh
	jxJLcUaioRZzUXEiAFhy0Gb6AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Array of struct of_device_id may be be const as expected by
of_platform_populate() call.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 651e249287dc..b48d80c367f9 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -557,7 +557,7 @@ static int usbhs_omap_get_dt_pdata(struct device *dev,
 	return 0;
 }
 
-static struct of_device_id usbhs_child_match_table[] = {
+static const struct of_device_id usbhs_child_match_table[] = {
 	{ .compatible = "ti,omap-ehci", },
 	{ .compatible = "ti,omap-ohci", },
 	{ }
-- 
1.9.1


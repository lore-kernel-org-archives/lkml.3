Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbaENDRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 23:17:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51891 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbaENDRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 23:17:16 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-ff-5372e03b2045
From: Jingoo Han <jg1.han@samsung.com>
To: "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] mfd: ipaq-micro: Use devm_ioremap_resource()
Date: Wed, 14 May 2014 12:17:14 +0900
Message-id: <001d01cf6f23$00900250$01b006f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9vIwB4Yx2Jf2/8QOW/D+L2APg3bg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zA13rB0XBBm0bmS0uL7zEanH/61FG
	iyl/ljNZXN41h83idDerA6vHnWt72DzmnQz06NuyitHj8ya5AJYoLpuU1JzMstQifbsEroxJ
	C9YyFzzkqNjy7j5TA+Ma9i5GTg4JAROJPzePMULYYhIX7q1n62Lk4hASWMYo0X/uFxtM0Zon
	U6ASixgl3rzewQySEBL4zSjxc70piM0moCbx5cthsKkiQPbNPbOYQBqYBWYxSrROmg2WEBaw
	lTj0bwZYM4uAqkTnwaWsIDYvUHzT87csELagxI/J98BsZgEtifU7jzNB2PISm9e8BerlALpI
	XeLRX12IXXoS1158gioRkdj34h0jyF4JgU3sEje+LWaC2CUg8W3yIRaIXlmJTQeYIR6TlDi4
	4gbLBEaxWUg2z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9yFivODG3uDQvXS85P3cTIyTa+ncw
	3j1gfYgxGWj9RGYp0eR8YLTmlcQbGpsZWZiamBobmVuakSasJM57/2FSkJBAemJJanZqakFq
	UXxRaU5q8SFGJg5OqQbGZeI/Yv4EnZOfb7B4l1wti+YVMebC3jfFZvs1C6YfZDsZ1L4vpttF
	5YNJmnlNdPyPi4I3Tr45uFPQrYr1x+pvR4PO5GQ3iATvN/E7fYB55hlvw+/ONZPUXvDz3Ds5
	/86Odz7dHay3PItt38w+4iO4r2Odt9kihxT/DS5ZWkadk/ZUmLZ7hz1SYinOSDTUYi4qTgQA
	+NpXwcwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jAV2rB0XBBseWilpcXniJ1eL+16OM
	FlP+LGeyuLxrDpvF6W5WB1aPO9f2sHnMOxno0bdlFaPH501yASxRDYw2GamJKalFCql5yfkp
	mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBrlRTKEnNKgUIBicXFSvp2mCaE
	hrjpWsA0Ruj6hgTB9RgZoIGEdYwZkxasZS54yFGx5d19pgbGNexdjJwcEgImEmueTGGDsMUk
	LtxbD2RzcQgJLGKUePN6BzNIQkjgN6PEz/WmIDabgJrEly+HwZpFgOybe2YxgTQwC8xilGid
	NBssISxgK3Ho3wywZhYBVYnOg0tZQWxeoPim529ZIGxBiR+T74HZzAJaEut3HmeCsOUlNq95
	C9TLAXSRusSjv7oQu/Qkrr34BFUiIrHvxTvGCYxASxEmzUIyaRaSSbOQtCxgZFnFKJpakFxQ
	nJSea6hXnJhbXJqXrpecn7uJERzLz6R2MK5ssDjEKMDBqMTDe8O5KFiINbGsuDL3EKMEB7OS
	CG/5FqAQb0piZVVqUX58UWlOavEhxmSgRycyS4km5wPTTF5JvKGxiZmRpZGZhZGJuTlpwkri
	vAdarQOFBNITS1KzU1MLUotgtjBxcEo1MNpr3tSQYGONtg7OEwi552n65hJ35GbVrGf/jm5a
	HfundfnvVvGli2YXXGbp9zF0npM/X76F59Dd96+2cE3QfNqdoHruGDf7jPeVDAntiWeD2s86
	PSngyOje9a846kOPpEhiiOL65wdvfA+c0227xbOpbVHa1a+7JlTP/mFyNjr4ZRB/T/pEbSWW
	4oxEQy3mouJEAG1EFVkpAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap_resource() because devm_request_and_ioremap() is
obsoleted by devm_ioremap_resource().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/ipaq-micro.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/ipaq-micro.c b/drivers/mfd/ipaq-micro.c
index 1763d6d..5d08daf 100644
--- a/drivers/mfd/ipaq-micro.c
+++ b/drivers/mfd/ipaq-micro.c
@@ -403,17 +403,17 @@ static int micro_probe(struct platform_device *pdev)
 	if (!res)
 		return -EINVAL;
 
-	micro->base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!micro->base)
-		return -ENOMEM;
+	micro->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(micro->base))
+		return PTR_ERR(micro->base);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (!res)
 		return -EINVAL;
 
-	micro->sdlc = devm_request_and_ioremap(&pdev->dev, res);
-	if (!micro->sdlc)
-		return -ENOMEM;
+	micro->sdlc = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(micro->sdlc))
+		return PTR_ERR(micro->sdlc);
 
 	micro_reset_comm(micro);
 
-- 
1.7.10.4



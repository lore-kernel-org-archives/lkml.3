Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161184Ab3BOGpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:45:04 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:50657 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161111Ab3BOGpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:45:01 -0500
X-AuditID: cbfee690-b7f066d00000169f-f9-511dd96b0fb4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001e01ce0b47$8edd1480$ac973d80$%han@samsung.com>
In-reply-to: <001e01ce0b47$8edd1480$ac973d80$%han@samsung.com>
Subject: [PATCH V2 04/11] rtc: rtc-ds2404: use dev_err() instead of printk()
Date: Fri, 15 Feb 2013 15:44:59 +0900
Message-id: <002201ce0b47$f97aa0f0$ec6fe2d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LR47AXgjtu6e1Qmq7gnKtv11nagAAFNtQ
Content-language: ko
x-cr-hashedpuzzle: KtgU NFqx PPEw RHFj UqW4 XZmB X2W4 e3aM fbAK jFMD mTn/ nHNr
 onpB peK5 rPAp
 rkQw;5;YQAuAHoAdQBtAG0AbwBAAHQAbwB3AGUAcgB0AGUAYwBoAC4AaQB0ADsAYQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcgB0AGMALQBsAGkAbgB1AHgAQABnAG8AbwBnAGwAZQBnAHIAbwB1AHAAcwAuAGMAbwBtAA==;Sosha1_v1;7;{66E5EEB7-8FCA-4646-BBB1-B9DB78992062};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Fri,
 15 Feb 2013 06:44:52
 GMT;WwBQAEEAVABDAEgAIABWADIAIAAwADQALwAxADEAXQAgAHIAdABjADoAIAByAHQAYwAtAGQAcwAyADQAMAA0ADoAIAB1AHMAZQAgAGQAZQB2AF8AZQByAHIAKAApACAAaQBuAHMAdABlAGEAZAAgAG8AZgAgAHAAcgBpAG4AdABrACgAKQA=
x-cr-puzzleid: {66E5EEB7-8FCA-4646-BBB1-B9DB78992062}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zI93sm7KBBpummVlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M2R93shVM4azo+dTN3sC4hr2LkZNDQsBEovfVLzYIW0ziwr31
	QDYXh5DAMkaJfV82ssIUzX95gB0isYhRYnXvHihnNpPE7ldfmEGq2ATUJL58OQyU4OAQEdCX
	aGvRAKlhFuhllDjTuxssLiRgKzH1tjOIySlgJ/F+uilIp7CAj8Szs/OYQGwWAVWJvv7dzCAl
	vEDV8y8Kg4R5BQQlfky+xwJiMwtoSWze1sQKYctLbF7zFqxcQkBd4tFfXZCwiICRRNPs91Dl
	IhL7XrxjhPjkA6vE5GduELapxP+z61hAjpQQ2MUuceHkZVaIEwQkvk0+xAIxU1Zi0wFmiHpJ
	iYMrbrBMYJSaheSiWUgumoXkollIVi9gZFnFKJpakFxQnJReZKJXnJhbXJqXrpecn7uJERKF
	E3Yw3jtgfYgxGWj9RGYp0eR8YBTnlcQbGhubmJmYmphbmpqbkiasJM4rf0kmUEggPbEkNTs1
	tSC1KL6oNCe1+BAjEwenVANjrLEHy+uI0KVq/qXWnzYlyXVxKS2/nuV3JipOhPnf+f4Jt02s
	TC/NSuz4tdQ9IeDLv2Nrt3Ruz4v8sD8u11pxDnv5+b6G0xY1B+RzFzbq8RW/Ofq2vejfyQZm
	90uOClef2Ki8lD/2ukviW3O+tfeyvND0nVmObxd/fGcik/753OY5O8XnJ7sosRRnJBpqMRcV
	JwIAJ+zR/dgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jAd3sm7KBBnf2GVhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjNkfd7IVTOGs6PnUzd7A
	uIa9i5GTQ0LARGL+ywNQtpjEhXvr2boYuTiEBBYxSqzu3cMO4cxmktj96gszSBWbgJrEly+H
	gRIcHCIC+hJtLRogNcwCvYwSZ3p3g8WFBGwlpt52BjE5Bewk3k83BekUFvCReHZ2HhOIzSKg
	KtHXv5sZpIQXqHr+RWGQMK+AoMSPyfdYQGxmAS2JzduaWCFseYnNa96ClUsIqEs8+qsLEhYR
	MJJomv0eqlxEYt+Ld4wQn3xglZj8zA3CNpX4f3YdywRGkVlINsxCsmEWkg2zkIxawMiyilE0
	tSC5oDgpPddIrzgxt7g0L10vOT93EyM4xp9J72Bc1WBxiFGAg1GJh1dAQjZQiDWxrLgy9xCj
	BAezkgjvmhCgEG9KYmVValF+fFFpTmrxIcZkoP8nMkuJJucD009eSbyhsYmZkaWRmYWRibk5
	acJK4ryMp54ECAmkJ5akZqemFqQWwWxh4uCUamB0ecmT+Efh5bv+eQ/DJ0bkntsYf/D6LHeX
	5R+0dW2vBuxK9/CX/L1rp+Cm3ZwPNa7nLcju/PF7281kiXSWPc4F3wXVv/sWXmBZZGgcaPmV
	qSqDa6Yck4Pi6pDFy3+yL7jz3fzGz5v/mSemWrYsbFi4ttpm74aN8Udil39mfrDY+u7cstpc
	9uUqSizFGYmGWsxFxYkATNI6IzUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the checkpatch warning as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
No changes since v1:

 drivers/rtc/rtc-ds2404.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-ds2404.c b/drivers/rtc/rtc-ds2404.c
index 4539e37..b04fc42 100644
--- a/drivers/rtc/rtc-ds2404.c
+++ b/drivers/rtc/rtc-ds2404.c
@@ -70,7 +70,7 @@ static int ds2404_gpio_map(struct ds2404 *chip, struct platform_device *pdev,
 	for (i = 0; i < ARRAY_SIZE(ds2404_gpio); i++) {
 		err = gpio_request(ds2404_gpio[i].gpio, ds2404_gpio[i].name);
 		if (err) {
-			printk(KERN_ERR "error mapping gpio %s: %d\n",
+			dev_err(&pdev->dev, "error mapping gpio %s: %d\n",
 				ds2404_gpio[i].name, err);
 			goto err_request;
 		}
@@ -177,7 +177,7 @@ static void ds2404_write_memory(struct device *dev, u16 offset,
 
 	for (i = 0; i < length; i++) {
 		if (out[i] != ds2404_read_byte(dev)) {
-			printk(KERN_ERR "read invalid data\n");
+			dev_err(dev, "read invalid data\n");
 			return;
 		}
 	}
-- 
1.7.2.5



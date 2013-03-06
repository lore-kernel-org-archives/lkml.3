Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab3CFF3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:29:55 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:48505 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab3CFF3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:29:53 -0500
X-AuditID: cbfee68d-b7f636d0000009be-85-5136d450f718
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 08/30] rtc: rtc-ds1742: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:29:52 +0900
Message-id: <004a01ce1a2b$a0e6a8b0$e2b3fa10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAAFlBw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zQ92AK2aBBmvuGVlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mm09WMBa846xYvPU3ewPjLI4uRk4OCQETicP/FjND2GISF+6t
	Z+ti5OIQEljGKLFp3xEmmKKj97qhEosYJW59Xg3lzGaSWNqxCKyKTUBN4suXw+xdjBwcIgL6
	Em0tGiA1zAK9jBJnenezg9QICdhKXO1eBbaOU8BOYvnjWSwgtrCAm0TXjBY2kF4WAVWJfTcz
	QMK8QOWfWiYwQ9iCEj8m3wMrZxbQkli/8zgThC0vsXnNW2aQVgkBdYlHf3VBwiICRhLzzsxl
	hCgRkdj34h0jxC/L2CW+HLIBsVkEBCS+TT7EAtEqK7HpADQcJCUOrrjBMoFRYhaSxbOQLJ6F
	ZPEsJBsWMLKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAiJq94djLcPWB9iTAZaP5FZSjQ5
	HxiXeSXxhsbGJmYmpibmlqbmpqQJK4nzyl2SCRQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA
	2CE7+fie1gdJ1eY8uwMkr/M1u2yPtvvUsMXVIourv/1i7J4Kaa/KWmcbsYTIG/yuB16/vifX
	s5HF0LHK+cKFmTMs+mfsF9Pyl3/x3GDKn4KwjXKeldPOCNy+cHnPgcULd97W/c+l3WkU+9lY
	L9Qg94HSy5+lXE/sN2fYaM20k769s1in702eEktxRqKhFnNRcSIALG8rpMECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgG7AFbNAgyWHdC0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxs0nKxgL3nFWLN76m72B
	cRZHFyMnh4SAicTRe91sELaYxIV764FsLg4hgUWMErc+r4ZyZjNJLO1YxARSxSagJvHly2H2
	LkYODhEBfYm2Fg2QGmaBXkaJM7272UFqhARsJa52r2IGsTkF7CSWP57FAmILC7hJdM1oYQPp
	ZRFQldh3MwMkzAtU/qllAjOELSjxY/I9sHJmAS2J9TuPM0HY8hKb17xlBmmVEFCXePRXFyQs
	ImAkMe/MXEaIEhGJfS/eMU5gFJqFZNIsJJNmIZk0C0nLAkaWVYyiqQXJBcVJ6blGesWJucWl
	eel6yfm5mxjBcftMegfjqgaLQ4wCHIxKPLwTVMwChVgTy4orcw8xSnAwK4nwcp0BCvGmJFZW
	pRblxxeV5qQWH2JMBvpzIrOUaHI+MKXklcQbGpuYGVkamVkYmZibkyasJM7LeOpJgJBAemJJ
	anZqakFqEcwWJg5OqQbGjmlPfGdd/B5SP29VzBTPbwY1+x/emLhCpkhX7aTNy/tTvVRuvDDJ
	4X13yp2B91XztMrdOyzuZJjKK955H5zFY7Psxf89ApzLrBIP8Fq4nprtstuC+9nGCcXRMqfX
	m0y6aubTt/jqv6uuCWEWejWy7Q9PcRwzvXXe95nAPa2zqkv3fGhPmbxppRJLcUaioRZzUXEi
	AMwhFuEfAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-ds1742.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
index 609c870..a270792 100644
--- a/drivers/rtc/rtc-ds1742.c
+++ b/drivers/rtc/rtc-ds1742.c
@@ -208,17 +208,14 @@ static int ds1742_rtc_probe(struct platform_device *pdev)
 
 	pdata->last_jiffies = jiffies;
 	platform_set_drvdata(pdev, pdata);
-	rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc = devm_rtc_device_register(pdev->name, &pdev->dev,
 				  &ds1742_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 	pdata->rtc = rtc;
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &pdata->nvram_attr);
-	if (ret) {
-		dev_err(&pdev->dev, "creating nvram file in sysfs failed\n");
-		rtc_device_unregister(rtc);
-	}
+
 	return ret;
 }
 
@@ -227,7 +224,6 @@ static int ds1742_rtc_remove(struct platform_device *pdev)
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &pdata->nvram_attr);
-	rtc_device_unregister(pdata->rtc);
 	return 0;
 }
 
-- 
1.7.2.5



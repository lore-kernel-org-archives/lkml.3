Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab3CKGda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 02:33:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60055 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3CKGd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 02:33:29 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-12-513d7ab73808
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
In-reply-to: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
Subject: [PATCH 07/14] power: gpio-charger: use devm_kzalloc()
Date: Mon, 11 Mar 2013 15:33:27 +0900
Message-id: <007701ce1e22$56dcb7f0$049627d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4eIfOI6J7YtEddQ/Gjh19YaZUzVAAAFM8g
Content-language: ko
x-cr-hashedpuzzle: B3Zu FAuA Fd3e G9NY LQJ9 OikD Qh14 RGgb Uuyh W5ww ZovI gQAV
 iWuC kilg nKjU
 ndMX;4;YQBuAHQAbwBuAEAAZQBuAG8AbQBzAGcALgBvAHIAZwA7AGQAdwBtAHcAMgBAAGkAbgBmAHIAYQBkAGUAYQBkAC4AbwByAGcAOwBqAGcAMQAuAGgAYQBuAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{D6F27D8E-1288-453F-B0CF-7D63C643A734};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Mon,
 11 Mar 2013 06:33:21
 GMT;WwBQAEEAVABDAEgAIAAwADcALwAxADQAXQAgAHAAbwB3AGUAcgA6ACAAZwBwAGkAbwAtAGMAaABhAHIAZwBlAHIAOgAgAHUAcwBlACAAZABlAHYAbQBfAGsAegBhAGwAbABvAGMAKAApAA==
x-cr-puzzleid: {D6F27D8E-1288-453F-B0CF-7D63C643A734}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t8zA93tVbaBBhs2aFgc3KppMXHlZGaL
	ywsvsVpc3jWHzYHFY0L/J0aPzSu0PPq2rGL0+LxJLoAlissmJTUnsyy1SN8ugStj46mLbAXN
	nBVP77QxNTDuZ+9i5OSQEDCR+Db/ASuELSZx4d56ti5GLg4hgWWMEmu2b2SEKZo86wVUYjqj
	xJwL+6GcX4wSh9pXsIBUsQmoSXz5chhsrIiAhkTb6ilgcWaBfInDhy6D2UICthK7f74Am8op
	YCdxY9klNhBbGMje/XkJ2BksAqoSd95+AbI5OHiB6ud8sQAJ8woISvyYfA9qpJbE5m1NrBC2
	vMTmNW+ZQcolBNQlHv3VhbjASGLxydlMECUiEvtevIP65QWLxOtj0hC2qcTMbV9ZQV6RELjF
	LvFsC8Q5LAICEt8mH2KBmCkrsekAM0S9pMTBFTdYJjBKzUJy0SwkF81CctEsJKsXMLKsYhRN
	LUguKE5KLzLVK07MLS7NS9dLzs/dxAiJ4Ik7GO8fsD7EmAy0fiKzlGhyPjAB5JXEGxqbGVmY
	mpgaG5lbmpEmrCTOq95iHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB0eXU0p/KHFs03vz+
	XqpgvcBJ5vj5ZYFlpl2z+ZfNerly2e+J2z5NetnG1ip/4+XSh8nTCk4UVcg3RZZOMzT7HbLh
	30f7nPfhJ+xfzfmWqMFqpHtmsnPEwj2OWoeOLBQperdgX+iP8xf4Jkxx+ZVentL89vr5NTut
	9yrapNztXvWzZpa33vsjVVFKLMUZiYZazEXFiQAdG0PG9gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsVy+t9jQd3tVbaBBp/Xqlgc3KppMXHlZGaL
	ywsvsVpc3jWHzYHFY0L/J0aPzSu0PPq2rGL0+LxJLoAlqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsI4xY+Opi2wFzZwVT++0MTUw7mfvYuTkkBAwkZg86wUbhC0mceHeeiCb
	i0NIYDqjxJwL+6GcX4wSh9pXsIBUsQmoSXz5chisW0RAQ6Jt9RSwOLNAvsThQ5fBbCEBW4nd
	P18wgticAnYSN5ZdAtsgDGTv/ryEFcRmEVCVuPP2C5DNwcELVD/niwVImFdAUOLH5HtQI7Uk
	Nm9rYoWw5SU2r3nLDFIuIaAu8eivLsQFRhKLT85mgigRkdj34h0jxC8vWCReH5OGsE0lZm77
	yjqBUWQWkg2zkGyYhWTDLCSjFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQITg/PpHYw
	rmywOMQowMGoxMM7Qcc2UIg1say4MvcQowQHs5II78pNNoFCvCmJlVWpRfnxRaU5qcWHGJOB
	/p/ILCWanA9MXXkl8YbGJmZGlkZmFkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnV
	wOjH6OdTMf8kx0Yju1cnlzKz/guWXibyoTbIj89ZjF/2lskRM9Udd+dmrZqdcnn6g1kiK27o
	CjF9UpzLGhAufclM6PSWnUYH+PheGi68f8yxbkb+hsA7ekYftrH61evv2J71JfRE4M9Y9+rT
	hU9+X81n8Wh4lXf6f5ZQbqj+nKjln3rY3Bi5+5VYijMSDbWYi4oTAQbtNxFTAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/power/gpio-charger.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
index e3e40a9..e9883ee 100644
--- a/drivers/power/gpio-charger.c
+++ b/drivers/power/gpio-charger.c
@@ -86,7 +86,8 @@ static int gpio_charger_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	gpio_charger = kzalloc(sizeof(*gpio_charger), GFP_KERNEL);
+	gpio_charger = devm_kzalloc(&pdev->dev, sizeof(*gpio_charger),
+					GFP_KERNEL);
 	if (!gpio_charger) {
 		dev_err(&pdev->dev, "Failed to alloc driver structure\n");
 		return -ENOMEM;
@@ -140,7 +141,6 @@ static int gpio_charger_probe(struct platform_device *pdev)
 err_gpio_free:
 	gpio_free(pdata->gpio);
 err_free:
-	kfree(gpio_charger);
 	return ret;
 }
 
@@ -156,7 +156,6 @@ static int gpio_charger_remove(struct platform_device *pdev)
 	gpio_free(gpio_charger->pdata->gpio);
 
 	platform_set_drvdata(pdev, NULL);
-	kfree(gpio_charger);
 
 	return 0;
 }
-- 
1.7.2.5



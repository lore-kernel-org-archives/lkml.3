Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab3CFHtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:49:07 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:57253 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab3CFHtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:49:03 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-02-5136f4edf57d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 05/30] rtc: rtc-davinci: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:49:01 +0900
Message-id: <007f01ce1a3f$11466150$33d323f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAADU8g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zY923X8wCDT5c0bNYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANYrLJiU1J7Ms
	tUjfLoEr486FdywFp3kqri2TaGBcz9XFyMkhIWAi8XBWPyOELSZx4d56ti5GLg4hgWWMEjce
	N7HBFH3Ze4cJIjGdUWLByWesEM4vRokTS6azg1SxCahJfPlyGMjm4BAR0Jdoa9EAqWEW6GWU
	ONO7GywuJGAr0TOPB6ScU8BOYsrEx2CtwgJeEgt+bmcGsVkEVCXWnf0FdhEvUPnH2d/ZIWxB
	iR+T77GA2MwCWhLrdx5ngrDlJTavecsMMl5CQF3i0V9dkLCIgJHEskvzoEpEJPa9eMcIco6E
	wD12iZOzu1khdglIfJt8iAWiV1Zi0wFmiH8lJQ6uuMEygVFiFpLNs5BsnoVk8ywkKxYwsqxi
	FE0tSC4oTkovMtYrTswtLs1L10vOz93ECInT/h2Mdw9YH2JMBlo/kVlKNDkfGOd5JfGGxsYm
	ZiamJuaWpuampAkrifPKX5IJFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cC4umzmEc1tm/bY
	Z7dZGYtU8Zpsuu9hM6vgeNTK+31vFv72371kimvrzr+fc8/+vuKawnlYqUmvrsOVqeQx26zA
	uHqWyp6DJQujLyRtr/7F9eaYbaIx58eN4i7zS3WdBLOtNQNitQ3sWxb+vqwVu3zyjOaWY3Ln
	p0re+d13dFmZv/3lwBNVx/4psRRnJBpqMRcVJwIAgOs5N+kCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd23X8wCDTZM0LJYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePOhXcsBad5Kq4tk2hgXM/VxcjJISFgIvFl
	7x0mCFtM4sK99WxdjFwcQgLTGSUWnHzGCuH8YpQ4sWQ6O0gVm4CaxJcvh4FsDg4RAX2JthYN
	kBpmgV5GiTO9u8HiQgK2Ej3zeEDKOQXsJKZMfAzWKizgJbHg53ZmEJtFQFVi3dlfjCA2L1D5
	x9nf2SFsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDDJeQkBd4tFfXZCwiICRxLJL86BKRCT2
	vXjHOIFRaBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgQngWfS
	OxhXNVgcYhTgYFTi4Z2gYhYoxJpYVlyZe4hRgoNZSYSX6wxQiDclsbIqtSg/vqg0J7X4EGMy
	0KMTmaVEk/OBCSqvJN7Q2MTMyNLIzMLIxNycNGElcV7GU08ChATSE0tSs1NTC1KLYLYwcXBK
	NTAy6jx57bNIv7NveVxAwU2GILMmozXTHs8X3n/b/Vtf+5EzclfD1rTozS7pyEzW/OT+QuL/
	rLDqy4zsdpMbV6zfc8JEPrORTfPRhPl73v2IMfdalDSPR7s0u43fkUu1sEOop8KMnUVWznHN
	txdzfE3kcz6v/yDVenH99v7d+w8/FjurvnKd3EYlluKMREMt5qLiRADAphv/RgMAAA==
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
Changes since v1:
- used 'struct device *dev' as the first argument

 drivers/rtc/rtc-davinci.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
index db877e0..4e8d2a7 100644
--- a/drivers/rtc/rtc-davinci.c
+++ b/drivers/rtc/rtc-davinci.c
@@ -523,7 +523,7 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, davinci_rtc);
 
-	davinci_rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	davinci_rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				    &davinci_rtc_ops, THIS_MODULE);
 	if (IS_ERR(davinci_rtc->rtc)) {
 		ret = PTR_ERR(davinci_rtc->rtc);
@@ -543,7 +543,7 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 			  0, "davinci_rtc", davinci_rtc);
 	if (ret < 0) {
 		dev_err(dev, "unable to register davinci RTC interrupt\n");
-		goto fail2;
+		goto fail1;
 	}
 
 	/* Enable interrupts */
@@ -557,8 +557,6 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 
 	return 0;
 
-fail2:
-	rtc_device_unregister(davinci_rtc->rtc);
 fail1:
 	platform_set_drvdata(pdev, NULL);
 	return ret;
@@ -572,8 +570,6 @@ static int __exit davinci_rtc_remove(struct platform_device *pdev)
 
 	rtcif_write(davinci_rtc, 0, PRTCIF_INTEN);
 
-	rtc_device_unregister(davinci_rtc->rtc);
-
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.7.2.5



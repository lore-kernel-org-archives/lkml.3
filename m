Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab3CFHxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:53:30 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:46504 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab3CFHxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:53:24 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-ab-5136f5f399ba
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 17/30] rtc: rtc-mxc: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:53:23 +0900
Message-id: <008b01ce1a3f$ad40f3e0$07c2dba0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAANVpQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zY93PX80CDR7el7JYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANYrLJiU1J7Ms
	tUjfLoEr48a834wFWzgqFn+5xtjA+I+ti5GTQ0LARGLx6k1QtpjEhXvrgWwuDiGBZYwSPa9/
	scAUrVuxASoxnVFi8tk7LBDOL0aJ/udrwarYBNQkvnw5zN7FyMEhIqAv0daiAVLDLNDLKHGm
	dzdYXEjAVqJnHg9IOaeAncSUiY/ZQWxhATeJZ78egI1hEVCV+Lf9NBOIzQtU/m3eZhYIW1Di
	x+R7YDazgJbE+p3HmSBseYnNa94yg4yXEFCXePRXFyQsImAkcfHoTDaIEhGJfS/eMYKcIyFw
	j13i57IZzBC7BCS+TT7EAtErK7HpADPEv5ISB1fcYJnAKDELyeZZSDbPQrJ5FpIVCxhZVjGK
	phYkFxQnpReZ6hUn5haX5qXrJefnbmKEROrEHYz3D1gfYkwGWj+RWUo0OR8Y6Xkl8YbGxiZm
	JqYm5pam5qakCSuJ88pfkgkUEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwLjO6f2eVFuR6JOp
	4iKsqvUFzo+/PvcNDEu9tkj/Ek/0J1/Bze4pD2R4nWcICjVbqr6YJR7If2ndzbtMS+fdfOIl
	4va0nMvxkfid0ocumyfblKhaX5Se6NH+s4fPYuoxpb9qe0/nFlw3vxq5Zf63YLn379bwGkTr
	PPwlO0VmovjaGnNpUds+HyWW4oxEQy3mouJEALcDe63qAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd3PX80CDY7OFbNYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePGvN+MBVs4KhZ/ucbYwPiPrYuRk0NCwERi
	3YoNULaYxIV764FsLg4hgemMEpPP3mGBcH4xSvQ/X8sCUsUmoCbx5cth9i5GDg4RAX2JthYN
	kBpmgV5GiTO9u8HiQgK2Ej3zeEDKOQXsJKZMfMwOYgsLuEk8+/UAbAyLgKrEv+2nmUBsXqDy
	b/M2s0DYghI/Jt8Ds5kFtCTW7zzOBGHLS2xe85YZZLyEgLrEo7+6IGERASOJi0dnskGUiEjs
	e/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhOA8+k
	djCubLA4xCjAwajEw2uhZBYoxJpYVlyZe4hRgoNZSYSX6wxQiDclsbIqtSg/vqg0J7X4EGMy
	0KMTmaVEk/OBKSqvJN7Q2MTMyNLIzMLIxNycNGElcV7GU08ChATSE0tSs1NTC1KLYLYwcXBK
	NTAu5Vq91EJ84myt8PmflnUy3HjFeSTK6JbRdOafel9d0n8rCxzn2bxlYZR/9ezT1oHZf53e
	zj3cebJB5J6p4q7A3sZ7Zsp+Xs072LyiZBYw1Tku8jBMnihgyHJHotH6y8rZB0oit7ibPv+W
	MS23pE7S7t29N5GKzU3/ToUEcXc92OxaUfBC6b4SS3FGoqEWc1FxIgBgChLNRwMAAA==
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

 drivers/rtc/rtc-mxc.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index 1c3ef72..13380ca 100644
--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -439,7 +439,7 @@ static int mxc_rtc_probe(struct platform_device *pdev)
 	if (pdata->irq >=0)
 		device_init_wakeup(&pdev->dev, 1);
 
-	rtc = rtc_device_register(pdev->name, &pdev->dev, &mxc_rtc_ops,
+	rtc = devm_rtc_device_register(&pdev->dev, pdev->name, &mxc_rtc_ops,
 				  THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		ret = PTR_ERR(rtc);
@@ -464,8 +464,6 @@ static int mxc_rtc_remove(struct platform_device *pdev)
 {
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	rtc_device_unregister(pdata->rtc);
-
 	clk_disable_unprepare(pdata->clk);
 	platform_set_drvdata(pdev, NULL);
 
-- 
1.7.2.5



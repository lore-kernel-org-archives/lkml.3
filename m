Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab3CFHsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:48:38 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:51759 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3CFHsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:48:37 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-d0-5136f4d394e0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 04/30] rtc: rtc-da9055: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:48:35 +0900
Message-id: <007e01ce1a3f$01b11f50$05135df0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAACfwQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zfd3LX8wCDf626FgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV8XpTD2vBUo6Kzoff2BoYP7F1MXJySAiYSHSv+M8OYYtJXLi3HijOxSEksIxRYs/i
	N8wwRRumtbOA2EIC0xklZp4OhSj6xSjx/9lMVpAEm4CaxJcvh4EmcXCICOhLtLVogNQwC/Qy
	Spzp3Q0WFxKwleiZxwNSzilgJzFl4mOwsLCAp0TTCn+QMIuAqsSfOa/AbuMFqn60o50VwhaU
	+DH5HtgJzAJaEut3HmeCsOUlNq95ywwyRkJAXeLRX12QsIiAkcTF9e/YIUpEJPa9eMcIco2E
	wD12iUW9V1ghdglIfJt8iAWiV1Zi0wGobyUlDq64wTKBUWIWks2zkGyehWTzLCQrFjCyrGIU
	TS1ILihOSi8y1itOzC0uzUvXS87P3cQIidL+HYx3D1gfYkwGWj+RWUo0OR8Y5Xkl8YbGxiZm
	JqYm5pam5qakCSuJ88pfkgkUEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwGjF2HTOdnvb9m9v
	GfNT05R+cN2u5dm8QbLmtU2jHveGBbEv3QtU3Ce/PHYhJO9Lwt7qH2GHU1fZcQcxL0hv+8eS
	qjpFwSCqbtfpcoOFRXkr5yaXa+9+NneG4EeH8oanG5pZgy5zMzl3vZbYsWjTzBdNCT/Y92j4
	LnyUZvX5v9Hv3fZF2wvexiqxFGckGmoxFxUnAgA83gF36AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQd3LX8wCDV5eUbdYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMeP1ph7WgqUcFZ0Pv7E1MH5i62Lk5JAQMJHY
	MK2dBcIWk7hwbz1YXEhgOqPEzNOhXYxcQPYvRon/z2aygiTYBNQkvnw5zN7FyMEhIqAv0dai
	AVLDLNDLKHGmdzdYXEjAVqJnHg9IOaeAncSUiY/BwsICnhJNK/xBwiwCqhJ/5rwCW8ULVP1o
	RzsrhC0o8WPyPbBzmAW0JNbvPM4EYctLbF7zlhlkjISAusSjv7ogYREBI4mL69+xQ5SISOx7
	8Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE4Bz6R2
	MK5ssDjEKMDBqMTDa6FkFijEmlhWXJl7iFGCg1lJhJfrDFCINyWxsiq1KD++qDQntfgQYzLQ
	oxOZpUST84HpKa8k3tDYxMzI0sjMwsjE3Jw0YSVxXsZTTwKEBNITS1KzU1MLUotgtjBxcEo1
	MJZz5EofCipJsZDdVHztSGnWx7Wqov0LC8S6jjSx7Vn1OM0jV+tu4s6F+ewP/3LmLotdyBDy
	zypu1tL9LwIT5m6/+VIwNf267ZFLL4J+Oj40ebhBZGbSimi/1b3BEs8PflQW3nP82OTfbJ7Z
	jnLBvTGKAhd+VPyJu+83g/3EydV61y8xcvY9maHEUpyRaKjFXFScCABwTu9ERQMAAA==
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

 drivers/rtc/rtc-da9055.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-da9055.c b/drivers/rtc/rtc-da9055.c
index 8f0dcfe..73858ca 100644
--- a/drivers/rtc/rtc-da9055.c
+++ b/drivers/rtc/rtc-da9055.c
@@ -294,7 +294,7 @@ static int da9055_rtc_probe(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 					&da9055_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc)) {
 		ret = PTR_ERR(rtc->rtc);
@@ -317,9 +317,6 @@ err_rtc:
 
 static int da9055_rtc_remove(struct platform_device *pdev)
 {
-	struct da9055_rtc *rtc = pdev->dev.platform_data;
-
-	rtc_device_unregister(rtc->rtc);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.7.2.5



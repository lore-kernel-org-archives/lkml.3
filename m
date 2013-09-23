Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab3IWJtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:49:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29870 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab3IWJtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:49:45 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-14-52400eb85943
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
In-reply-to: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
Subject: [PATCH 12/15] rtc: rtc-pcf2123: use dev_get_platdata()
Date: Mon, 23 Sep 2013 18:49:44 +0900
Message-id: <002801ceb842$3b8976e0$b29c64a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64QJVrtN1IW24fTFCn/tCGU7Py3AAAYPfQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zQ90dfA5BBtuualosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV8evqA7aC/6wVt9smMTUw/mHpYuTkkBAwkZj59R4zhC0mceHeerYuRi4OIYFljBKT
	Hy1ggynqfHsarEhIYBGjxI9mZwj7F6PE/bcGIDabgJrEly+H2bsYOThEBPQl2lo0QOYwC/Qy
	Spzp3c0OUW8rMXHaVyYQm1PATmLN52VgtrCAvcSP4/PBalgEVCWunTvICmLzAtXP+jafGcIW
	lPgx+R7Y0cwCWhKbtzWxQtjyEpvXvGUG2SshoC7x6K8uSFhEwEjizt0nUOUiEvtevGMEuUdC
	4Ba7xOGZHxghdglIfJt8iAWiV1Zi0wFoOEhKHFxxg2UCo8QsJJtnIdk8C8nmWUhWLGBkWcUo
	mlqQXFCclF5kqlecmFtcmpeul5yfu4kREqcTdzDeP2B9iDEZaP1EZinR5HxgnOeVxBsamxlZ
	mJqYGhuZW5qRJqwkzqveYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgdE4UIFbTWTr3q4H
	x/5p7Hsj4BLoxrWtRzt4r+cj+zsC/MvFPhr9+HJMomyW9mb1rUcPqIqvCeu9K2cyafEMV1/T
	u36iG4x2hD5eYsqSZh36sOcH02MZv5We8edfv5km28DaqcITU73+j9CxfTtr3h5hs3p0yTp1
	zdsVT04Z7GeecnLap2tT8m2VWIozEg21mIuKEwHPsWfh6QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jAd0dfA5BBu8+qVosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmPHr6gO2gv+sFbfbJjE1MP5h6WLk5JAQMJHo
	fHuaGcIWk7hwbz0biC0ksIhR4kezM4T9i1Hi/lsDEJtNQE3iy5fD7F2MHBwiAvoSbS0aXYxc
	HMwCvYwSZ3p3s0PU20pMnPaVCcTmFLCTWPN5GZgtLGAv8eP4fLAaFgFViWvnDrKC2LxA9bO+
	zWeGsAUlfky+B3Ybs4CWxOZtTawQtrzE5jVvmUH2SgioSzz6qwsSFhEwkrhz9wlUuYjEvhfv
	GCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgJPBMegfj
	qgaLQ4wCHIxKPLyRifZBQqyJZcWVuYcYJTiYlUR4/VgdgoR4UxIrq1KL8uOLSnNSiw8xJgM9
	OpFZSjQ5H5ig8kriDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB
	0frla4X7P4rZTsyKK/4bNEFv18oTwZOqbCNLZjmJXjhl7HoiVdXJfkV24Pd5s5xmqM2vOjB3
	y9tE6Yy4bdoNagE3JjwNXtzIEqr+ka3+45aGJ/uSdsl4Pb/bevCE3D+NLf0cV9efs/XmcXmq
	byYTvurq0himaT8+Vp947fVdpCwuS3F7R8esI0osxRmJhlrMRcWJAAcOgbNGAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-pcf2123.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-pcf2123.c b/drivers/rtc/rtc-pcf2123.c
index 1725b50..d1953bb 100644
--- a/drivers/rtc/rtc-pcf2123.c
+++ b/drivers/rtc/rtc-pcf2123.c
@@ -327,7 +327,7 @@ kfree_exit:
 
 static int pcf2123_remove(struct spi_device *spi)
 {
-	struct pcf2123_plat_data *pdata = spi->dev.platform_data;
+	struct pcf2123_plat_data *pdata = dev_get_platdata(&spi->dev);
 	int i;
 
 	if (pdata) {
-- 
1.7.10.4



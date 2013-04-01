Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715Ab3DAJnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:43:32 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34778 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488Ab3DAJna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:43:30 -0400
X-AuditID: cbfee68d-b7f786d000005188-a0-515956c03ee6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 04/27] rtc: rtc-bq4802: use devm_*() functions
Date: Mon, 01 Apr 2013 18:43:28 +0900
Message-id: <000f01ce2ebd$5cdeb940$169c2bc0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAACgVw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zY90DYZGBBk/m6lssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV8fbKJaaCUwIVF9d8YG9gnMDbxcjJISFgIrFwzQx2CFtM4sK99WxdjFwcQgLLGCVa
	J7SwwBQdW/ObGSIxnVFiU/9hVgjnF6PEnmXL2ECq2ATUJL58OQw0ioNDREBfoq1FA6SGWaCX
	UeJM726wFUICthI/zn5nBrE5Bewk3iycxwhiCwPZ87qOg9ksAqoSzw68AavnBap/v/I6K4Qt
	KPFj8j2wi5gFtCTW7zzOBGHLS2xe85YZZK+EgLrEo7+6IGERASOJ+S+bWCFKRCT2vXjHCHKP
	hMAjdomVcyBuZhEQkPg2+RALRK+sxKYDzBAPS0ocXHGDZQKjxCwkm2ch2TwLyeZZSFYsYGRZ
	xSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iRESq707GG8fsD7EmAy0fiKzlGhyPjDW80riDY3N
	jCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAOEfZa9rlv0Id
	+i8zu/L4vra0//j+Zr6LfUth/J2GzTuLr++4762l2Xa/wihc9DnPjV3fJLIkPtatfx8yb7aY
	c/eS8Np70evUF0vOOGzxPqy45teFJ3qCHLuE8zc3LJHwW/Mm3TvlY3j9AVUfLc2WlZPWmy89
	nu40T6zt+ApL52sJ2mrXd/L/VGIpzkg01GIuKk4EAN8HBGfrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd0DYZGBBruXaVksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmPH2yiWmglMCFRfXfGBvYJzA28XIySEhYCJx
	bM1vZghbTOLCvfVsXYxcHEIC0xklNvUfZoVwfjFK7Fm2jA2kik1ATeLLl8PsXYwcHCIC+hJt
	LRogNcwCvYwSZ3p3s4PUCAnYSvw4+x1sKqeAncSbhfMYQWxhIHte13Ewm0VAVeLZgTdg9bxA
	9e9XXmeFsAUlfky+xwJiMwtoSazfeZwJwpaX2LzmLTPIXgkBdYlHf3VBwiICRhLzXzaxQpSI
	SOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE4E
	z6R3MK5qsDjEKMDBqMTDG3EhIlCINbGsuDL3EKMEB7OSCK/PN6AQb0piZVVqUX58UWlOavEh
	xmSgRycyS4km5wOTVF5JvKGxiZmRpZGZhZGJuTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBx
	cEo1MFqf6NySNlun4pOJhPTPxEue/VtLy95Nvrfr4kN/8Q9mH95zRATxpn62+MX+Lvpb9R0J
	DnEd3oS6FxL5ohPLRGJl5Ofn7Xlh+yjduP83u2TP658W7aHHL69h/s19If/QVdld65Z9KHv9
	wnK1/F2jOzoTlnUFbbxdznfkRbLJSv/ZN5k/yyQa71ZiKc5INNRiLipOBAAwC2WOSAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-bq4802.c |   29 ++++++++---------------------
 1 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/rtc/rtc-bq4802.c b/drivers/rtc/rtc-bq4802.c
index 693be71..af28867 100644
--- a/drivers/rtc/rtc-bq4802.c
+++ b/drivers/rtc/rtc-bq4802.c
@@ -142,7 +142,7 @@ static const struct rtc_class_ops bq4802_ops = {
 
 static int bq4802_probe(struct platform_device *pdev)
 {
-	struct bq4802 *p = kzalloc(sizeof(*p), GFP_KERNEL);
+	struct bq4802 *p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
 	int err = -ENOMEM;
 
 	if (!p)
@@ -155,54 +155,41 @@ static int bq4802_probe(struct platform_device *pdev)
 		p->r = platform_get_resource(pdev, IORESOURCE_IO, 0);
 		err = -EINVAL;
 		if (!p->r)
-			goto out_free;
+			goto out;
 	}
 	if (p->r->flags & IORESOURCE_IO) {
 		p->ioport = p->r->start;
 		p->read = bq4802_read_io;
 		p->write = bq4802_write_io;
 	} else if (p->r->flags & IORESOURCE_MEM) {
-		p->regs = ioremap(p->r->start, resource_size(p->r));
+		p->regs = devm_ioremap(&pdev->dev, p->r->start,
+					resource_size(p->r));
 		p->read = bq4802_read_mem;
 		p->write = bq4802_write_mem;
 	} else {
 		err = -EINVAL;
-		goto out_free;
+		goto out;
 	}
 
 	platform_set_drvdata(pdev, p);
 
-	p->rtc = rtc_device_register("bq4802", &pdev->dev,
-				     &bq4802_ops, THIS_MODULE);
+	p->rtc = devm_rtc_device_register(&pdev->dev, "bq4802",
+					&bq4802_ops, THIS_MODULE);
 	if (IS_ERR(p->rtc)) {
 		err = PTR_ERR(p->rtc);
-		goto out_iounmap;
+		goto out;
 	}
 
 	err = 0;
 out:
 	return err;
 
-out_iounmap:
-	if (p->r->flags & IORESOURCE_MEM)
-		iounmap(p->regs);
-out_free:
-	kfree(p);
-	goto out;
 }
 
 static int bq4802_remove(struct platform_device *pdev)
 {
-	struct bq4802 *p = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(p->rtc);
-	if (p->r->flags & IORESOURCE_MEM)
-		iounmap(p->regs);
-
 	platform_set_drvdata(pdev, NULL);
 
-	kfree(p);
-
 	return 0;
 }
 
-- 
1.7.2.5



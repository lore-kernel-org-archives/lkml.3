Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab3CNIVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:21:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25842 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab3CNIVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:21:00 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-1c-5141886b09db
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 19/30] rtc: rtc-r9701: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:20:58 +0900
Message-id: <009601ce208c$db7cc2e0$927648a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAXPlQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zI93sDsdAg5n7ZC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DK2NP0h71gI3vFg5O/2BoYW9m6GDk4JARMJBbuieti5AQyxSQu3FsPFObiEBJYxihx
	5u0mRoiEicTjLd3MEInpjBIXP+2HqvrFKNHy/CEzSBWbgJrEly+H2UGmigjoS7S1aIDUMAv0
	Ak3q3Q0WFxKwlbj+3w7E5BSwk9iwXgykU1jAVWL/qh6wXSwCqhIz534Gm8gLVP365C0oW1Di
	x+R7LCA2s4CWxPqdx5kgbHmJzWveMkP8oi7x6K8uSFhEwEhi6r61rBAlIhL7XrxjBLlGQuAW
	u8TMu8/ZIXYJSHybfIgFoldWYtMBZoh3JSUOrrjBMoFRYhaSzbOQbJ6FZPMsJCsWMLKsYhRN
	LUguKE5KLzLWK07MLS7NS9dLzs/dxAiJ0v4djHcPWB9iTAZaP5FZSjQ5HxjleSXxhsZmRham
	JqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpgbPEoj2fcc81HWSly
	rb7UGUuXxgUv6tKYAlfPnDxdd/XU6BWrgyYt5uBjChc/mB3H9cN854nMpGfslqeiK88EGp5v
	K9zLxvE04cdN7kN3S5fKL3SY2f2zdEacgPJ0Neajf+4pKUcuSlk5xy5uStGZOXJ935P8gp9a
	7u12ip9ivXuFidyq+4dMlViKMxINtZiLihMB3AyIEegCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd3sDsdAg5YdkhZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZuxp+sNesJG94sHJX2wNjK1sXYycHBICJhKP
	t3QzQ9hiEhfurQeKc3EICUxnlLj4aT+U84tRouX5Q7AqNgE1iS9fDrN3MXJwiAjoS7S1aIDU
	MAv0Mkqc6d0NFhcSsJW4/t8OxOQUsJPYsF4MpFNYwFVi/6oeRhCbRUBVYubcz2ATeYGqX5+8
	BWULSvyYfI8FxGYW0JJYv/M4E4QtL7F5zVtmkJESAuoSj/7qgoRFBIwkpu5bywpRIiKx78U7
	xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4CTyT3sG4
	qsHiEKMAB6MSD2+EqGOgEGtiWXFl7iFGCQ5mJRFeTy+gEG9KYmVValF+fFFpTmrxIcZkoEcn
	MkuJJucDE1ReSbyhsYmZkaWRmYWRibk5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTA2
	xz5p1d5RGZX1cLt/l37RtBNrl/v0XW7/dnKi++a7LVUTN/o/UjIS4JE9zc3YKvJBo9jlb31R
	3dPHUjqqBSt7VPz8/89YHdfG+iYyf7fNh8oZOgwnnuxMfDfT2vevj6PYpvNpzlVTYx/NrZh6
	XWjpw9xk7cn9jD8vvbFVKGzPcr/6/nPTdx0lluKMREMt5qLiRACfyqZgRgMAAA==
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
 drivers/rtc/rtc-r9701.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-r9701.c b/drivers/rtc/rtc-r9701.c
index 7726f4a..0adf5b5 100644
--- a/drivers/rtc/rtc-r9701.c
+++ b/drivers/rtc/rtc-r9701.c
@@ -154,8 +154,8 @@ static int r9701_probe(struct spi_device *spi)
 		}
 	}
 
-	rtc = rtc_device_register("r9701",
-				&spi->dev, &r9701_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&spi->dev, "r9701",
+				&r9701_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
@@ -166,9 +166,6 @@ static int r9701_probe(struct spi_device *spi)
 
 static int r9701_remove(struct spi_device *spi)
 {
-	struct rtc_device *rtc = dev_get_drvdata(&spi->dev);
-
-	rtc_device_unregister(rtc);
 	return 0;
 }
 
-- 
1.7.2.5



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab3IWJnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:43:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28939 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab3IWJnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:43:49 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-30-52400d549e98
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
In-reply-to: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
Subject: [PATCH 05/15] rtc: rtc-ds1305: use dev_get_platdata()
Date: Mon, 23 Sep 2013 18:43:46 +0900
Message-id: <002101ceb841$671816a0$354843e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64QJVrtN1IW24fTFCn/tCGU7Py3AAALiEQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zfd0QXocggy23BCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKuPxzAUvBO7aKw33KDYxnWbsYOTkkBEwkXl3cyQhhi0lcuLeerYuRi0NIYBmjxLHz
	T9jhimY1s0MkpjNK9N98zAaSEBL4xShxq80VxGYTUJP48uUwUBEHh4iAvkRbiwZIPbNAL6PE
	md7d7BD1thITp31lArE5Bewk1nxeBmYLA9lLfy4Cs1kEVCXmfp/CBjKHF6h+3ys7kDCvgKDE
	j8n3WEBsZgEtic3bmlghbHmJzWveMoOUSwioSzz6qwsSFhEwkjh2rBGqRERi34t3jCDnSAjc
	Y5f48vE0C8QqAYlvkw+xQPTKSmw6wAzxrqTEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyi
	qQXJBcVJ6UXGesWJucWleel6yfm5mxghUdq/g/HuAetDjMlA6ycyS4km5wOjPK8k3tDYzMjC
	1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjJVn9KfdqKxT9DrA
	+bBMTODrlDmZry/fYot9UD2zeKdCzLypE5UvvrJf/v/38xrhtSJT8if7K/5wzeZ02nfpttzh
	1Y+lWy/Lneud2GZz5+adP0qW1k8/2Hgy5f06Y3fPb5L/lOuSLAkvL/pznnhynd8ppIJtu271
	JH6BJT+FWd3+n+l5/+2o9kklluKMREMt5qLiRACwIjtm6AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQd0QXocggxkPeCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzLj8cwFLwTu2isN9yg2MZ1m7GDk5JARMJF7N
	amaHsMUkLtxbz9bFyMUhJDCdUaL/5mM2kISQwC9GiVttriA2m4CaxJcvh4EaODhEBPQl2lo0
	QOqZBXoZJc707maHqLeVmDjtKxOIzSlgJ7Hm8zIwWxjIXvpzEZjNIqAqMff7FDaQObxA9fte
	2YGEeQUEJX5MvscCYjMLaEls3tbECmHLS2xe85YZpFxCQF3i0V9dkLCIgJHEsWONUCUiEvte
	vGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxglPAM6kd
	jCsbLA4xCnAwKvHwRiTaBwmxJpYVV+YeYpTgYFYS4fVjdQgS4k1JrKxKLcqPLyrNSS0+xJgM
	9OdEZinR5HxgesoriTc0NjEzsjQyszAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6p
	Bka9NfrN79+cERaeVbJ12ynGBYFCbs5S8qV5OxWffvqz5NHsJP9DIsvOaSqqPpkyabLBrtrF
	ekdulLkwZxTKvalPj7Wu1/is8Dz+XIZxXpNV3ye5tYe13NW59gidk3t1vKJpUflclRnqURvV
	zt+Umb4pY/Nk3VlrayL5OtRn+D95rs266s7MM+uVWIozEg21mIuKEwG38ogZRQMAAA==
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
 drivers/rtc/rtc-ds1305.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-ds1305.c b/drivers/rtc/rtc-ds1305.c
index dd6170a..80f3237 100644
--- a/drivers/rtc/rtc-ds1305.c
+++ b/drivers/rtc/rtc-ds1305.c
@@ -606,7 +606,7 @@ static int ds1305_probe(struct spi_device *spi)
 	struct ds1305			*ds1305;
 	int				status;
 	u8				addr, value;
-	struct ds1305_platform_data	*pdata = spi->dev.platform_data;
+	struct ds1305_platform_data	*pdata = dev_get_platdata(&spi->dev);
 	bool				write_ctrl = false;
 
 	/* Sanity check board setup data.  This may be hooked up
-- 
1.7.10.4



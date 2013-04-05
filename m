Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161032Ab3DEBsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:48:03 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41197 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab3DEBsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:48:01 -0400
X-AuditID: cbfee68e-b7f946d000001e37-c7-515e2d4fb14a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000101ce319f$87f2a3f0$97d7ebd0$%han@samsung.com>
In-reply-to: <000101ce319f$87f2a3f0$97d7ebd0$%han@samsung.com>
Subject: [PATCH 2/7] rtc: rtc-m41t94: use spi_set_drvdata()
Date: Fri, 05 Apr 2013 10:47:59 +0900
Message-id: <000201ce319f$9a22dc20$ce689460$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4xn4fH39zvwb7bR32L9HOXANRbigAAAhXA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zA11/3bhAg7YrJhZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRnHZpKTmZJal
	FunbJXBlnFzxmrngFGvF6ZNrWBsYz7B0MXJySAiYSNw8N5kNwhaTuHBvPZDNxSEksIxR4sWf
	DWwwRT2nFzBBJKYzSkw+vxXK+cUo8WxmM9goNgE1iS9fDrN3MXJwiAjoS7S1aIDUMAv0Mkqc
	6d3NDlIjJGArsfpPD1g9p4CdxNd5GxhBbGEBa4kXt36CbWMRUJWY1jaLCcTmBarveLyRDcIW
	lPgx+R5YL7OAlsT6nceZIGx5ic1r3jKD7JUQUJd49FcXJCwiYCTxavF8RogSEYl9L94xgtwj
	IfCIXWJGUxcrxC4BiW+TD7FA9MpKbDrADPGwpMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZV
	jKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGCGx2reD8eYB60OMyUDrJzJLiSbnA2M9ryTe0NjM
	yMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MNpabr+xesPBY
	QOvt3ndqj1Z+9N9oppjY6i29SiT4rtLmusAHE3S3hDO+sVnqdFnq+77899PfVH2Zwvm+tuTI
	isqss4fiyjlnlEia75LivXtds/2SpFjZ3HZ+TR0Bxx1VDfdNOI8b9Ct9C2J8vE398j9lvavt
	L4OWrEsTKGT0Y7d8lH4li2uTEktxRqKhFnNRcSIA/yIvtesCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQV1/3bhAg/uzDCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzDi54jVzwSnWitMn17A2MJ5h6WLk5JAQMJHo
	Ob2ACcIWk7hwbz1bFyMXh5DAdEaJyee3MkE4vxglns1sButgE1CT+PLlMHsXIweHiIC+RFuL
	BkgNs0Avo8SZ3t3sIDVCArYSq//0gNVzCthJfJ23gRHEFhawlnhx6ycbiM0ioCoxrW0W2GZe
	oPqOxxvZIGxBiR+T74H1MgtoSazfeZwJwpaX2LzmLTPIXgkBdYlHf3VBwiICRhKvFs9nhCgR
	kdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZwI
	nknvYFzVYHGIUYCDUYmHN6MvNlCINbGsuDL3EKMEB7OSCO9OvrhAId6UxMqq1KL8+KLSnNTi
	Q4zJQI9OZJYSTc4HJqm8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh
	4uCUamDUuaU38Zejfr/OaQbjzu2z9zNsCTk9PUzptXzRxPUm6oxvWTsNly47xr274UZB0+Xu
	lty6FTp3n0l3bO1ec0B174sVvEd9qwz+XH36olQ87eLmwykv0w8vn+D28khS30WZ9NYqHv8q
	LYWdZ+RrjoY4H+v9t7PZRXlj4yUpw8oiayEfiYdT+CWUWIozEg21mIuKEwHx8YRUSAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-m41t94.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-m41t94.c b/drivers/rtc/rtc-m41t94.c
index cf655a9..7454ef0 100644
--- a/drivers/rtc/rtc-m41t94.c
+++ b/drivers/rtc/rtc-m41t94.c
@@ -129,7 +129,7 @@ static int m41t94_probe(struct spi_device *spi)
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
-	dev_set_drvdata(&spi->dev, rtc);
+	spi_set_drvdata(spi, rtc);
 
 	return 0;
 }
-- 
1.7.2.5



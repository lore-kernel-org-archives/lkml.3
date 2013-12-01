Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab3LAX6I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 18:58:08 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:27978 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab3LAX6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 18:58:04 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-4f-529bcd0bf4fe
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000001ceeef0$d88a7f40$899f7dc0$%han@samsung.com>
In-reply-to: <000001ceeef0$d88a7f40$899f7dc0$%han@samsung.com>
Subject: [PATCH 7/8] backlight: l4f00242t03: use devm_lcd_device_register()
Date: Mon, 02 Dec 2013 08:58:02 +0900
Message-id: <000601ceeef1$2bd15070$8373f150$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7u8NgcVnqPK6OFQjq+Xy+HsAignwAAEk+w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zY13us7ODDLb0qFrMWb+GzeLywkus
	Fpd3zWFzYPY4MeM3i0ffllWMHp83yQUwR3HZpKTmZJalFunbJXBlvLj9i6VgPUfF/OebWRsY
	29i7GDk5JARMJB5v/MQIYYtJXLi3nq2LkYtDSGAZo8StKw1MMEVt/SfYIRLTGSVmnnoP5fxi
	lDi77xsbSBWbgJrEly+HgRIcHCIC+hJtLRogJrOAi8TRaSIgFUICthIbHp0Hm8kpYCcx4eYf
	MFtYwFtiTc9KZhCbRUBVounKYUaQVl6g+sXHE0DCvAKCEj8m32MBsZkFtCTW7zzOBGHLS2xe
	85YZpFxCQF3i0V9dkLCIgJHE7d3/ocpFJPa9eMcIcrCEwDF2ifdPJzBBrBKQ+Db5EAtEr6zE
	pgPMEN9KShxccYNlAqPELCSbZyHZPAvJ5llIVixgZFnFKJpakFxQnJReZKhXnJhbXJqXrpec
	n7uJERJ9vTsYbx+wPsSYDLR+IrOUaHI+MHrzSuINjc2MLExNTI2NzC3NSBNWEudNepgUJCSQ
	nliSmp2aWpBaFF9UmpNafIiRiYNTqoGR99nlZan32z/vbH43Yd9Hu22Pw/y0rkycsOdvz//G
	Y6fS3zM3Xjp+LGtWhaZHqBmzgHSX+BzZ50r6Ii+nK3MfbjTeydRXyhL28d3EJ3ccomOO5YVZ
	frLaNl3R4L32EsnWFTqbNDdc7PFymqgkbfPgxhErHyEXt2UMftsNj9g6L18Suu2a6FF9JZbi
	jERDLeai4kQAQb01uNQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQV3us7ODDH7eULSYs34Nm8XlhZdY
	LS7vmsPmwOxxYsZvFo++LasYPT5vkgtgjmpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw
	1DW0tDBXUshLzE21VXLxCdB1y8wB2qSkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7H
	yAANJKxjzHhx+xdLwXqOivnPN7M2MLaxdzFyckgImEi09Z+AssUkLtxbz9bFyMUhJDCdUWLm
	qffsEM4vRomz+76xgVSxCahJfPlyGCjBwSEioC/R1qIBYjILuEgcnSYCUiEkYCux4dF5JhCb
	U8BOYsLNP2C2sIC3xJqelcwgNouAqkTTlcOMIK28QPWLjyeAhHkFBCV+TL7HAmIzC2hJrN95
	nAnClpfYvOYtM0i5hIC6xKO/uiBhEQEjidu7/0OVi0jse/GOcQKj0Cwkk2YhmTQLyaRZSFoW
	MLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiO7WfSOxhXNVgcYhTgYFTi4b1wYnaQEGti
	WXFl7iFGCQ5mJRFei6+zgoR4UxIrq1KL8uOLSnNSiw8xJgP9OZFZSjQ5H5h28kriDY1NzIws
	jcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBMWXNBL5tadseNybmhtnHCG2c
	dZTtyLbXZXEi4VInvyt2WR/cs8Hm/dUn2448jndcFH3ikRsnX+O33zYvv7sLMMwrmr/PjD2d
	W/AwS01p/mzD02fPt7jMumey5LeK5f5o/c6pu1gfX/imNmnj7M4N6fnJW6+L6bYVBSk+nqJ6
	eJrMHvUPW7bItCqxFGckGmoxFxUnAgC1HpZbMQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_lcd_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/l4f00242t03.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
index b5fc13b..63e7638 100644
--- a/drivers/video/backlight/l4f00242t03.c
+++ b/drivers/video/backlight/l4f00242t03.c
@@ -223,8 +223,8 @@ static int l4f00242t03_probe(struct spi_device *spi)
 		return PTR_ERR(priv->core_reg);
 	}
 
-	priv->ld = lcd_device_register("l4f00242t03",
-					&spi->dev, priv, &l4f_ops);
+	priv->ld = devm_lcd_device_register(&spi->dev, "l4f00242t03", &spi->dev,
+					priv, &l4f_ops);
 	if (IS_ERR(priv->ld))
 		return PTR_ERR(priv->ld);
 
@@ -243,8 +243,6 @@ static int l4f00242t03_remove(struct spi_device *spi)
 	struct l4f00242t03_priv *priv = spi_get_drvdata(spi);
 
 	l4f00242t03_lcd_power_set(priv->ld, FB_BLANK_POWERDOWN);
-	lcd_device_unregister(priv->ld);
-
 	return 0;
 }
 
-- 
1.7.10.4



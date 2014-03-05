Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaCEKnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 05:43:16 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:30710 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaCEKnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 05:43:14 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-db-5316ffbef16c
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com, sbkim73@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH] drivers: mfd: silence compiler warning in sec-core.c
Date: Wed, 05 Mar 2014 19:59:19 +0900
Message-id: <1394017159-4851-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t8zI919/8WCDfqmSVjc/3qU0eLyrjls
	Fou2fmG3ON3NanFxxRcmB1aPO9f2sHnMOxno0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBnv
	9hUX/GCreHJjK2sD4wvWLkZODgkBE4nenw3MELaYxIV769m6GLk4hASWMUp0tJ9hgSnad/YM
	I0RiEaPE0VWnwbqFBNqYJP59NwKx2QR0JZ68nws2SURAQWJz7zOwGmaBfIkLv6YxgtjCAq4S
	h/b9YAexWQRUJR7//sMEYvMKuEusWz4VqJ4DaJmCxJxJNiC7JARes0mcPLGWCaJeQOLb5EMs
	EDWyEpsOQB0tKXFwxQ2WCYyCCxgZVjGKphYkFxQnpReZ6hUn5haX5qXrJefnbmKEBOTEHYz3
	D1gfYkwGGjeRWUo0OR8Y0Hkl8YbGZkYWpiamxkbmlmakCSuJ86Y/SgoSEkhPLEnNTk0tSC2K
	LyrNSS0+xMjEwSnVwBirUydadOGO8865km/XNTW9tPnLOenS42MTZ7L+F3o3fYa/FqvS1C6h
	55Vbzm+eYcGx4J1mmPaHmbJHfreW8Zi8muG7d+o1Ie81ZnPkPVr5PLSXN2RuevM/at3e0zMd
	K9hvWUkU9Untr1z4SCjkWYlAbUrsUV0+y0uW3XLvPfS+/sqa8fnhzB1KLMUZiYZazEXFiQD4
	96Q6XgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsVy+t9jAd19/8WCDY6sFrG4//Uoo8XlXXPY
	LBZt/cJucbqb1eLiii9MDqwed67tYfOYdzLQo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNT
	MvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4DWKimUJeaUAoUCEouLlfTtME0I
	DXHTtYBpjND1DQmC6zEyQAMJ6xgz3u0rLvjBVvHkxlbWBsYXrF2MnBwSAiYS+86eYYSwxSQu
	3FvP1sXIxSEksIhR4uiq02BFQgJtTBL/vhuB2GwCuhJP3s9lBrFFBBQkNvc+A6thFsiXuPBr
	GtggYQFXiUP7frCD2CwCqhKPf/9hArF5Bdwl1i2fClTPAbRMQWLOJJsJjNwLGBlWMYqmFiQX
	FCel5xrpFSfmFpfmpesl5+duYgSH+zPpHYyrGiwOMQpwMCrx8L7gEAsWYk0sK67MPcQowcGs
	JMKb8gIoxJuSWFmVWpQfX1Sak1p8iDEZaPlEZinR5HxgLOaVxBsam5gZWRqZWRiZmJuTJqwk
	znuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+O8Lb5/dxye/ercZaF5rGq1Ed5Ggl8/X9XPVogt
	WG0hYdeht6f57ZFDl0XMyl3a7uzsPVfKImC++GhSwn22OI7iU+cvPa38Y9DQGfwp+r3Xg22P
	dj07rnmyp/9IRnnh7Lrt3f5lrp2GGj+kJs2dufW84nexgP4g77qpx2SecjgqvWlQXrO7Zq8S
	S3FGoqEWc1FxIgADBR8ZuwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When used 64bit compiler GCC warns as
drivers/mfd/sec-core.c:199:10: warning:
cast from pointer to integer of different size [-Wpointer-to-int-cast]

This patch fixes this by type-casting "match->data" into "long" before
converting into "int"

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/mfd/sec-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index a139798..2e7580bd 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -187,7 +187,7 @@ static inline int sec_i2c_get_driver_data(struct i2c_client *i2c,
 	if (i2c->dev.of_node) {
 		const struct of_device_id *match;
 		match = of_match_node(sec_dt_match, i2c->dev.of_node);
-		return (int)match->data;
+		return (int)(long)match->data;
 	}
 #endif
 	return (int)id->driver_data;
-- 
1.7.9.5


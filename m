Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbaI0EWv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 00:22:51 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10635 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbaI0EWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 00:22:50 -0400
X-AuditID: cbfee68e-f79b46d000002b74-b6-54263b98ed96
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, gregkh@linuxfoundation.org, Li.Xiubo@freescale.com,
        naushad@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH] regmap: fix NULL pointer dereference in _regmap_write/read
Date: Sat, 27 Sep 2014 09:47:55 +0530
Message-id: <1411791475-27031-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsWyRsSkRneGtVqIwaYFChZTHz5hs2hevJ7N
	ovNCB6vF5V1z2Cw+Hf3ParFo6xd2BzaPf4f7mTw2repk89g/dw27R9+WVYwenzfJBbBGcdmk
	pOZklqUW6dslcGX0dO1nL+jkrDjRFt3AuJO9i5GTQ0LARGLa0+VMELaYxIV769m6GLk4hASW
	Mkr8ef6IuYuRA6zo5RQJiPh0Ronru6+xQzgTmCSetK5jBelmE9CVePJ+LjOILSKgILG59xlY
	nFmgi1Fi13ZZEFtYwFvi+cYpYDUsAqoSy2++YQNZwCvgIfH7hS/ELgWJOZNsQMZLCHxnk5j+
	ZhJUuYDEt8mHWCBqZCU2HWCGuFlS4uCKGywTGAUXMDKsYhRNLUguKE5KLzLSK07MLS7NS9dL
	zs/dxAgM09P/nvXtYLx5wPoQowAHoxIP7wlxtRAh1sSy4srcQ4ymQBsmMkuJJucDoyGvJN7Q
	2MzIwtTE1NjI3NJMSZw3QepnsJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGcWN7Y+eXvspq
	4YWVxXttNfl1jG6Vv1ij/OvGyU8Mc7ekJySuPHRE/AYbU1HKJQdptrOG8dLd1xxvZvBcZ1ML
	WVxx++mf3SENZ0PlvrSE3wzzuP3hnSa7sJfWkVNW87hP3ApeMWcru9TSn6kX962p+lxlsfP2
	r7krBDR+H3y49UrR39kL7u1kVWIpzkg01GIuKk4EAB09QbhOAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42I5/e+xoO4Ma7UQg1kXxSymPnzCZtG8eD2b
	ReeFDlaLy7vmsFl8Ovqf1WLR1i/sDmwe/w73M3lsWtXJ5rF/7hp2j74tqxg9Pm+SC2CNamC0
	yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6QUmhLDGn
	FCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOY0dO1n72gk7PiRFt0A+NO9i5GDg4J
	AROJl1Mkuhg5gUwxiQv31rN1MXJxCAlMZ5S4vvsaO4QzgUniSes6VpAqNgFdiSfv5zKD2CIC
	ChKbe5+BxZkFuhgldm2XBbGFBbwlnm+cAlbDIqAqsfzmGzaQZbwCHhK/X/hC7FWQmDPJZgIj
	9wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwVHwTHoH46oGi0OMAhyMSjy8J8XVQoRY
	E8uKK3MPMUpwMCuJ8NpwAYV4UxIrq1KL8uOLSnNSiw8xmgLtnsgsJZqcD4zQvJJ4Q2MTc1Nj
	U0sTCxMzSyVx3oOt1oFCAumJJanZqakFqUUwfUwcnFINjKZel0L/r7eNYpgxoXTOLAVNoe3T
	AqbwNi8uPuOpHO82b0Xz0sNLDRc/1zZPv790xb1lbi+6JzpnlMwrVTD8VLGd5Z71sZxlH9W3
	7VB4kPJ0eZGrjq5MIcNkn/2yZ5akVc6rYdAV9WOe3yN6f2Vf+RSva5re17cKVX1uOLuCJ/eY
	+a15/jcXXFBiKc5INNRiLipOBADCSqSKmAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If LOG_DEVICE is defined and map->dev is NULL it will lead to NULL
pointer dereference. This patch fixes this issue by adding check for
dev->NULL in all such places in regmap.c

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/base/regmap/regmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 455a877..9980044 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1465,7 +1465,7 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 	}
 
 #ifdef LOG_DEVICE
-	if (strcmp(dev_name(map->dev), LOG_DEVICE) == 0)
+	if (map->dev && strcmp(dev_name(map->dev), LOG_DEVICE) == 0)
 		dev_info(map->dev, "%x <= %x\n", reg, val);
 #endif
 
@@ -2115,7 +2115,7 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
 	ret = map->reg_read(context, reg, val);
 	if (ret == 0) {
 #ifdef LOG_DEVICE
-		if (strcmp(dev_name(map->dev), LOG_DEVICE) == 0)
+		if (map->dev && strcmp(dev_name(map->dev), LOG_DEVICE) == 0)
 			dev_info(map->dev, "%x => %x\n", reg, *val);
 #endif
 
-- 
1.7.9.5


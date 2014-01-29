Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaA2JZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:25:44 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16582 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaA2JZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:25:35 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-89-52e8c90ec9a0
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, devicetree@vger.kernel.org
Subject: [PATCH 7/9 v5] crypto:s5p-sss: validate iv before memcpy
Date: Wed, 29 Jan 2014 14:55:28 +0530
Message-id: <1390987528-18862-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389243640-13282-1-git-send-email-ch.naveen@samsung.com>
References: <1389243640-13282-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsWyRsSkSpfv5Isgg20nxCxeHtK0mH/kHKtF
	9ysZi/v3fjJZXN41h81ixvl9TBaLtv1ntjg75xCTA4fHzll32T22HVD16NuyitHj8ya5AJYo
	LpuU1JzMstQifbsErox9P+awFtxnq+jetJO9gfEEaxcjJ4eEgInE6QkHoGwxiQv31rN1MXJx
	CAksZZTo39bABFN0YFITK0RiEaPE4eapTBBOP5PEmV1HmEGq2ATMJA4uWs0OYosIOEv8bl4D
	1sEssJBRYtW3v2BFwgKOEpse/gYrYhFQlVh7Yj4biM0r4Cqxad8coKkcQOsUJOZMsgEJcwq4
	SWy9/ASsXAioZM6Jq8wQF81jl1h0yx1ijIDEt8mHWCBaZSU2HYAqkZQ4uOIGywRG4QWMDKsY
	RVMLkguKk9KLDPWKE3OLS/PS9ZLzczcxAgP89L9nvTsYbx+wPsSYDDRuIrOUaHI+MELySuIN
	jc2MLExNTI2NzC3NSBNWEudNepgUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHRYkXNxXeT
	Pe/nfMjSkVv87EfM794NNiFfNl2Ofbz/T+o6jRnCgu/Lzuw+nimwMu7zoonzjnTmBJ15t3Sx
	+6t1z5dJKk9MlKhsOu73jeFOzsUv7i8WfHiZkLzJk1nasM0qpTlxja/Wkzat3ytO7N18s/Gr
	0hHz3BV/ucPVdmmo+rtycJSkmmzRUWIpzkg01GIuKk4EAIThx+WGAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jAV2+ky+CDL6+5rV4eUjTYv6Rc6wW
	3a9kLO7f+8lkcXnXHDaLGef3MVks2vaf2eLsnENMDhweO2fdZffYdkDVo2/LKkaPz5vkAlii
	GhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COUFIo
	S8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm7Psxh7XgPltF96ad7A2MJ1i7
	GDk5JARMJA5MaoKyxSQu3FvP1sXIxSEksIhR4nDzVCYIp59J4syuI8wgVWwCZhIHF61mB7FF
	BJwlfjevYQUpYhZYyCix6ttfsCJhAUeJTQ9/gxWxCKhKrD0xnw3E5hVwldi0bw7QVA6gdQoS
	cybZgIQ5Bdwktl5+AlYuBFQy58RV5gmMvAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525i
	BEfQM+kdjKsaLA4xCnAwKvHwrrj4PEiINbGsuDL3EKMEB7OSCO+JTS+ChHhTEiurUovy44tK
	c1KLDzEmAx01kVlKNDkfGN15JfGGxibmpsamliYWJmaWpAkrifMebLUOFBJITyxJzU5NLUgt
	gtnCxMEp1cDoJhvPce+87fbuGjXOfTtuPzYQ8Nj4zDF4cXH8JdEJbUu7L8aWGMgve2r9vjq5
	J/FQdXcMx+mm7VpMZ4wvrLj7p7wne0364+D0J97rys8ce8uSuPdRFcPLuRu+i5uG+jDuz2Dd
	HvJ97eUVtwqnadVUJbo5mIbsfpsztffCDAcD78sLr/P+jFijxFKckWioxVxUnAgAU4nF0eQC	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code to validate "iv" buffer before trying to
memcpy the contents

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
Changes since v4:
None

Changes since v3:
None

 drivers/crypto/s5p-sss.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index da1c8943..a890273 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -380,7 +380,8 @@ static void s5p_set_aes(struct s5p_aes_dev *dev,
 {
 	void __iomem *keystart;
 
-	memcpy(dev->aes_ioaddr + SSS_REG_AES_IV_DATA (0), iv, 0x10);
+	if (iv)
+		memcpy(dev->aes_ioaddr + SSS_REG_AES_IV_DATA (0), iv, 0x10);
 
 	if (keylen == AES_KEYSIZE_256)
 		keystart = dev->aes_ioaddr + SSS_REG_AES_KEY_DATA(0);
-- 
1.7.9.5


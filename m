Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244Ab3FYFSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 01:18:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61295 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab3FYFSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 01:18:21 -0400
X-AuditID: cbfee68e-b7f276d000002279-bb-51c9281c61d3
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: anton.vorontsov@linaro.org
Cc: linux-kernel@vger.kernel.org, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2] power: charger-manager: regulator_get() never returns NULL.
Date: Tue, 25 Jun 2013 14:18:14 +0900
Message-id: <1372137494-4268-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsWyRsSkQFdG42SgQddKGYuLrbdZLDrPPmG2
	uLxrDpvF7cYVbA4sHneu7WHz6NuyitHj8ya5AOYoLpuU1JzMstQifbsErowLz3axFDzgqOhd
	tZuxgXEeexcjJ4eEgInEr4MdTBC2mMSFe+vZuhi5OIQEljJKnD+zgQWm6P2dNhaIxHRGiSuP
	nkM5LUwSZ+beYQOpYhPQkfi/7ybYWBEBOYnXa/+CjWUWKJb4fG0xK4gtLOAv8fbVbrA4i4Cq
	xKOljWBxXgF3if5Z1xm7GDmAtilIzJlkAzJfQuA+m8Tr1fNZIeoFJL5NPsQCUSMrsekAM8Rx
	khIHV9xgmcAouICRYRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZGYBCe/vesbwfjzQPWhxiT
	gcZNZJYSTc4HBnFeSbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanF
	hxiZODilGhg519/dtcn6yIovk58tjGd5cMFV35RPKe/7/6/LjnXFJZdNvcmmuSDnhodbk/nj
	F0/0TlneSLi66x17/rK2B98CFd+t4bIOk7izSVD8ctWxVJudBwxaVu61iw3/PmWfTd2R+EmR
	Wwz2cvyoDsqQ057Xty0hUr5Vh/N15hWTUt3G1NPmSRlZ/7qVWIozEg21mIuKEwHAEEvCWAIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQV0ZjZOBBo8ni1pcbL3NYtF59gmz
	xeVdc9gsbjeuYHNg8bhzbQ+bR9+WVYwenzfJBTBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7
	x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gCtU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHr
	GxIE12NkgAYS1jBmXHi2i6XgAUdF76rdjA2M89i7GDk5JARMJN7faWOBsMUkLtxbz9bFyMUh
	JDCdUeLKo+csEE4Lk8SZuXfYQKrYBHQk/u+7CdYtIiAn8XrtXyYQm1mgWOLztcWsILawgL/E
	21e7weIsAqoSj5Y2gsV5Bdwl+mddZ+xi5ADapiAxZ5LNBEbuBYwMqxhFUwuSC4qT0nMN9YoT
	c4tL89L1kvNzNzGCQ/yZ1A7GlQ0WhxgFOBiVeHgjd50IFGJNLCuuzD3EKMHBrCTCGyoCFOJN
	SaysSi3Kjy8qzUktPsSYDLR8IrOUaHI+MP7ySuINjU3MjCyNzA0tjIzNSRNWEuc90GodKCSQ
	nliSmp2aWpBaBLOFiYNTqoFx4Yl+Ud7/n7pa+/5JqXDvXirO9bli7/kX/z5OXzSJ6YB/R6xV
	e+WUyt+97w8LnmBPztbbd+3/T98qjlm3Ff8HzxS7PfOgxcoFlVfqmA96/r5030J0+7s7X9VZ
	5PT8BOv2LY9Y55fMVz7ZkeOdfaCINvOOIpWvJ/s7hRgzlmsmrW/d9f3IAVNnJZbijERDLeai
	4kQAFVea1bUCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes return value checking of regulator_get() in charger-manager
driver. The API, regulator_get(), returns ERR_PTR() when it fails to get
regulator with given name, not NULL.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
v2:
 - Fix return value to use API's directly with PTR_ERR().

 drivers/power/charger-manager.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index ba42029..0a4cce3 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -1239,11 +1239,10 @@ static int charger_manager_register_extcon(struct charger_manager *cm)
 
 		charger->consumer = regulator_get(cm->dev,
 					charger->regulator_name);
-		if (charger->consumer == NULL) {
+		if (IS_ERR(charger->consumer)) {
 			dev_err(cm->dev, "Cannot find charger(%s)\n",
 				charger->regulator_name);
-			ret = -EINVAL;
-			goto err;
+			return PTR_ERR(charger->consumer);
 		}
 		charger->cm = cm;
 
-- 
1.7.9.5


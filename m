Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594Ab3FNCLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:11:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22988 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759418Ab3FNCLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:11:47 -0400
X-AuditID: cbfee68f-b7f436d000000f81-53-51ba7bddd875
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH] extcon: class: Add NULL pointer checking for removing notifier
 block.
Date: Fri, 14 Jun 2013 11:11:37 +0900
Message-id: <1371175897-3001-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsWyRsSkQPdu9a5Agx8bJSyuf3nOatF59gmz
	xeVdc9gsPvceYbS43biCzYHVo2/LKkaPz5vkApiiuGxSUnMyy1KL9O0SuDJ2fXvIVLCDrWLr
	o49MDYwHWbsYOTkkBEwkNi/4xQZhi0lcuLceyObiEBJYyijxq38BcxcjB1hR70JliPh0RomZ
	X5vZIZwWJonGVfuZQLrZBHQk/u+7yQ5iiwjISEy9sp8VpIhZYCajxOuzt8HWCQtESNw5t5EF
	xGYRUJV4cmgLWDOvgLvEitVLoLYpSMyZZANx0WM2iYVP1SHKBSS+TT7EAlEiK7HpADNEiaTE
	wRU3WCYwCi5gZFjFKJpakFxQnJReZKxXnJhbXJqXrpecn7uJERiCp/8969/BePeA9SHGZKBx
	E5mlRJPzgSGcVxJvaGxmZGFqYmpsZG5pRpqwkjivWot1oJBAemJJanZqakFqUXxRaU5q8SFG
	Jg5OqQbGY0ECR987y/M0s3jZB/rbK26uTZygYzH9nWLatv8eD3eVfGZobp+fclPuzvVpl70W
	au9O4uA31/GukW17c1pizYPVE+O2PeBYoqfk8rbVt+C/2Zw9gbOnn+VddOitWpnmPMkN1Udu
	uLZKb3wx60nLZ7eEqLyOjtrLbz7/FNv2RXCev6+9rcsyJZbijERDLeai4kQAXmlIzVcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQd271bsCDZauFbK4/uU5q0Xn2SfM
	Fpd3zWGz+Nx7hNHiduMKNgdWj74tqxg9Pm+SC2CKamC0yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFap6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGHM2PXtIVPBDraKrY8+MjUwHmTtYuTgkBAwkehdqNzFyAlkiklcuLeerYuR
	i0NIYDqjxMyvzewQTguTROOq/UwgVWwCOhL/991kB7FFBGQkpl7ZzwpSxCwwk1Hi9dnbrCAJ
	YYEIiTvnNrKA2CwCqhJPDm0Ba+YVcJdYsXoJM8RmBYk5k2wmMHIvYGRYxSiaWpBcUJyUnmuk
	V5yYW1yal66XnJ+7iREc4s+kdzCuarA4xCjAwajEw5twYWegEGtiWXFl7iFGCQ5mJRHe8L9A
	Id6UxMqq1KL8+KLSnNTiQ4zJQMsnMkuJJucD4y+vJN7Q2MTMyNLI3NDCyNicNGElcd6DrdaB
	QgLpiSWp2ampBalFMFuYODilGhjNi6YGTN67jv9me4ge7+zvL6tD52W9kuERembeWtxzOfot
	T+tWh8UPj6prbF6V1/fsK1N+/urTd7hb/3N/7bkU22AnEtww1+yd6ZLTsl03mkrePGx5ukGk
	9k3bxQNdp4R7db6qTS2MP87zj/UUT6DZw8cSMkIshn496c6ejtN2zbwn2/F6bYISS3FGoqEW
	c1FxIgD5OJsvtQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds NULL pointer checking of extcon device to 'extcon_unregister
_interest' which unregisters extcon notifier block.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/extcon-class.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 8c69803..23f11ea 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -491,7 +491,7 @@ EXPORT_SYMBOL_GPL(extcon_register_interest);
  */
 int extcon_unregister_interest(struct extcon_specific_cable_nb *obj)
 {
-	if (!obj)
+	if (!obj || !obj->edev)
 		return -EINVAL;
 
 	return raw_notifier_chain_unregister(&obj->edev->nh, &obj->internal_nb);
-- 
1.7.9.5


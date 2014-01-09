Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaAIFA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 00:00:29 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:49634 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaAIFAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 00:00:25 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-9c-52ce2ce74857
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com
Subject: [PATCH 6/6 v2] crypto:s5p-sss: validate iv before memcpy
Date: Thu, 09 Jan 2014 10:30:40 +0530
Message-id: <1389243640-13282-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWyRsSkWve5zrkgg3NXDS1eHtK06H4lY3H/
	3k8mi8u75rBZzDi/j8li0bb/zBardv1htDg75xCTA4fHzll32T22HVD16NuyitHj8ya5AJYo
	LpuU1JzMstQifbsErozV584xFVxgq9h0fTNjA+NW1i5GTg4JAROJj0/7mCFsMYkL99azdTFy
	cQgJLGWU2LD1Egtc0aJfTBCJRYwS+xbfYYVw+pkkOub8YQOpYhMwkzi4aDU7iC0i4Czxu3kN
	WBGzwBxGiYdL2sFGCQs4Stydtp4RxGYRUJX4t/MCWDOvgKtEd8tqoDs4gNYpSMyZZAPSKyHQ
	zC6x4t0zVoh6AYlvkw+xQNTISmw6AHW2pMTBFTdYJjAKLmBkWMUomlqQXFCclF5kqlecmFtc
	mpeul5yfu4kRGLKn/z2buIPx/gHrQ4zJQOMmMkuJJucDQz6vJN7Q2MzIwtTE1NjI3NKMNGEl
	cd70R0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhiX6J8+26R6bEqI34+rCxMllh54f38n
	68xlB8qKz996fS6xdaZc+P7H87Zpno8RuBy/e/aRT5IKHcIcjAfuBe1ct5Vrko+Jxpb3khFf
	8tOWX+T2nn/Irm+pjdGXFVa/+26feKXXu9FKLSlP6EeLTeTlag1RrjJnqe0v+Neeuh7wL1XN
	2o3z3GsWJZbijERDLeai4kQAv31AI28CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jAd3nOueCDP5O07R4eUjTovuVjMX9
	ez+ZLC7vmsNmMeP8PiaLRdv+M1us2vWH0eLsnENMDhweO2fdZffYdkDVo2/LKkaPz5vkAlii
	GhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COUFIo
	S8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmrD53jqngAlvFpuubGRsYt7J2
	MXJySAiYSHxc9IsJwhaTuHBvPVsXIxeHkMAiRol9i++wQjj9TBIdc/6wgVSxCZhJHFy0mh3E
	FhFwlvjdvAasiFlgDqPEwyXtLCAJYQFHibvT1jOC2CwCqhL/dl4Aa+YVcJXoblnN3MXIAbRO
	QWLOJJsJjNwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRHxDPpHYyrGiwOMQpwMCrx
	8K4oPhskxJpYVlyZe4hRgoNZSYT3r+q5ICHelMTKqtSi/Pii0pzU4kOMyUDLJzJLiSbnA6M1
	ryTe0NjE3NTY1NLEwsTMkjRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoY1ZqUuAKbPoqI
	G026X7Ys+cQ6+f3xhfqPHdfbTtnHySKZ4Pzy//xze45yF/5cJbT2jEiV46LWiKehFw4e9/xQ
	/LzyUDnzTgtTOV2huSx+L2feyv7+Slr0Aj9T9zOH2VNYJa09njzbasP8qPn4teTLf57eC+kw
	izh2Tt47cu/r7Gknu9l3ff10V4mlOCPRUIu5qDgRAPLOaRrMAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code to validate "iv" buffer before trying to
memcpy the contents

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes since v1:
None

 drivers/crypto/s5p-sss.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 7c31a5f..220f123 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -398,8 +398,9 @@ static void s5p_set_aes(struct s5p_aes_dev *dev,
 	struct samsung_aes_varient *var = dev->varient;
 	void __iomem *keystart;
 
-	memcpy(dev->ioaddr + SSS_REG_AES_IV_DATA
-				(var->aes_offset, 0), iv, 0x10);
+	if (iv)
+		memcpy(dev->ioaddr + SSS_REG_AES_IV_DATA
+					(var->aes_offset, 0), iv, 0x10);
 
 	if (keylen == AES_KEYSIZE_256)
 		keystart = dev->ioaddr +
-- 
1.7.9.5


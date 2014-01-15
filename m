Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaAOJRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 04:17:18 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:21424 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaAOJRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:17:15 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-c4-52d6521922f0
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com
Subject: [PATCH 7/8 v4] crypto:s5p-sss: validate iv before memcpy
Date: Wed, 15 Jan 2014 14:47:27 +0530
Message-id: <1389777447-15225-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389243640-13282-1-git-send-email-ch.naveen@samsung.com>
References: <1389243640-13282-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWyRsSkTlcy6FqQQdccFYuXhzQtul/JWNy/
	95PJ4vKuOWwWM87vY7JYtO0/s8WqXX8YLc7OOcTkwOGxc9Zddo9tB1Q9+rasYvT4vEkugCWK
	yyYlNSezLLVI3y6BK6Pp2nWmgilsFZ933GFpYOxi7WLk5JAQMJHYs+AkG4QtJnHh3nogm4tD
	SGApo8T6MzeAijjAip6skYSIL2KUWPrrPlRRP5PE80PvwLrZBMwkDi5azQ5iiwg4S/xuXsMK
	UsQsMIdR4uGSdhaQhLCAo8TeU4/BVrMIqEqsOP2BCcTmFXCVuHV6GzPENgWJOZNsQMKcAm4S
	Wy8/AZspBFQy58RVZohL57FLfPmWADFGQOLb5EMsEK2yEpsOQJVIShxccYNlAqPwAkaGVYyi
	qQXJBcVJ6UWmesWJucWleel6yfm5mxiB4X3637OJOxjvH7A+xJgMNG4is5Rocj4wPvJK4g2N
	zYwsTE1MjY3MLc1IE1YS501/lBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgbH20KTwhtK4
	Es85PNd+S+z4nO60Ln1buFr3A6O7nhn7Vz76/Vm8/1fyB7F7Suk54RFS3gLnPmhuZkqZcW7/
	Q8lUs/jdMQyZugmTjTMs0zauSeK1Wu6WqvLi6u57SaHXDFZ53HbqV2b/uVPkdbfJNO4r238G
	tm/Tz7A+ciuHbYucrrb2Yf20FiWW4oxEQy3mouJEAPhOuWWFAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t9jAV3JoGtBBvenyFi8PKRp0f1KxuL+
	vZ9MFpd3zWGzmHF+H5PFom3/mS1W7frDaHF2ziEmBw6PnbPusntsO6Dq0bdlFaPH501yASxR
	DYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBHKCmU
	JeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzmq5dZyqYwlbxeccdlgbGLtYu
	Rg4OCQETiSdrJLsYOYFMMYkL99azdTFycQgJLGKUWPrrPpTTzyTx/NA7NpAqNgEziYOLVrOD
	2CICzhK/m9ewghQxC8xhlHi4pJ0FJCEs4Cix99RjVhCbRUBVYsXpD0wgNq+Aq8St09uYITYr
	SMyZZAMS5hRwk9h6+QnYTCGgkjknrjJPYORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93
	EyM4fp5J7WBc2WBxiFGAg1GJh/dH+NUgIdbEsuLK3EOMEhzMSiK8Uj7XgoR4UxIrq1KL8uOL
	SnNSiw8xJgMdNZFZSjQ5HxjbeSXxhsYm5qbGppYmFiZmlqQJK4nzHmi1DhQSSE8sSc1OTS1I
	LYLZwsTBKdXAOMFb9bTc74tLdJQqZ77NMf3+y2QJz+t82+WnTzB6/TrFwlRfwmqUYW/u8iYi
	kDd76kM3CYZXCaYnztXd5d6SWXy3zCIoSCBvGSvTvxlN+s5XWR+vfGqowpFzYPb8V/IfFzml
	uW479HfzoX+O7HYh+6z8F3PsUfjnd7/j/F0OnfgpsrY5BR+blViKMxINtZiLihMBvcSYNuMC	AAA=
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
Changes since v3:
None

 drivers/crypto/s5p-sss.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 69130b2..f7c66c7 100644
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


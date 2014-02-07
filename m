Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaBGFZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 00:25:47 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:24373 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaBGFZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 00:25:45 -0500
X-AuditID: cbfee68e-b7f566d000002344-b1-52f46e58eff0
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com
Subject: [PATCH 7/9 v6] crypto:s5p-sss: validate iv before memcpy
Date: Fri, 07 Feb 2014 10:55:27 +0530
Message-id: <1391750727-27496-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389243640-13282-1-git-send-email-ch.naveen@samsung.com>
References: <1389243640-13282-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsWyRsSkTjci70uQwawGfouXhzQtul/JWNy/
	95PJ4vKuOWwWM87vY7JYtO0/s8XZOYeYHNg9ds66y+6x7YCqR9+WVYwenzfJBbBEcdmkpOZk
	lqUW6dslcGW8f9vMXHCErWL7xL2sDYxbWbsYOTkkBEwkLm1bzAxhi0lcuLeerYuRi0NIYCmj
	xMd7N9hhip6/n8UCkZjOKLF96Seoqn4miQ8fX4NVsQmYSRxctBrMFhFwlvjdvAZsBbNAM6PE
	j9lgtrCAo8T5exvBalgEVCX2Pz4PZvMKuEocfNIHVMMBtE1BYs4kG5Awp4CbxNbLT8BKhIBK
	5py4ygyyV0Kgm11i1+nHLBBzBCS+TT7EAtErK7HpANQ3khIHV9xgmcAovICRYRWjaGpBckFx
	UnqRkV5xYm5xaV66XnJ+7iZGYFif/vesbwfjzQPWhxiTgcZNZJYSTc4HxkVeSbyhsZmRhamJ
	qbGRuaUZacJK4ryLHiYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamCcMffUhV0RZ7Jyl0bf
	Up02zUDs7WT5J2JCAl6P3aP9PqQaq09yuiVwV039UJPstucHs7Z83vZbMirL51coT1HUFjZv
	7Y9TLzmmijtFdD986cH9cdGOJWWiluu8vhZ3BGi/jZS6cz3D9mnOhBPz5mcv4RW672fvVKdg
	f2if+mlZ0STdP1652eeUWIozEg21mIuKEwHprMKxgQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t9jQd2IvC9BBr+3slm8PKRp0f1KxuL+
	vZ9MFpd3zWGzmHF+H5PFom3/mS3OzjnE5MDusXPWXXaPbQdUPfq2rGL0+LxJLoAlqoHRJiM1
	MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdov5JCWWJOKVAo
	ILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx4/3bZuaCI2wV2yfuZW1g3MraxcjJISFg
	IvH8/SwWCFtM4sK99WxdjFwcQgLTGSW2L/0E5fQzSXz4+JodpIpNwEzi4KLVYLaIgLPE7+Y1
	YJOYBZoZJX7MBrOFBRwlzt/bCFbDIqAqsf/xeTCbV8BV4uCTPqAaDqBtChJzJtmAhDkF3CS2
	Xn4CViIEVDLnxFXmCYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIER80zqR2MKxss
	DjEKcDAq8fCeWPo5SIg1say4MvcQowQHs5IIL3fClyAh3pTEyqrUovz4otKc1OJDjMlAR01k
	lhJNzgdGdF5JvKGxibmpsamliYWJmSVpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MM5j
	kFzZ8nrq0iUTQ/sEyg8r/OK/L+kWJSs7UTrt96eQKVO0nr7aptl1/NQfXzcOmXn5lzQM716d
	IO4bY/fTQ6rtZ1D3lwZG6XOZs11b7Ws/57tr2YZJ6zdqHQlecTj77lUuO9OuAjYRFzdNl4ft
	rk9vGy+1Y16v+VineEK47kH5zT+/K074osRSnJFoqMVcVJwIAJLXldLeAgAA
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
changes since v5:
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


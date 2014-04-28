Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbaD1Ksp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:48:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64391 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183AbaD1KrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:47:09 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-92-535e31a9b2e4
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, t.figa@samsung.com, davem@davemloft.net
Subject: [PATCH 5/7 v8] crypto:s5p-sss: validate iv before memcpy
Date: Mon, 28 Apr 2014 16:14:57 +0530
Message-id: <1398681899-20782-6-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398681899-20782-1-git-send-email-ch.naveen@samsung.com>
References: <1398681899-20782-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkWnelYVywwY+V3BYvD2lazDnfwmLR
	/UrG4v69n0wWl3fNYbOYcX4fk8Wibf+ZLdbPeM1icXbOISYHTo8tK28yeeycdZfdY9sBVY++
	LasYPT5vkgtgjeKySUnNySxLLdK3S+DK6JmzmKngPEfFiT9PmRoYF7F3MXJySAiYSFze0csE
	YYtJXLi3nq2LkYtDSGApo8TsO1eZYIo2NF5ihEhMZ5Q4emABM0hCSKCfSeLaYi8Qm03ATOLg
	otVgU0UEnCV+N69hBWlgFljHKPHpzWGwScICjhK9fd9ZQGwWAVWJR5PngcV5BVwlNtz/CmRz
	AG1TkJgzyQYkzCngJnF1/TlGiF2uEkt7fzCDzJQQWMcu8W1vC9QcAYlvkw+xQPTKSmw6wAxx
	tKTEwRU3WCYwCi9gZFjFKJpakFxQnJReZKRXnJhbXJqXrpecn7uJERj0p/8969vBePOA9SHG
	ZKBxE5mlRJPzgVGTVxJvaGxmZGFqYmpsZG5pRpqwkjjvoodJQUIC6YklqdmpqQWpRfFFpTmp
	xYcYmTg4pRoY5yrJhx+8diNA/IG8h8Nbtt6HLq49wUf/z2B77GKz+3zK7VnuK91MKrccLyx3
	naX26+3EVHnVWVn8bLX/j+W2P/FMjFa4IlJ4Vim/1C1h+yZTt5OHehrTBbgfR89nqNrnOCFA
	zzaLo3HulYePrbL9f+r8DBTsvmRy+XTB/pAF82ZfOllXE8SpxFKckWioxVxUnAgAkHCaZ5AC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jQd2VhnHBBv+/sli8PKRpMed8C4tF
	9ysZi/v3fjJZXN41h81ixvl9TBaLtv1ntlg/4zWLxdk5h5gcOD22rLzJ5LFz1l12j20HVD36
	tqxi9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnF
	J0DXLTMH6BwlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY0bPnMVMBec5
	Kk78ecrUwLiIvYuRk0NCwERiQ+MlRghbTOLCvfVsXYxcHEIC0xkljh5YwAySEBLoZ5K4ttgL
	xGYTMJM4uGg1WLOIgLPE7+Y1rCANzALrGCU+vTnMBJIQFnCU6O37zgJiswioSjyaPA8szivg
	KrHh/lcgmwNom4LEnEk2IGFOATeJq+vPMULscpVY2vuDeQIj7wJGhlWMoqkFyQXFSem5hnrF
	ibnFpXnpesn5uZsYwTH1TGoH48oGi0OMAhyMSjy8EXNig4VYE8uKK3MPMUpwMCuJ8O6XiAsW
	4k1JrKxKLcqPLyrNSS0+xJgMdNREZinR5HxgvOeVxBsam5ibGptamliYmFmSJqwkznug1TpQ
	SCA9sSQ1OzW1ILUIZgsTB6dUA2P2rcvlx1QvZa4RV+w4xvnnJseqfwqF3HYBSTKfZ8tU+B1x
	XbeFxXfFYSXJ01lK2ybs27t0a23Ih2PvvQPPXfygo/33XfeJslNG608Iih2ecODQrfwJLdHl
	x+3MbV2j72SqrLm18d6K2q54Ft6kc91muhEbqzUkjJNOlT9ckz8hWilh30e2t/JKLMUZiYZa
	zEXFiQCaVkuZ7QIAAA==
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
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
Changes since v7:
Added Acked-by from Herbert Xu
Changes since v6:
None

 drivers/crypto/s5p-sss.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 37e0598..0ffc042 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -380,7 +380,8 @@ static void s5p_set_aes(struct s5p_aes_dev *dev,
 {
 	void __iomem *keystart;
 
-	memcpy(dev->aes_ioaddr + SSS_REG_AES_IV_DATA(0), iv, 0x10);
+	if (iv)
+		memcpy(dev->aes_ioaddr + SSS_REG_AES_IV_DATA(0), iv, 0x10);
 
 	if (keylen == AES_KEYSIZE_256)
 		keystart = dev->aes_ioaddr + SSS_REG_AES_KEY_DATA(0);
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966230Ab3DRHkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 03:40:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26203 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965993Ab3DRHkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 03:40:19 -0400
X-AuditID: cbfee68d-b7f786d000005188-b4-516fa3619634
Date: Thu, 18 Apr 2013 07:40:17 +0000 (GMT)
From: =?euc-kr?B?vNvAurrA?= <eunb.song@samsung.com>
Subject: [PATCH] I2C: Fix i2c fail problem when a process is terminated by a
 signal on octeon in 3.8
To: "wsa@the-dreams.de" <wsa@the-dreams.de>, linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130418073423458@eunb.song
Msgkey: 20130418073423458@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130418073423458@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <11412343.361631366270816380.JavaMail.weblogic@epv6ml12>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+Zrm7i4vxAg/cXlCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGtY3RBe/4Kg7uvM7SwLiDr4uRk0NIQEWi5f93xi5GDg4JAROJ
	bTs1QcISAmISF+6tZ+ti5AIqWcYo0TirmRmmpussD0R8PqPE2eYVTCANLAKqEr9bVzGD2GxA
	NRt+TGAHsYUFUiR2rt/PCmKLCPhK7JozA6yeGaj+fstGZogb5CUmn74MVs8rIChxcuYTFogj
	lCQa/t9ihYgrS/RsXM0IEZeQmDX9AiuEzSsxo/0pVL2cxLSva5ghbGmJ87M2MMI8s/j7Y6g4
	v8Sx2zuYIH7hlXhyPxhmzO7NX9ggbAGJqWcOQrWqS9y/28YEYfNJrFn4lgVmzK5Ty5lheu9v
	mQv1lqLElO6H7BC2lsSXH/vY0L3FK+Aicf7cWsYJjMqzkKRmIWmfhaQdWc0CRpZVjKKpBckF
	xUnpRYZ6xYm5xaV56XrJ+bmbGCEpoXcH4+0D1ocYk4FRMpFZSjQ5H5hS8kriDY3NjCxMTUyN
	jcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAKNHqP+dG5b2f2bLlQdGC
	+Q7F6Yxry6QalphLlWdfMdwe6fh/+d2wn5kzdO3vcfBIXlmXlCr+1vX7V/30+kMXL4b7r3u5
	/pajzrTsvUeXNMjuK5I4UlI/fQFfi1BmoI7P7hTnqzqlilWSNQsLmCKyMltrN+esublEZEG9
	xqe8116NZ/ffPRupxFKckWioxVxUnAgAevXrxx8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2DN3ExfmBBh+/y1tc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jGsbowve8VUc3HmdpYFxB18XIyeHkICKRMv/74xdjBwcEgImEl1neUDCEgJiEhfurWfrYuQC
	KpnPKHG2eQUTSIJFQFXid+sqZhCbDah+w48J7CC2sECKxM71+1lBbBEBX4ldc2aA1TMD1d9v
	2cgMsUteYvLpy2D1vAKCEidnPmGBWKYk0fD/FitEXFmiZ+NqRoi4hMSs6RdYIWxeiRntT6Hq
	5SSmfV3DDGFLS5yftYER5ujF3x9Dxfkljt3ewQTxF6/Ek/vBMGN2b/7CBmELSEw9cxCqVV3i
	/t02JgibT2LNwrcsMGN2nVrODNN7f8tcqLcUJaZ0P2SHsLUkvvzYx4buLV4BF4nz59YyTmCU
	m4UkNQtJ+ywk7chqFjCyrGIUTS1ILihOSq8w0StOzC0uzUvXS87P3cQITk/PluxgbLhgfYhR
	gINRiYf3waq8QCHWxLLiytxDjBIczEoivI9k8wOFeFMSK6tSi/Lji0pzUosPMSYDI3Ais5Ro
	cj4wdeaVxBsaGxgbGlqaG5gaGlmQJqwkzvus1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6Os559p
	mXN32ISvde6JtSw7FdN791aAmLfqrc0xSza4BAee+bpqeplhHgfzpfNL8phq1LJWGO5JKi2Z
	KNr/TE2i+yCPuWuE2ZtEveZzbwy2PJHeHhCiNrt/evy/AzlXQwLnpvV59j56sSEg5nSUyeeA
	Oatu7M9lPruPz/bdG19LjeNOVyTDfJRYijMSDbWYi4oTARwwHLWTAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3I7eR6h014496


I rewrite my patch because the patch before i sent have many white space.
Thanks!
---
I've been debugging the abnormal operation of i2c on octeon.
If a process is terminated by signal in the middle of i2c operation,
next i2c read operation which is done by another process was failed.
So i changed to ignore signal in the middle of i2c operation.
After that the problem was not reproduced.

Signed-off-by: Eunbong Song <eunb.song@samsung.com>
---
 drivers/i2c/busses/i2c-octeon.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-octeon.c b/drivers/i2c/busses/i2c-octeon.c
index 935585e..b2e3259 100644
--- a/drivers/i2c/busses/i2c-octeon.c
+++ b/drivers/i2c/busses/i2c-octeon.c
@@ -183,7 +183,7 @@ static irqreturn_t octeon_i2c_isr(int irq, void *dev_id)
 	struct octeon_i2c *i2c = dev_id;
 
 	octeon_i2c_int_disable(i2c);
-	wake_up_interruptible(&i2c->queue);
+	wake_up(&i2c->queue);
 
 	return IRQ_HANDLED;
 }
@@ -206,9 +206,9 @@ static int octeon_i2c_wait(struct octeon_i2c *i2c)
 
 	octeon_i2c_int_enable(i2c);
 
-	result = wait_event_interruptible_timeout(i2c->queue,
-						  octeon_i2c_test_iflg(i2c),
-						  i2c->adap.timeout);
+	result = wait_event_timeout(i2c->queue,
+					octeon_i2c_test_iflg(i2c),
+					i2c->adap.timeout);
 
 	octeon_i2c_int_disable(i2c);
 
-- 
1.7.0.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•

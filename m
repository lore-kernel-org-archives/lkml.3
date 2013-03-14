Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab3CNIP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:15:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42890 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3CNIPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:15:54 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-a3-51418730ecbb
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 13/30] rtc: rtc-m41t93: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:15:44 +0900
Message-id: <009001ce208c$20183250$604896f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAALcaw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t8zQ12DdsdAg21tphaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj+c8JbAU/2SvW3dzM2MB4jK2LkZNDQsBEYvXFxYwQtpjEhXvr
	weJCAssYJeYtCYSp+XX9AiNEfBGjxJQbvBD2bCaJa+eMQGw2ATWJL18Os3cxcnCICOhLtLVo
	dDFycTAL9DJKnOndDRYXErCVuP7fDsTkFLCT2LBeDKRTWMBN4s7/XiYQm0VAVeL3ge/MICW8
	QNUHZxuAhHkFBCV+TL7HAmIzC2hJrN95nAnClpfYvOYtWLmEgLrEo7+6IGERASOJG/smMkOU
	iEjse/EO6r9l7BKn7kVDbBKQ+Db5EAtEq6zEpgPMECWSEgdX3GCZwCgxC8niWUgWz0KyeBaS
	DQsYWVYxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525ihETTxB2M9w9YH2JMBlo/kVlKNDkfGI15
	JfGGxmZGFqYmpsZG5pZmpAkrifOqt1gHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamA07og0
	Px5aIVt4MbB0ifHOpDR7v5tXuEVmMf/8d13pyZffKrZCTPJpz0oFr6TczbPPypy38NaFuVtO
	n6z6084rtdVnoo5n5zVzv/k33h1ff/mL1YWVjWkLb4ubWevmOfCnJJV9ZgpvZ+cPfm3+VMIg
	c4XZlO4Lu5yENt+63ygsdn5SmdDht2VKLMUZiYZazEXFiQCo+N8svAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xgK5Bu2OgwbY/+haXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4/nPCWwFP9kr1t3czNjA
	eIyti5GTQ0LAROLX9QuMELaYxIV768HiQgKLGCWm3OCFsGczSVw7ZwRiswmoSXz5cpi9i5GD
	Q0RAX6KtRaOLkYuDWaCXUeJM726wuJCArcT1/3YgJqeAncSG9WIgncICbhJ3/vcygdgsAqoS
	vw98ZwYp4QWqPjjbACTMKyAo8WPyPRYQm1lAS2L9zuNMELa8xOY1b8HKJQTUJR791QUJiwgY
	SdzYN5EZokREYt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66
	XnJ+7iZGcLw+k9rBuLLB4hCjAAejEg/vgX6HQCHWxLLiytxDjBIczEoivJ5ejoFCvCmJlVWp
	RfnxRaU5qcWHGJOB/pzILCWanA9MJXkl8YbGJmZGlkZmFkYm5uakCSuJ8x5otQ4UEkhPLEnN
	Tk0tSC2C2cLEwSnVwLh5zmPnaSnL5OrSz50Vf3jER1ZfJGTnvs+nfsz3dOF+9lgsrmqB5Y1z
	L9bEmn87tVaWhatdNlTYdY6aicHbFY1V3/+/FQmq5YitPLNF+921BdL1tz133epet/LTgWC1
	zfbpNj3zp7w99utT6RZ/713X8xVPRH66pHz98qY7p8LLctQfSznlfL+rxFKckWioxVxUnAgA
	or9l8RsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-m41t93.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/rtc/rtc-m41t93.c b/drivers/rtc/rtc-m41t93.c
index 4916968..cfc21a1 100644
--- a/drivers/rtc/rtc-m41t93.c
+++ b/drivers/rtc/rtc-m41t93.c
@@ -184,8 +184,8 @@ static int m41t93_probe(struct spi_device *spi)
 		return -ENODEV;
 	}
 
-	rtc = rtc_device_register(m41t93_driver.driver.name,
-		&spi->dev, &m41t93_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&spi->dev, m41t93_driver.driver.name,
+					&m41t93_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
@@ -197,11 +197,6 @@ static int m41t93_probe(struct spi_device *spi)
 
 static int m41t93_remove(struct spi_device *spi)
 {
-	struct rtc_device *rtc = spi_get_drvdata(spi);
-
-	if (rtc)
-		rtc_device_unregister(rtc);
-
 	return 0;
 }
 
-- 
1.7.2.5



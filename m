Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161200Ab3BOGpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:45:44 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:33179 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161111Ab3BOGpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:45:42 -0500
X-AuditID: cbfee68f-b7f656d000000d78-26-511dd989460f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001e01ce0b47$8edd1480$ac973d80$%han@samsung.com>
In-reply-to: <001e01ce0b47$8edd1480$ac973d80$%han@samsung.com>
Subject: [PATCH V2 05/11] rtc: rtc-rs5c372: use dev_dbg()/dev_warn() instead of
 printk()/pr_debug()
Date: Fri, 15 Feb 2013 15:45:29 +0900
Message-id: <002301ce0b48$0b589a70$2209cf50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LR47AXgjtu6e1Qmq7gnKtv11nagAAGeOQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zA93Om7KBBnOPm1hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MR8cvMhdsEKjY9ngfSwPjGt4uRk4OCQETiWm/z7BC2GISF+6t
	Z+ti5OIQEljGKPHxz14mmKKzF/4wQSQWMUr0LrvMCuHMZpLo7VvPCFLFJqAm8eXLYfYuRg4O
	EQF9ibYWDZAaZoFeRokzvbvB4kICthJTbzuDmJwCdhLvp5uCdAoLpEp8e/+bHcRmEVCVOLN9
	LjOIzQtUPXnGazYIW1Dix+R7LCA2s4CWxOZtTawQtrzE5jVvmUFGSgioSzz6qwsSFhEwkngy
	cQ5UiYjEvhfvGEGukRBYxi7x6/wfFohdAhLfJh9igeiVldh0gBniXUmJgytusExglJiFZPMs
	JJtnIdk8C8mKBYwsqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNzNzFC4qp/B+PdA9aHGJOB1k9k
	lhJNzgfGZV5JvKGxsYmZiamJuaWpuSlpwkrivPKXZAKFBNITS1KzU1MLUovii0pzUosPMTJx
	cEo1MO7mzBY8IWjlGP/k8qPqSwbbUo+Zxdy8aOKfVDN7/uqVDoa3k966NXFdkFwfvdmvOKTy
	1m7p7jSBxg13s/fHCHodzb++Z+vjjRrbzWfbnVJytRUpd0y7v2vpVvOC+6IrP8bnLIlNiK/s
	9ztStXzXM/OsyNuTWCZGzjFK17mzaf+bF0rTLd9dilFiKc5INNRiLipOBADui+5twQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgG7nTdlAg66HehaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x49Hxi8wFGwQqtj3ex9LA
	uIa3i5GTQ0LAROLshT9MELaYxIV769m6GLk4hAQWMUr0LrvMCuHMZpLo7VvPCFLFJqAm8eXL
	YfYuRg4OEQF9ibYWDZAaZoFeRokzvbvB4kICthJTbzuDmJwCdhLvp5uCdAoLpEp8e/+bHcRm
	EVCVOLN9LjOIzQtUPXnGazYIW1Dix+R7LCA2s4CWxOZtTawQtrzE5jVvmUFGSgioSzz6qwsS
	FhEwkngycQ5UiYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FwjveLE3OLS
	vHS95PzcTYzgqH0mvYNxVYPFIUYBDkYlHl4BCdlAIdbEsuLK3EOMEhzMSiK8a0KAQrwpiZVV
	qUX58UWlOanFhxiTgR6dyCwlmpwPTCh5JfGGxiZmRpZGZhZGJubmpAkrifMynnoSICSQnliS
	mp2aWpBaBLOFiYNTqoFR4N7NmSlymq7rLlZsXuG3TNZt6uygo+8etn9f6LT71VrhO0F2+h62
	L++KfD/65cjDjr5zIsGr4k5eWlVvWcvruf6jp8SHbI2O5N7g3Xu/PvoQ6T/r2fUVK3Yyb5VN
	0JI7V/L4AFtrf/XBT+XiCdLKDRXJRXF/lCR2+qalH633Wnafe1ei3SoPJZbijERDLeai4kQA
	fXAFDh4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the checkpatch warning as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
No changes since v1:

 drivers/rtc/rtc-rs5c372.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-rs5c372.c b/drivers/rtc/rtc-rs5c372.c
index 76f565a..581739f 100644
--- a/drivers/rtc/rtc-rs5c372.c
+++ b/drivers/rtc/rtc-rs5c372.c
@@ -311,8 +311,7 @@ static int rs5c_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 		buf &= ~RS5C_CTRL1_AALE;
 
 	if (i2c_smbus_write_byte_data(client, addr, buf) < 0) {
-		printk(KERN_WARNING "%s: can't update alarm\n",
-			rs5c->rtc->name);
+		dev_warn(dev, "can't update alarm\n");
 		status = -EIO;
 	} else
 		rs5c->regs[RS5C_REG_CTRL1] = buf;
@@ -381,7 +380,7 @@ static int rs5c_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 		addr = RS5C_ADDR(RS5C_REG_CTRL1);
 		buf[0] = rs5c->regs[RS5C_REG_CTRL1] & ~RS5C_CTRL1_AALE;
 		if (i2c_smbus_write_byte_data(client, addr, buf[0]) < 0) {
-			pr_debug("%s: can't disable alarm\n", rs5c->rtc->name);
+			dev_dbg(dev, "can't disable alarm\n");
 			return -EIO;
 		}
 		rs5c->regs[RS5C_REG_CTRL1] = buf[0];
@@ -395,7 +394,7 @@ static int rs5c_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	for (i = 0; i < sizeof(buf); i++) {
 		addr = RS5C_ADDR(RS5C_REG_ALARM_A_MIN + i);
 		if (i2c_smbus_write_byte_data(client, addr, buf[i]) < 0) {
-			pr_debug("%s: can't set alarm time\n", rs5c->rtc->name);
+			dev_dbg(dev, "can't set alarm time\n");
 			return -EIO;
 		}
 	}
@@ -405,8 +404,7 @@ static int rs5c_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 		addr = RS5C_ADDR(RS5C_REG_CTRL1);
 		buf[0] = rs5c->regs[RS5C_REG_CTRL1] | RS5C_CTRL1_AALE;
 		if (i2c_smbus_write_byte_data(client, addr, buf[0]) < 0)
-			printk(KERN_WARNING "%s: can't enable alarm\n",
-				rs5c->rtc->name);
+			dev_warn(dev, "can't enable alarm\n");
 		rs5c->regs[RS5C_REG_CTRL1] = buf[0];
 	}
 
-- 
1.7.2.5



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935524Ab3BOH1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 02:27:45 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:58196 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935388Ab3BOH1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 02:27:44 -0500
X-AuditID: cbfee68f-b7f656d000000d78-4d-511de36fac70
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002b01ce0b4d$865ca950$9315fbf0$%han@samsung.com>
In-reply-to: <002b01ce0b4d$865ca950$9315fbf0$%han@samsung.com>
Subject: [PATCH V3 05/11] rtc: rtc-rs5c372: use dev_dbg()/dev_warn() instead of
 printk()/pr_debug()
Date: Fri, 15 Feb 2013 16:27:42 +0900
Message-id: <002f01ce0b4d$f15bb6b0$d4132410$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LTYY6VzXwCUtKTcq8t8M0FTt2HQAAFO9A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zA938x7KBBv82qFtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MHe8ushScEKj4Pm0/SwPjXt4uRk4OCQETiX9HLrND2GISF+6t
	Z+ti5OIQEljGKPGmYTozTNH1LbuYIBKLGCVeNk+CqprNJHHr0k82kCo2ATWJL18OA43i4BAR
	0Jdoa9EAqWEW6GWUONO7G2yFkICtxNTf31hBbE4BO4nVkzrA4sICqRJbp21iAellEVCV2Psu
	ASTMC1R+8OI0VghbUOLH5HssIDazgJbE5m1NrBC2vMTmNW+ZQVolBNQlHv3VhbjASOLn5RqI
	ChGJfS/eMYJcIyGwiF3iXsMZsL9YBAQkvk0+xALRKiux6QDUu5ISB1fcYJnAKDELyeJZSBbP
	QrJ4FpIVCxhZVjGKphYkFxQnpRcZ6xUn5haX5qXrJefnbmKExFX/Dsa7B6wPMSYDrZ/ILCWa
	nA+My7ySeENjYxMzE1MTc0tTc1PShJXEeeUvyQQKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRq
	YDxofCp7XmzFKqbp59b7N6+2e7/W5prM8rgjCYeE1SdYd3xQOdsS4G/xJ6/wd5+YX963V/um
	1U+5Vz/f8dwU0W6vDok01yMWx9rO6yjmWv+Qc29Ndju30+1/fRfT+lRf3+KYE4d+nguwfdBu
	W+il/V5RO7/awPAtY+NuSTGdrsqizXssrNp3K7EUZyQaajEXFScCAPX/tx7BAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgG7+Y9lAg383eCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxo53F1kKTghUfJ+2n6WB
	cS9vFyMnh4SAicT1LbuYIGwxiQv31rN1MXJxCAksYpR42TwJypnNJHHr0k82kCo2ATWJL18O
	s3cxcnCICOhLtLVogNQwC/QySpzp3c0OUiMkYCsx9fc3VhCbU8BOYvWkDrC4sECqxNZpm1hA
	elkEVCX2vksACfMClR+8OI0VwhaU+DH5HguIzSygJbF5WxMrhC0vsXnNW2aQVgkBdYlHf3Uh
	LjCS+Hm5BqJCRGLfi3eMExiFZiEZNAvJoFlIBs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWle
	ul5yfu4mRnDUPpPewbiqweIQowAHoxIPr4CEbKAQa2JZcWXuIUYJDmYlEV65W0Ah3pTEyqrU
	ovz4otKc1OJDjMlAb05klhJNzgcmlLySeENjEzMjSyMzCyMTc3PShJXEeRlPPQkQEkhPLEnN
	Tk0tSC2C2cLEwSnVwLg2m+tVyFPD0jPNxy2VKl03BLSla+r8+T+va4/vn6auP3mHp92OmXqv
	yHb5wwuCYlWx7zuO6uoWTel66nBm18oyTeGqHye4HMJit0plzfF1fyj53+iiTs6NpUzGYXW1
	Ye67DGynHjC/75zB3vfv6fXFIT1cy3fVqqSolnE8XMjZbtM67Y30biWW4oxEQy3mouJEALoQ
	lXMeAwAA
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

No changes since v2:

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



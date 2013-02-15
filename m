Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab3BOGAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:00:07 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:25966 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab3BOGAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:00:05 -0500
X-AuditID: cbfee68f-b7f656d000000d78-41-511dcee4affa
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001201ce0b41$4900c4d0$db024e70$%han@samsung.com>
In-reply-to: <001201ce0b41$4900c4d0$db024e70$%han@samsung.com>
Subject: [PATCH 05/11] rtc: rtc-rs5c372: use dev_dbg()/dev_warn() instead of
 printk()/pr_debug()
Date: Fri, 15 Feb 2013 15:00:03 +0900
Message-id: <001601ce0b41$b29ff410$17dfdc30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LQUiQnZ5yIGDDRaO8BQe4Zm4AfgAAFUkw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zI90n52QDDd5t47G4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZm1anFcwQqOi4upK1gXE2bxcjJ4eEgInE/f/3WCFsMYkL99az
	gdhCAssYJY7tj4Wpmf9+H1MXIxdQfBGjRPPi11DObCaJq2+3gnWzCahJfPlymL2LkYNDREBf
	oq1FA6SGWaCXUeJM7252iKm2EhM+rWMGsTkF7CS+/3kItk1YIEliYheEzSKgKtGzZhJYDS9Q
	/f2pj1kgbEGJH5PvgdnMAloSm7c1sULY8hKb17xlBtkrIaAu8eivLkhYRMBI4u/BaYwQJSIS
	+168YwS5R0JgEbvEpNcr2SF2CUh8m3yIBaJXVmLTAWaIhyUlDq64wTKBUWIWks2zkGyehWTz
	LCQrFjCyrGIUTS1ILihOSi8y1itOzC0uzUvXS87P3cQIiav+HYx3D1gfYkwGWj+RWUo0OR8Y
	l3kl8YbGxiZmJqYm5pam5qakCSuJ88pfkgkUEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwLjh
	8bGbk9dstTo6ceYVxXDV6d/07vstkvi/3r7saFbkpFnNEy7GmOh66pdsfKXxaMGGb/8U/F28
	2MqOSPxvUd281ehqaITM646C5z/t5qW9ujhnOq/DNfMpNY4bpq5vCBeTFu1fFlq1T9DdZPva
	lOOeV+x9byWeKSja90vC9vMBy41Gtsa16hVKLMUZiYZazEXFiQARGdkqwQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgO6Tc7KBBuueslpc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjE2r0wpmCFR0XF3J2sA4
	m7eLkZNDQsBEYv77fUwQtpjEhXvr2boYuTiEBBYxSjQvfs0E4cxmkrj6disrSBWbgJrEly+H
	2bsYOThEBPQl2lo0QGqYBXoZJc707mYHqRESsJWY8GkdM4jNKWAn8f3PQzYQW1ggSWJiF4TN
	IqAq0bNmElgNL1D9/amPWSBsQYkfk++B2cwCWhKbtzWxQtjyEpvXvGUG2SshoC7x6K8uSFhE
	wEji78FpjBAlIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz
	0vWS83M3MYLj9pn0DsZVDRaHGAU4GJV4eAUkZAOFWBPLiitzDzFKcDArifCuCQEK8aYkVlal
	FuXHF5XmpBYfYkwGenQis5Rocj4wpeSVxBsam5gZWRqZWRiZmJuTJqwkzst46kmAkEB6Yklq
	dmpqQWoRzBYmDk6pBkYh47grUo97HifqpxSz2DUWPWyb+Mo2U3ufhtnNFotETr0dHdruZS3V
	qoF6cTX3bsQmTN3a99OlO+OUMNOK08zup/WnT45b2rfQO6JY5qlI66s9qu9Ybc772p18ffym
	wL141q+1PL/8rigEpfmqH/xUXDdlgmVPTrZCXsBbB/1f1w5ZNe+UUGIpzkg01GIuKk4EADOF
	NM4fAwAA
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



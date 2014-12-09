Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbaLINUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:20:05 -0500
Received: from m12-18.163.com ([220.181.12.18]:56689 "EHLO m12-18.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756906AbaLINUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:20:03 -0500
X-Coremail-DSSMTP: 117.88.175.67
From: weiyj_lk@163.com
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-kernel@vger.kernel.org
Subject: [PATCH -next] regulator: rk808: Fix sparse non static symbol warnings
Date: Tue,  9 Dec 2014 21:19:51 +0800
Message-Id: <1418131191-4736-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: EsCowEAJryf59oZUlVSIAw--.1495S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJF15Xw4UWw1fGF43Ar1DWrg_yoW8Aw13pa
	1UtFsrCrW0vayxArWxCwsay3W5X34ft3yxZas5Gw43u3W3J3Z7Xr1kAr13AF18Cr97JFsF
	yFy7J348CF1UZFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jCSoXUUUUU=
X-Originating-IP: [117.88.175.67]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbiGQFd1lEAQCV9uQACsh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warnings:

drivers/regulator/rk808-regulator.c:100:5: warning:
 symbol 'rk808_set_suspend_voltage' was not declared. Should it be static?
drivers/regulator/rk808-regulator.c:115:5: warning:
 symbol 'rk808_set_suspend_enable' was not declared. Should it be static?
drivers/regulator/rk808-regulator.c:126:5: warning:
 symbol 'rk808_set_suspend_disable' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/regulator/rk808-regulator.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/rk808-regulator.c b/drivers/regulator/rk808-regulator.c
index ea9d05e..8c2c57a 100644
--- a/drivers/regulator/rk808-regulator.c
+++ b/drivers/regulator/rk808-regulator.c
@@ -97,7 +97,7 @@ static int rk808_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 				  RK808_RAMP_RATE_MASK, ramp_value);
 }
 
-int rk808_set_suspend_voltage(struct regulator_dev *rdev, int uv)
+static int rk808_set_suspend_voltage(struct regulator_dev *rdev, int uv)
 {
 	unsigned int reg;
 	int sel = regulator_map_voltage_linear_range(rdev, uv, uv);
@@ -112,7 +112,7 @@ int rk808_set_suspend_voltage(struct regulator_dev *rdev, int uv)
 				  sel);
 }
 
-int rk808_set_suspend_enable(struct regulator_dev *rdev)
+static int rk808_set_suspend_enable(struct regulator_dev *rdev)
 {
 	unsigned int reg;
 
@@ -123,7 +123,7 @@ int rk808_set_suspend_enable(struct regulator_dev *rdev)
 				  0);
 }
 
-int rk808_set_suspend_disable(struct regulator_dev *rdev)
+static int rk808_set_suspend_disable(struct regulator_dev *rdev)
 {
 	unsigned int reg;
 


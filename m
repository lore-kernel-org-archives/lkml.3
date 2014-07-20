Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaGTF02 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 01:26:28 -0400
Received: from m12-17.163.com ([220.181.12.17]:41633 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbaGTF01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 01:26:27 -0400
X-Coremail-DSSMTP: 180.110.162.144
From: weiyj_lk@163.com
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-kernel@vger.kernel.org
Subject: [PATCH -next] misc: vexpress: Fix sparse non static symbol warnings
Date: Sun, 20 Jul 2014 13:25:39 +0800
Message-Id: <1405833939-7577-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: EcCowEBJ+HTbUstT8F_aAw--.1339S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJF15Xw1DXw48uw1xZr45trb_yoW8GF4UpF
	srXFyIkr48GF47Aay5tan5CFWrWr9ava48Gw45A3yrZwn8Cr9rJF1DGFyUAry8JrZ3K3WD
	tw40yryrCrsIvr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07b2L05UUUUU=
X-Originating-IP: [180.110.162.144]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbiGQrO1lEANZTszgAAsZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warnings:

drivers/misc/vexpress-syscfg.c:133:22: warning:
 symbol 'vexpress_syscfg_regmap_config' was not declared. Should it be static?
drivers/misc/vexpress-syscfg.c:279:5: warning:
 symbol 'vexpress_syscfg_probe' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/misc/vexpress-syscfg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/vexpress-syscfg.c b/drivers/misc/vexpress-syscfg.c
index 3250fc1..b3a8123 100644
--- a/drivers/misc/vexpress-syscfg.c
+++ b/drivers/misc/vexpress-syscfg.c
@@ -130,7 +130,7 @@ static int vexpress_syscfg_write(void *context, unsigned int index,
 	return vexpress_syscfg_exec(func, index, true, &val);
 }
 
-struct regmap_config vexpress_syscfg_regmap_config = {
+static struct regmap_config vexpress_syscfg_regmap_config = {
 	.lock = vexpress_config_lock,
 	.unlock = vexpress_config_unlock,
 	.reg_bits = 32,
@@ -276,7 +276,7 @@ int vexpress_syscfg_device_register(struct platform_device *pdev)
 }
 
 
-int vexpress_syscfg_probe(struct platform_device *pdev)
+static int vexpress_syscfg_probe(struct platform_device *pdev)
 {
 	struct vexpress_syscfg *syscfg;
 	struct resource *res;


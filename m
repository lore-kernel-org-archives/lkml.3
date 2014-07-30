Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbaG3Axo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 20:53:44 -0400
Received: from m12-17.163.com ([220.181.12.17]:51119 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaG3Axn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 20:53:43 -0400
X-Coremail-DSSMTP: 180.110.163.205
From: weiyj_lk@163.com
To: Sebastian Reichel <sre@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Carlos Chinea <carlos.chinea@nokia.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-kernel@vger.kernel.org
Subject: [PATCH] HSI: omap_ssi_port: Fix return value check in ssi_debug_add_port()
Date: Wed, 30 Jul 2014 08:53:20 +0800
Message-Id: <1406681600-19741-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: EcCowEC5sqoCQthTaXx0Bg--.202S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Wr4kurWfKr1UGr17Ar45GFg_yoW8JF45pa
	1kW347Kry0qFZIy3yFva1xXFy5AF9aqa4IkrW5CwnxZr1ruw4Fv347AF90kF97u3s7Xay5
	Xw15GF1UGF18Jr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bYVbkUUUUU=
X-Originating-IP: [180.110.163.205]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbiowLY1lD+VkmB9gAAsp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function debugfs_create_*() returns NULL
pointer not ERR_PTR() if debugfs is enabled. The IS_ERR() test
in the return value check should be replaced with NULL test.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/hsi/controllers/omap_ssi_port.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hsi/controllers/omap_ssi_port.c b/drivers/hsi/controllers/omap_ssi_port.c
index 29aea0b..eefbb50 100644
--- a/drivers/hsi/controllers/omap_ssi_port.c
+++ b/drivers/hsi/controllers/omap_ssi_port.c
@@ -177,13 +177,13 @@ static int __init ssi_debug_add_port(struct omap_ssi_port *omap_port,
 	struct hsi_port *port = to_hsi_port(omap_port->dev);
 
 	dir = debugfs_create_dir(dev_name(omap_port->dev), dir);
-	if (IS_ERR(dir))
-		return PTR_ERR(dir);
+	if (!dir)
+		return -ENOMEM;
 	omap_port->dir = dir;
 	debugfs_create_file("regs", S_IRUGO, dir, port, &ssi_port_regs_fops);
 	dir = debugfs_create_dir("sst", dir);
-	if (IS_ERR(dir))
-		return PTR_ERR(dir);
+	if (!dir)
+		return -ENOMEM;
 	debugfs_create_file("divisor", S_IRUGO | S_IWUSR, dir, port,
 			    &ssi_sst_div_fops);
 


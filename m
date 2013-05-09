Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab3EII2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 04:28:21 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:26546 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab3EII2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 04:28:17 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <Sonic.Zhang@analog.com>, <wsa@the-dreams.de>
CC: <uclinux-dist-devel@blackfin.uclinux.org>, <linux-kernel@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <lizefan@huawei.com>,
        Libo Chen <libo.chen@huawei.com>
Subject: [PATCH v2 1/2] i2c: i2c-bfin-twi: don`t free peripheral before it init successful
Date: Thu, 9 May 2013 16:27:23 +0800
Message-ID: <1368088044-20408-2-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1368088044-20408-1-git-send-email-libo.chen@huawei.com>
References: <1368088044-20408-1-git-send-email-libo.chen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

down out_error_no_irq. When platform_get_irq fail, no need to free peripheral

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/i2c/busses/i2c-bfin-twi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index 05080c4..6617645 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -709,9 +709,9 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
 out_error_add_adapter:
 	free_irq(iface->irq, iface);
 out_error_req_irq:
-out_error_no_irq:
 	peripheral_free_list((unsigned short *)pdev->dev.platform_data);
 out_error_pin_mux:
+out_error_no_irq:
 	iounmap(iface->regs_base);
 out_error_ioremap:
 out_error_get_res:
-- 
1.7.1



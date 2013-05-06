Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab3EFNMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 09:12:23 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:17843 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab3EFNMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 09:12:19 -0400
Message-ID: <5187ABF6.4000907@huawei.com>
Date: Mon, 6 May 2013 21:11:18 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: <wsa@the-dreams.de>
CC: <uclinux-dist-devel@blackfin.uclinux.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH 1/2] i2c: i2c-bfin-twi: don`t free peripheral before it`s
 init successful
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
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
index 05080c4..d38e05a 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -709,8 +709,8 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
 out_error_add_adapter:
 	free_irq(iface->irq, iface);
 out_error_req_irq:
-out_error_no_irq:
 	peripheral_free_list((unsigned short *)pdev->dev.platform_data);
+out_error_no_irq:
 out_error_pin_mux:
 	iounmap(iface->regs_base);
 out_error_ioremap:
-- 
1.7.1



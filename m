Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab3EQIZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 04:25:22 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46223 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3EQIZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 04:25:18 -0400
MIME-Version: 1.0
Date: Fri, 17 May 2013 16:25:17 +0800
Message-ID: <CAPgLHd-L6gbKfv+5O0iJ+6vkS_o6QguxWj+7yPp-h9ZQDhb+1A@mail.gmail.com>
Subject: [PATCH] ipmi: add missing platform_device_put() on error in try_smi_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: minyard@acm.org, grant.likely@linaro.org, rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, openipmi-developer@lists.sourceforge.net,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing platform_device_put() before return from
try_smi_init() in the platform_device_add() fail case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/char/ipmi/ipmi_si_intf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index af4b23f..3f6c390 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -3299,6 +3299,7 @@ static int try_smi_init(struct smi_info *new_smi)
 			       "Unable to register system interface device:"
 			       " %d\n",
 			       rv);
+			platform_device_put(new_smi->pdev);
 			goto out_err;
 		}
 		new_smi->dev_registered = 1;


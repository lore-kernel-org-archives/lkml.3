Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaJ1LwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:52:10 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:59676 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaJ1LwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:52:07 -0400
From: Zhen Lei <thunder.leizhen@huawei.com>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Zefan Li <lizefan@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        "Kefeng Wang" <wangkefeng.wang@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] of/fdt: simplify early_init_dt_verify
Date: Tue, 28 Oct 2014 19:51:05 +0800
Message-ID: <1414497065-9808-1-git-send-email-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 1.8.4.msysgit.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.27.142]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

put off initial_boot_params = params; until all checks finished. If any check
failed, initial_boot_params is equal NULL, base upon bss segment initial value.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/of/fdt.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index d1ffca8..325c638 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -994,14 +994,12 @@ bool __init early_init_dt_verify(void *params)
 	if (!params)
 		return false;

-	/* Setup flat device-tree pointer */
-	initial_boot_params = params;
-
 	/* check device tree validity */
-	if (fdt_check_header(params)) {
-		initial_boot_params = NULL;
+	if (fdt_check_header(params))
 		return false;
-	}
+
+	/* Setup flat device-tree pointer */
+	initial_boot_params = params;

 	return true;
 }
--
1.8.0



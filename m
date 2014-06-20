Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaFTEUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 00:20:04 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:39793 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaFTEUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 00:20:03 -0400
Message-ID: <53A3B665.3080308@huawei.com>
Date: Fri, 20 Jun 2014 12:19:49 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Matt Fleming <matt.fleming@intel.com>, <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] firmware: fix the compiller warning
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.246]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I compile the kernel, found this warning:

In file included from arch/arm64/kernel/efi-stub.c:44:0:
arch/arm64/kernel/../../../drivers/firmware/efi/fdt.c: In function update_fdt:
arch/arm64/kernel/../../../drivers/firmware/efi/fdt.c:66:22: warning: unused variable name [-Wunused-variable]
   const char *type, *name;

so remove the unused variable and clean this warning.

Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/firmware/efi/fdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/fdt.c b/drivers/firmware/efi/fdt.c
index 5c6a8e8..82d7741 100644
--- a/drivers/firmware/efi/fdt.c
+++ b/drivers/firmware/efi/fdt.c
@@ -63,7 +63,7 @@ static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 	 */
 	prev = 0;
 	for (;;) {
-		const char *type, *name;
+		const char *type;
 		int len;
 
 		node = fdt_next_node(fdt, prev, NULL);
-- 
1.8.0



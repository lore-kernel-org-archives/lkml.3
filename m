Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbaDCWXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:23:16 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:41924 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbaDCWRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:17:35 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org
Subject: [PATCH 06/20] c6x: convert fdt pointers to opaque pointers
Date: Thu,  3 Apr 2014 17:16:49 -0500
Message-Id: <1396563423-30893-7-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

The architecture code does not need to access the internals of the FDT
blob, so make the pointer to it void *.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: linux-c6x-dev@linux-c6x.org
---
 arch/c6x/kernel/setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/c6x/kernel/setup.c b/arch/c6x/kernel/setup.c
index 731db4b..a6b2582 100644
--- a/arch/c6x/kernel/setup.c
+++ b/arch/c6x/kernel/setup.c
@@ -265,8 +265,8 @@ int __init c6x_add_memory(phys_addr_t start, unsigned long size)
  */
 notrace void __init machine_init(unsigned long dt_ptr)
 {
-	struct boot_param_header *dtb = __va(dt_ptr);
-	struct boot_param_header *fdt = (struct boot_param_header *)_fdt_start;
+	const void *dtb = __va(dt_ptr);
+	const void *fdt = (const void *)_fdt_start;
 
 	/* interrupts must be masked */
 	set_creg(IER, 2);
-- 
1.8.3.2


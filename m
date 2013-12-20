Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab3LTT13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:27:29 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:56039 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab3LTT11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:27:27 -0500
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: gregkh@linuxfoundation.org
Cc: jim.epost@gmail.com, sfr@canb.auug.org.au, fengguang.wu@intel.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        kbuild-all@01.org, haver@linux.vnet.ibm.com
Subject: [PATCH] GenWQE: Accidently casting to u32 where u64 is required
Date: Fri, 20 Dec 2013 20:27:20 +0100
Message-Id: <1387567640-25413-1-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1387566773.1847.28.camel@oc7383187364.ibm.com>
References: <1387566773.1847.28.camel@oc7383187364.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122019-6892-0000-0000-00000748A2A3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a casting to u32 where u64 would be appropriate.
The bad casting made the driver unusable.

Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
---
 drivers/misc/genwqe/card_utils.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -59,7 +59,7 @@ int __genwqe_writeq(struct genwqe_dev *c
 	if (cd->mmio == NULL)
 		return -EIO;
 
-	__raw_writeq((__force u32)cpu_to_be64(val), cd->mmio + byte_offs);
+	__raw_writeq((__force u64)cpu_to_be64(val), cd->mmio + byte_offs);
 	return 0;
 }
 


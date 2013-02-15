Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161317Ab3BOMps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:45:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935848Ab3BOMpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:45:39 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC 11/13] edac: initialize the core earlier
Date: Fri, 15 Feb 2013 10:44:59 -0200
Message-Id: <cbce5bcf44ee6e87d6cde94daab1dde7f9b7609a.1360931635.git.mchehab@redhat.com>
In-Reply-To: <cover.1360931635.git.mchehab@redhat.com>
References: <cover.1360931635.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order for it to work with it builtin, the EDAC core should
be initialized earlier, otherwise the ghes_edac driver initializes
before edac_mc_sysfs_init() being called:

...
[    4.998373] EDAC MC0: Giving out device to 'ghes_edac.c' 'ghes_edac': DEV ghes
...
[    4.998373] EDAC MC1: Giving out device to 'ghes_edac.c' 'ghes_edac': DEV ghes
[    6.519495] EDAC MC: Ver: 3.0.0
[    6.523749] EDAC DEBUG: edac_mc_sysfs_init: device mc created

The net result is that no EDAC sysfs nodes will appear.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_module.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/edac_module.c b/drivers/edac/edac_module.c
index 12c951a..a66941f 100644
--- a/drivers/edac/edac_module.c
+++ b/drivers/edac/edac_module.c
@@ -146,7 +146,7 @@ static void __exit edac_exit(void)
 /*
  * Inform the kernel of our entry and exit points
  */
-module_init(edac_init);
+subsys_initcall(edac_init);
 module_exit(edac_exit);
 
 MODULE_LICENSE("GPL");
-- 
1.8.1.2


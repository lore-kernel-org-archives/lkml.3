Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934571Ab3IDMgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 08:36:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:53236 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755625Ab3IDMgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:36:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1021,1367996400"; 
   d="scan'208";a="290697370"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [char-misc-next] hpet: remove useless check if fixmem32 is NULL
Date: Wed,  4 Sep 2013 15:35:52 +0300
Message-Id: <1378298152-30765-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixmem32 is assigned to address of res->data member
so the address is always valid

Actually since we are not checking for res != NULL
static analyzing is complaining about referencing the pointer
and consequent check for null.
The code snippet looks confusing also for human eyes.

Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/char/hpet.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 448ce5e..c8f4329 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -971,8 +971,6 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
 		struct acpi_resource_fixed_memory32 *fixmem32;
 
 		fixmem32 = &res->data.fixed_memory32;
-		if (!fixmem32)
-			return AE_NO_MEMORY;
 
 		hdp->hd_phys_address = fixmem32->address;
 		hdp->hd_address = ioremap(fixmem32->address,
-- 
1.8.3.1


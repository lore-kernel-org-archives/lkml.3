Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab3LLKIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 05:08:43 -0500
Received: from mga03.intel.com ([143.182.124.21]:35832 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab3LLKIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 05:08:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,877,1378882800"; 
   d="scan'208";a="442994504"
From: Lan Tianyu <tianyu.lan@intel.com>
To: lenb@kernel.org, rjw@rjwysocki.net
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI/EC: disable gpe before removing gpe handler
Date: Thu, 12 Dec 2013 18:08:52 +0800
Message-Id: <1386842932-8057-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjust the order of disabling gpe and removing gpe handler to
make sure no gpe after removing gpe handler.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/ec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index ff40120..172a124 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -778,9 +778,9 @@ static int ec_install_handlers(struct acpi_ec *ec)
 			pr_err("Fail in evaluating the _REG object"
 				" of EC device. Broken bios is suspected.\n");
 		} else {
+			acpi_disable_gpe(NULL, ec->gpe);
 			acpi_remove_gpe_handler(NULL, ec->gpe,
 				&acpi_ec_gpe_handler);
-			acpi_disable_gpe(NULL, ec->gpe);
 			return -ENODEV;
 		}
 	}
-- 
1.8.2.1


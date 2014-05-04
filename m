Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbaEDLuc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 07:50:32 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:52689 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753276AbaEDLub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 07:50:31 -0400
Message-ID: <1399204229.8729.15.camel@x220>
Subject: [PATCH] libata-sff: remove dead code
From: Paul Bolle <pebolle@tiscali.nl>
To: Tejun Heo <tj@kernel.org>
Cc: Alan Cox <alan@linux.intel.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 04 May 2014 13:50:29 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 May 2014 11:50:29.0839 (UTC) FILETIME=[0C1F35F0:01CF678F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ever since v2.6.19 the code contains a check for CONFIG_NO_ATA_LEGACY.
But that macro has never been defined. Apparently no one ran into
problems on platforms that do not support compatibility mode. So remove
this code that has been dead for over seven years.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested!

Perhaps the test should have been
    #if !defined(CONFIG_PATA_LEGACY)

I wouldn't know if that's correct. But after seven years it doesn't
matter anyhow, so I did not bother to research that.

 drivers/ata/libata-sff.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index b603720b877d..1121153f1ecd 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2433,15 +2433,6 @@ int ata_pci_sff_activate_host(struct ata_host *host,
 		mask = (1 << 2) | (1 << 0);
 		if ((tmp8 & mask) != mask)
 			legacy_mode = 1;
-#if defined(CONFIG_NO_ATA_LEGACY)
-		/* Some platforms with PCI limits cannot address compat
-		   port space. In that case we punt if their firmware has
-		   left a device in compatibility mode */
-		if (legacy_mode) {
-			printk(KERN_ERR "ata: Compatibility mode ATA is not supported on this platform, skipping.\n");
-			return -EOPNOTSUPP;
-		}
-#endif
 	}
 
 	if (!devres_open_group(dev, NULL, GFP_KERNEL))
-- 
1.9.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab3DLS2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 14:28:09 -0400
Received: from masquerade.micron.com ([137.201.242.130]:18849 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab3DLS2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 14:28:08 -0400
Message-ID: <51685232.2040209@micron.com>
Date: Fri, 12 Apr 2013 23:58:02 +0530
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sam Bradshaw" <sbradshaw@micron.com>
Subject: [PATCH 2/2] mtip32xx: mtip32xx: Disable TRIM support
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19794.000
X-TM-AS-Result: No-8.144500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Temporarily disabling TRIM support until TRIM related issues
are addressed in the firmware.

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index d11ea92..53bad62 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -1560,10 +1560,12 @@ static int mtip_get_identify(struct mtip_port *port, void __user *user_buffer)
 	}
 #endif
 
+#ifdef MTIP_TRIM /* Disabling TRIM support temporarily */
 	/* Demux ID.DRAT & ID.RZAT to determine trim support */
 	if (port->identify[69] & (1 << 14) && port->identify[69] & (1 << 5))
 		port->dd->trim_supp = true;
 	else
+#endif
 		port->dd->trim_supp = false;
 
 	/* Set the identify buffer as valid. */
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034Ab3DCOYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:24:43 -0400
Received: from masquerade.micron.com ([137.201.242.130]:46676 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758541Ab3DCOYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:24:42 -0400
Message-ID: <515C3BA3.5090208@micron.com>
Date: Wed, 3 Apr 2013 19:54:35 +0530
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sam Bradshaw" <sbradshaw@micron.com>
Subject: [PATCH 2/3] mtip32xx: return 0 from pci probe in case of rebuild
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19764.007
X-TM-AS-Result: No--5.287700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix to return 0 from pci probe in case of rebuild. If not, pci consider
probe has failed, and crash during rmmod.

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 5becdaa..7e1aeb3 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4300,6 +4300,8 @@ static int mtip_pci_probe(struct pci_dev *pdev,
 	instance++;
 	if (rv != MTIP_FTL_REBUILD_MAGIC)
 		set_bit(MTIP_DDF_INIT_DONE_BIT, &dd->dd_flag);
+	else
+		rv = 0; /* device in rebuild state, return 0 from probe */
 	goto done;
 
 block_initialize_err:
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbaCNUZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 16:25:23 -0400
Received: from mailout.micron.com ([137.201.242.129]:30219 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbaCNUZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 16:25:22 -0400
Message-ID: <532365AD.6080201@micron.com>
Date: Fri, 14 Mar 2014 13:25:17 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:28.0) Gecko/20100101 Thunderbird/28.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Rajesh Kumar S <rsambandam@micron.com>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH] mtip32xx: Fix incorrectly releasing a reference to pci_dev
 in pci_remove()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20566.001
X-TM-AS-Result: No--3.059800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix incorrectly releasing a reference to pci_dev in pci_remove()

Signed-off-by: Rajesh Kumar S <rsambandam@micron.com>
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 624e9d9..54ad4df 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4737,8 +4737,6 @@ static void mtip_pci_remove(struct pci_dev *pdev)
 
 	pcim_iounmap_regions(pdev, 1 << MTIP_ABAR);
 	pci_set_drvdata(pdev, NULL);
-	pci_dev_put(pdev);
-
 }
 
 /*
-- 
1.7.1


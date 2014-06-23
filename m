Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaFWIqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:46:40 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55563 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752597AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Carretero?= <cJ-ko@zougloub.eu>,
        Tejun Heo <tj@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 074/111] ahci: Add Device ID for HighPoint RocketRaid 642L
Date: Mon, 23 Jun 2014 10:31:49 +0200
Message-Id: <e3f3e7f6609d79422703cb8a1d4b17b0485e08ae.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jérôme Carretero <cJ-ko@zougloub.eu>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d251836508fb26cd1a22b41381739835ee23728d upstream.

This device normally comes with a proprietary driver, using a web GUI
to configure RAID:
 http://www.highpoint-tech.com/USA_new/series_rr600-download.htm
But thankfully it also works out of the box with the AHCI driver,
being just a Marvell 88SE9235.

Devices 640L, 644L, 644LS should also be supported but not tested here.

Signed-off-by: Jérôme Carretero <cJ-ko@zougloub.eu>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/ata/ahci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index b4bdb8859485..65ef4024da09 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -448,6 +448,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	  .driver_data = board_ahci_yes_fbs },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9230),
 	  .driver_data = board_ahci_yes_fbs },
+	{ PCI_DEVICE(PCI_VENDOR_ID_TTI, 0x0642),
+	  .driver_data = board_ahci_yes_fbs },
 
 	/* Promise */
 	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
-- 
2.0.0


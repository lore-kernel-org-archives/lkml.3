Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbaGHTVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:21:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54289 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755739AbaGHTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Tejun Heo" <tj@kernel.org>,
        "=?UTF-8?q?J=C3=A9r=C3=B4me=20Carretero?=" <cJ-ko@zougloub.eu>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.778563024@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 057/125] ahci: Add Device ID for HighPoint RocketRaid 642L
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jérôme Carretero <cJ-ko@zougloub.eu>

commit d251836508fb26cd1a22b41381739835ee23728d upstream.

This device normally comes with a proprietary driver, using a web GUI
to configure RAID:
 http://www.highpoint-tech.com/USA_new/series_rr600-download.htm
But thankfully it also works out of the box with the AHCI driver,
being just a Marvell 88SE9235.

Devices 640L, 644L, 644LS should also be supported but not tested here.

Signed-off-by: Jérôme Carretero <cJ-ko@zougloub.eu>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/ahci.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -458,6 +458,8 @@ static const struct pci_device_id ahci_p
 	  .driver_data = board_ahci_yes_fbs },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9230),
 	  .driver_data = board_ahci_yes_fbs },
+	{ PCI_DEVICE(PCI_VENDOR_ID_TTI, 0x0642),
+	  .driver_data = board_ahci_yes_fbs },
 
 	/* Promise */
 	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762664AbaGRP2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:28:52 -0400
Received: from isis.lip6.fr ([132.227.60.2]:55170 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762307AbaGRP0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:26:24 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: Jon Mason <jdmason@kudzu.us>
Cc: benoit.taine@lip6.fr, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/25] net: neterion: Replace DEFINE_PCI_DEVICE_TABLE macro use
Date: Fri, 18 Jul 2014 17:26:56 +0200
Message-Id: <1405697232-11785-10-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
References: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Fri, 18 Jul 2014 17:26:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should prefer `struct pci_device_id` over `DEFINE_PCI_DEVICE_TABLE` to meet
kernel coding style guidelines. This issue was reported by checkpatch.

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>

---
Tested by compilation without errors.

 drivers/net/ethernet/neterion/s2io.c           |    2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index be58764..f5e4b82 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -471,7 +471,7 @@ module_param_array(rts_frm_len, uint, NULL, 0);
  * S2IO device table.
  * This table lists all the devices that this driver supports.
  */
-static DEFINE_PCI_DEVICE_TABLE(s2io_tbl) = {
+static const struct pci_device_id s2io_tbl[] = {
 	{PCI_VENDOR_ID_S2IO, PCI_DEVICE_ID_S2IO_WIN,
 	 PCI_ANY_ID, PCI_ANY_ID},
 	{PCI_VENDOR_ID_S2IO, PCI_DEVICE_ID_S2IO_UNI,
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 7a0dead..061dcf2 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -63,7 +63,7 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("Neterion's X3100 Series 10GbE PCIe I/O"
 	"Virtualized Server Adapter");
 
-static DEFINE_PCI_DEVICE_TABLE(vxge_id_table) = {
+static const struct pci_device_id vxge_id_table[] = {
 	{PCI_VENDOR_ID_S2IO, PCI_DEVICE_ID_TITAN_WIN, PCI_ANY_ID,
 	PCI_ANY_ID},
 	{PCI_VENDOR_ID_S2IO, PCI_DEVICE_ID_TITAN_UNI, PCI_ANY_ID,


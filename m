Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbbARDaW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 22:30:22 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:57475 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbbARDaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 22:30:18 -0500
From: Andrew Milkovich <amilkovich@gmail.com>
To: benjamin.romer@unisys.com
Cc: david.kershner@unisys.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Andrew Milkovich <amilkovich@gmail.com>
Subject: [PATCH] Staging: unisys: virtpci: fixed coding style errors
Date: Sat, 17 Jan 2015 19:30:12 -0800
Message-Id: <1421551812-14371-1-git-send-email-amilkovich@gmail.com>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style errors per checkpatch.pl. Inline comments removed; chanptr
comment is implied by the first argument being the channel. No parent bus
comment is already understood by the argument being NULL.

Signed-off-by: Andrew Milkovich <amilkovich@gmail.com>
---
 drivers/staging/unisys/virtpci/virtpci.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/unisys/virtpci/virtpci.c b/drivers/staging/unisys/virtpci/virtpci.c
index 8fdfd6f..ee212f8 100644
--- a/drivers/staging/unisys/virtpci/virtpci.c
+++ b/drivers/staging/unisys/virtpci/virtpci.c
@@ -275,10 +275,8 @@ static int add_vbus(struct add_vbus_guestpart *addparams)
 		POSTCODE_LINUX_2(VPCI_CREATE_FAILURE_PC, POSTCODE_SEVERITY_ERR);
 		return 0;
 	}
-	write_vbus_chp_info(vbus->platform_data /* chanptr */,
-			    &chipset_driver_info);
-	write_vbus_bus_info(vbus->platform_data /* chanptr */,
-			    &bus_driver_info);
+	write_vbus_chp_info(vbus->platform_data, &chipset_driver_info);
+	write_vbus_bus_info(vbus->platform_data, &bus_driver_info);
 	LOGINF("Added vbus %d; device %s created successfully\n",
 	       addparams->bus_no, BUS_ID(vbus));
 	POSTCODE_LINUX_2(VPCI_CREATE_EXIT_PC, POSTCODE_SEVERITY_INFO);
@@ -462,8 +460,7 @@ static int pause_vhba(struct pause_virt_guestpart *pauseparams)
 	GET_SCSIADAPINFO_FROM_CHANPTR(pauseparams->chanptr);
 
 	LOGINF("Pausing vhba wwnn:%x:%x\n", scsi.wwnn.wwnn1, scsi.wwnn.wwnn2);
-	i = virtpci_device_serverdown(NULL /*no parent bus */, VIRTHBA_TYPE,
-				      &scsi.wwnn, NULL);
+	i = virtpci_device_serverdown(NULL, VIRTHBA_TYPE, &scsi.wwnn, NULL);
 	if (i)
 		LOGINF("Paused vhba wwnn:%x:%x\n", scsi.wwnn.wwnn1,
 		       scsi.wwnn.wwnn2);
@@ -483,8 +480,7 @@ static int pause_vnic(struct pause_virt_guestpart *pauseparams)
 	LOGINF("Pausing vnic macaddr:%02x:%02x:%02x:%02x:%02x:%02x\n",
 	       net.mac_addr[0], net.mac_addr[1], net.mac_addr[2],
 	       net.mac_addr[3], net.mac_addr[4], net.mac_addr[5]);
-	i = virtpci_device_serverdown(NULL /*no parent bus */, VIRTNIC_TYPE,
-				      NULL, net.mac_addr);
+	i = virtpci_device_serverdown(NULL, VIRTNIC_TYPE, NULL, net.mac_addr);
 	if (i) {
 		LOGINF(" Paused vnic macaddr:%02x:%02x:%02x:%02x:%02x:%02x\n",
 		       net.mac_addr[0], net.mac_addr[1], net.mac_addr[2],
@@ -504,8 +500,7 @@ static int resume_vhba(struct resume_virt_guestpart *resumeparams)
 	GET_SCSIADAPINFO_FROM_CHANPTR(resumeparams->chanptr);
 
 	LOGINF("Resuming vhba wwnn:%x:%x\n", scsi.wwnn.wwnn1, scsi.wwnn.wwnn2);
-	i = virtpci_device_serverup(NULL /*no parent bus */, VIRTHBA_TYPE,
-				    &scsi.wwnn, NULL);
+	i = virtpci_device_serverup(NULL, VIRTHBA_TYPE, &scsi.wwnn, NULL);
 	if (i)
 		LOGINF("Resumed vhba wwnn:%x:%x\n", scsi.wwnn.wwnn1,
 		       scsi.wwnn.wwnn2);
@@ -526,8 +521,7 @@ resume_vnic(struct resume_virt_guestpart *resumeparams)
 	LOGINF("Resuming vnic macaddr:%02x:%02x:%02x:%02x:%02x:%02x\n",
 	       net.mac_addr[0], net.mac_addr[1], net.mac_addr[2],
 	       net.mac_addr[3], net.mac_addr[4], net.mac_addr[5]);
-	i = virtpci_device_serverup(NULL /*no parent bus */, VIRTNIC_TYPE,
-				    NULL, net.mac_addr);
+	i = virtpci_device_serverup(NULL, VIRTNIC_TYPE, NULL, net.mac_addr);
 	if (i) {
 		LOGINF(" Resumed vnic macaddr:%02x:%02x:%02x:%02x:%02x:%02x\n",
 		       net.mac_addr[0], net.mac_addr[1], net.mac_addr[2],
@@ -547,8 +541,7 @@ static int delete_vhba(struct del_virt_guestpart *delparams)
 	GET_SCSIADAPINFO_FROM_CHANPTR(delparams->chanptr);
 
 	LOGINF("Deleting vhba wwnn:%x:%x\n", scsi.wwnn.wwnn1, scsi.wwnn.wwnn2);
-	i = virtpci_device_del(NULL /*no parent bus */, VIRTHBA_TYPE,
-			       &scsi.wwnn, NULL);
+	i = virtpci_device_del(NULL, VIRTHBA_TYPE, &scsi.wwnn, NULL);
 	if (i) {
 		LOGINF("Deleted vhba wwnn:%x:%x\n", scsi.wwnn.wwnn1,
 		       scsi.wwnn.wwnn2);
@@ -570,8 +563,7 @@ static int delete_vnic(struct del_virt_guestpart *delparams)
 	LOGINF("Deleting vnic macaddr:%02x:%02x:%02x:%02x:%02x:%02x\n",
 	       net.mac_addr[0], net.mac_addr[1], net.mac_addr[2],
 	       net.mac_addr[3], net.mac_addr[4], net.mac_addr[5]);
-	i = virtpci_device_del(NULL /*no parent bus */, VIRTNIC_TYPE, NULL,
-			       net.mac_addr);
+	i = virtpci_device_del(NULL, VIRTNIC_TYPE, NULL, net.mac_addr);
 	if (i) {
 		LOGINF("Deleted vnic macaddr:%02x:%02x:%02x:%02x:%02x:%02x\n",
 		       net.mac_addr[0], net.mac_addr[1], net.mac_addr[2],
-- 
2.2.2


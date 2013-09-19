Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab3ISJAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:00:18 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:33621 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751804Ab3ISJAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:00:14 -0400
X-Forefront-Antispam-Report: CIP:192.19.193.42;KIP:(null);UIP:(null);IPV:NLI;H:paledge01.lsi.com;RD:paledge01.lsi.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzd2iz1de098h1de097h8275bhz2fh2a8h839h944hd25he5bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dc1h1de2h1dfeh1dffh1e1dh1fe8h1ff5h209eh1155h)
Date: Thu, 19 Sep 2013 14:29:47 +0530
From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <Nagalakshmi.Nandigama@lsi.com>,
        <Sreekanth.Reddy@lsi.com>
Subject: [PATCH] enclosure : fix sysfs link remove warning
Message-ID: <20130919085947.GA3794@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-OriginatorOrg: lsi.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%PARALLELS.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the enclosure link only when cdev->cdev.kobj.sd is not NULL.

Fixes:

WARNING: at fs/sysfs/inode.c:324 sysfs_hash_and_remove+0x92/0xa0()
Call Trace:
  [<c044bbf2>] warn_slowpath_common+0x72/0xa0
  [<c05b2d12>] ? sysfs_hash_and_remove+0x92/0xa0
  [<c05b2d12>] ? sysfs_hash_and_remove+0x92/0xa0
  [<c044bcc3>] warn_slowpath_fmt+0x33/0x40
  [<c05b2d12>] sysfs_hash_and_remove+0x92/0xa0
  [<c05b4d38>] sysfs_remove_link+0x18/0x30
  [<fc96e793>] enclosure_remove_links+0x53/0x80 [enclosure]
  [<c05b0020>] ? proc_sys_readdir+0x290/0x2b0
  [<c05b3dcc>] ? release_sysfs_dirent+0x5c/0xc0
  [<fc96e87d>] enclosure_component_release+0x1d/0x40 [enclosure]
  [<c07564b0>] device_release+0x20/0x80
  [<c05b469b>] ? remove_dir+0x2b/0x40
  [<c067e1b8>] kobject_cleanup+0x78/0x1b0
  [<c05b4ae9>] ? sysfs_remove_dir+0x89/0xb0
  [<c067e065>] kobject_put+0x25/0x60
  [<c0756264>] ? put_device+0x14/0x20
  [<c07571dc>] ? device_del+0x12c/0x160
  [<c0756264>] put_device+0x14/0x20
  [<c0757238>] device_unregister+0x28/0x60
  [<f800a068>] ? ses_intf_remove+0x58/0xb0 [ses]
  [<c068f46b>] ? list_del+0xb/0x20
  [<fc96e503>] enclosure_unregister+0x53/0x80 [enclosure]
  [<f800a077>] ses_intf_remove+0x67/0xb0 [ses]
  [<c075714d>] device_del+0x9d/0x160
  [<c0757231>] device_unregister+0x21/0x60
  [<c06702ae>] ? bsg_kref_release_function+0x1e/0x30
  [<c067068d>] ? bsg_unregister_queue+0x7d/0x90
  [<c077d903>] __scsi_remove_device+0x93/0xb0
  [<c077d946>] scsi_remove_device+0x26/0x40
  [<c077daa0>] scsi_remove_target+0x120/0x1b0
  [<f820ed6f>] sas_rphy_remove+0x4f/0x60 [scsi_transport_sas]
  [<f8210380>] sas_rphy_delete+0x10/0x20 [scsi_transport_sas]
  [<f82103af>] sas_port_delete+0x1f/0xf0 [scsi_transport_sas]
  [<c0756280>] ? klist_children_put+0x10/0x20
  [<c0958c93>] ? klist_next+0x73/0xe0
  [<f8210480>] ? sas_port_delete+0xf0/0xf0 [scsi_transport_sas]
  [<f82104c5>] do_sas_phy_delete+0x45/0x50 [scsi_transport_sas]
  [<c075653c>] device_for_each_child+0x2c/0x60
  [<f820ed07>] sas_remove_children+0x17/0x30 [scsi_transport_sas]
  [<f820ed65>] sas_rphy_remove+0x45/0x60 [scsi_transport_sas]
  [<f8210380>] sas_rphy_delete+0x10/0x20 [scsi_transport_sas]
  [<f82103af>] sas_port_delete+0x1f/0xf0 [scsi_transport_sas]
  [<f820ecdb>] ? sas_port_delete_phy+0x5b/0x70 [scsi_transport_sas]
  [<f83db69b>] mpt3sas_transport_port_remove+0x1bb/0x220 [mpt3sas]
  [<f83d52ce>] _scsih_expander_node_remove+0x9e/0xf0 [mpt3sas]
  [<f83d5217>] mpt3sas_expander_remove+0xa7/0xc0 [mpt3sas]
  [<f83e24da>] _scsih_remove+0x14a/0x1b8 [mpt3sas]
  [<c097d5d3>] ? notifier_call_chain+0x43/0x60
  [<c06a6bbf>] pci_device_remove+0x2f/0xe0
  [<c0759c0f>] __device_release_driver+0x5f/0xb0
  [<c075a697>] driver_detach+0x87/0x90
  [<c0759ab3>] bus_remove_driver+0x73/0xe0
  [<c0744647>] ? misc_deregister+0x57/0x90
  [<c075ab09>] driver_unregister+0x49/0x80
  [<c06a6675>] pci_unregister_driver+0x35/0x80
  [<f83e2571>] _scsih_exit+0x29/0xab8 [mpt3sas]
  [<c04a804a>] sys_delete_module+0x13a/0x2b0
  [<c04bd52c>] ? __audit_syscall_entry+0xbc/0x290
  [<c0980cdf>] sysenter_do_call+0x12/0x28

Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sreekanth.Reddy@lsi.com
---
 drivers/misc/enclosure.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 0e8df41..b368eed 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -199,8 +199,10 @@ static void enclosure_remove_links(struct enclosure_component *cdev)
 	char name[ENCLOSURE_NAME_SIZE];
 
 	enclosure_link_name(cdev, name);
-	sysfs_remove_link(&cdev->dev->kobj, name);
-	sysfs_remove_link(&cdev->cdev.kobj, "device");
+	if (cdev->dev->kobj.sd)
+		sysfs_remove_link(&cdev->dev->kobj, name);
+	if (cdev->cdev.kobj.sd)
+		sysfs_remove_link(&cdev->cdev.kobj, "device");
 }
 
 static int enclosure_add_links(struct enclosure_component *cdev)
-- 
1.7.3



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbbABTsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 14:48:04 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40961 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbbABTsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 14:48:00 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org (open list:VIRTIO CORE,
	NET...)
Subject: [PATCH 1/2] virtio_pci: double free and invalid memory access of device vqs
Date: Fri,  2 Jan 2015 14:47:39 -0500
Message-Id: <1420228060-18721-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device VQs were getting freed twice: once in every devices removal functions,
and then again in virtio_pci_legacy_remove().

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/virtio/virtio_pci_legacy.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
index 6c76f0f..913ca23 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -298,7 +298,6 @@ void virtio_pci_legacy_remove(struct pci_dev *pci_dev)
 
 	unregister_virtio_device(&vp_dev->vdev);
 
-	vp_del_vqs(&vp_dev->vdev);
 	pci_iounmap(pci_dev, vp_dev->ioaddr);
 	pci_release_regions(pci_dev);
 	pci_disable_device(pci_dev);
-- 
1.7.10.4


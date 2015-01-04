Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbbADQCl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 11:02:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbbADQCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 11:02:36 -0500
Date: Sun, 4 Jan 2015 18:02:27 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: sasha.levin@oracle.com, virtualization@lists.linux-foundation.org,
        stable@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3/3] virtio_pci: document why we defer kfree
Message-ID: <1420386340-7719-4-git-send-email-mst@redhat.com>
References: <1420386340-7719-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420386340-7719-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reason we defer kfree until release function is because it's a
general rule for kobjects: kfree of the reference counter itself is only
legal in the release function.

Previous patch didn't make this clear, document this in code.

Cc: stable@vger.kernel.org
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_pci_legacy.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
index 4beaee3..a5486e6 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -216,6 +216,9 @@ static void virtio_pci_release_dev(struct device *_d)
 	struct virtio_device *vdev = dev_to_virtio(_d);
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 
+	/* As struct device is a kobject, it's not safe to
+	 * free the memory (including the reference counter itself)
+	 * until it's release callback. */
 	kfree(vp_dev);
 }
 
-- 
MST


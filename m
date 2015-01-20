Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbbATQ0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:26:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313AbbATQZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:25:17 -0500
Date: Tue, 20 Jan 2015 18:25:10 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kraxel@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 02/05] fixup! virtio_pci: modern driver
Message-ID: <1421771093-1589-3-git-send-email-mst@redhat.com>
References: <1421771093-1589-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421771093-1589-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio modern: fix up fallback logic

This bails out if modern driver succeeds - not what we wanted.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_pci_common.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 20c7638..8ae34a3 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -506,10 +506,8 @@ static int virtio_pci_probe(struct pci_dev *pci_dev,
 		goto err_request_regions;
 
 	rc = virtio_pci_modern_probe(vp_dev);
-	if (rc != -ENODEV)
-		return rc;
-
-	rc = virtio_pci_legacy_probe(vp_dev);
+	if (rc == -ENODEV)
+		rc = virtio_pci_legacy_probe(vp_dev);
 	if (rc)
 		goto err_probe;
 
-- 
MST


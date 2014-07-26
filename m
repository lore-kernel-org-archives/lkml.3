Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbaGZOYo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:24:44 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:58733 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaGZOYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:24:43 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] rpmsg: virtio_rpmsg_bus.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:26:09 +0200
Message-Id: <1406384769-2692-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/rpmsg/virtio_rpmsg_bus.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index b6135d4..f5772e1 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -383,7 +383,7 @@ static int rpmsg_dev_probe(struct device *dev)
 			virtio_has_feature(vrp->vdev, VIRTIO_RPMSG_F_NS)) {
 		struct rpmsg_ns_msg nsm;
 
-		strncpy(nsm.name, rpdev->id.name, RPMSG_NAME_SIZE);
+		strlcpy(nsm.name, rpdev->id.name, RPMSG_NAME_SIZE);
 		nsm.addr = rpdev->src;
 		nsm.flags = RPMSG_NS_CREATE;
 
@@ -408,7 +408,7 @@ static int rpmsg_dev_remove(struct device *dev)
 			virtio_has_feature(vrp->vdev, VIRTIO_RPMSG_F_NS)) {
 		struct rpmsg_ns_msg nsm;
 
-		strncpy(nsm.name, rpdev->id.name, RPMSG_NAME_SIZE);
+		strlcpy(nsm.name, rpdev->id.name, RPMSG_NAME_SIZE);
 		nsm.addr = rpdev->src;
 		nsm.flags = RPMSG_NS_DESTROY;
 
@@ -526,7 +526,7 @@ static struct rpmsg_channel *rpmsg_create_channel(struct virtproc_info *vrp,
 	 */
 	rpdev->announce = rpdev->src != RPMSG_ADDR_ANY ? true : false;
 
-	strncpy(rpdev->id.name, chinfo->name, RPMSG_NAME_SIZE);
+	strlcpy(rpdev->id.name, chinfo->name, RPMSG_NAME_SIZE);
 
 	/* very simple device indexing plumbing which is enough for now */
 	dev_set_name(&rpdev->dev, "rpmsg%d", rpmsg_dev_index++);
@@ -925,7 +925,7 @@ static void rpmsg_ns_cb(struct rpmsg_channel *rpdev, void *data, int len,
 			msg->flags & RPMSG_NS_DESTROY ? "destroy" : "creat",
 			msg->name, msg->addr);
 
-	strncpy(chinfo.name, msg->name, sizeof(chinfo.name));
+	strlcpy(chinfo.name, msg->name, sizeof(chinfo.name));
 	chinfo.src = RPMSG_ADDR_ANY;
 	chinfo.dst = msg->addr;
 
-- 
1.7.10.4


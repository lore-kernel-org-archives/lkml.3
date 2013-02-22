Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab3BVGHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 01:07:00 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45894 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3BVGG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 01:06:57 -0500
Date: Fri, 22 Feb 2013 09:05:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: open list <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: [patch] remoteproc: off by one in rproc_virtio_new_vringh()
Message-ID: <20130222060159.GA15816@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be >= ARRAY_SIZE() instead of > ARRAY_SIZE() because it
is an index.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index dba33ff..b5e3af5 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -208,7 +208,7 @@ rproc_virtio_new_vringh(struct virtio_device *vdev, unsigned index,
 	struct vringh *vrh;
 	int err;
 
-	if (index > ARRAY_SIZE(rvdev->vring)) {
+	if (index >= ARRAY_SIZE(rvdev->vring)) {
 		dev_err(&rvdev->vdev.dev, "bad vring index: %d\n", index);
 		return NULL;
 	}

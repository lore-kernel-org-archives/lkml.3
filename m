Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab3BOTMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:12:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab3BOTMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:12:19 -0500
Subject: [PATCH] vfio: whitelist pcieport
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Fri, 15 Feb 2013 12:12:18 -0700
Message-ID: <20130215191203.27350.76040.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcieport does nice things like manage AER and we know it doesn't do
DMA or expose any user accessible devices on the host.  It also keeps
the Memory, I/O, and Busmaster bits enabled, which is pretty handy
when trying to use anyting below it.  Devices owned by pcieport cannot
be given to users via vfio, but we can tolerate them not being owned
by vfio-pci.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 8e6dcec..28e2d5b 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -442,7 +442,7 @@ static struct vfio_device *vfio_group_get_device(struct vfio_group *group,
  * a device.  It's not always practical to leave a device within a group
  * driverless as it could get re-bound to something unsafe.
  */
-static const char * const vfio_driver_whitelist[] = { "pci-stub" };
+static const char * const vfio_driver_whitelist[] = { "pci-stub", "pcieport" };
 
 static bool vfio_whitelisted_driver(struct device_driver *drv)
 {


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3HVRTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 13:19:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571Ab3HVRTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 13:19:21 -0400
Subject: [PATCH] vfio: Add O_CLOEXEC flag to vfio device fd
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: aik@ozlabs.ru, benh@kernel.crashing.org, ydroneaud@opteya.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Thu, 22 Aug 2013 11:19:10 -0600
Message-ID: <20130822171744.1297.13711.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the default O_CLOEXEC flag for device file descriptors.  This is
generally considered a safer option as it allows the user a race free
option to decide whether file descriptors are inherited across exec,
with the default avoiding file descriptor leaks.

Reported-by: Yann Droneaud <ydroneaud@opteya.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 75c16cc..1eab4ac 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1109,7 +1109,7 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 		 * We can't use anon_inode_getfd() because we need to modify
 		 * the f_mode flags directly to allow more than just ioctls
 		 */
-		ret = get_unused_fd_flags(0);
+		ret = get_unused_fd_flags(O_CLOEXEC);
 		if (ret < 0) {
 			device->ops->release(device->device_data);
 			break;


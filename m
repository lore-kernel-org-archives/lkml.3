Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbaKLBYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:24:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbaKLBYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:24:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH 3.17 074/319] UBI: Dispatch update notification if the volume is updated
Date: Wed, 12 Nov 2014 10:13:32 +0900
Message-Id: <20141112011004.833588310@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

commit fda322a1b3b9e8ee231913c500f73c6988b1aff5 upstream.

The UBI_IOCVOLUP ioctl is used to start an update and also to
truncate a volume. In the first case, a "volume updated" notification
is dispatched when the update is done.

This commit adds the "volume updated" notification to be also sent when
the volume is truncated. This is required for UBI block and gluebi to get
notified about the new volume size.

Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/ubi/cdev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -425,8 +425,10 @@ static long vol_cdev_ioctl(struct file *
 			break;
 
 		err = ubi_start_update(ubi, vol, bytes);
-		if (bytes == 0)
+		if (bytes == 0) {
+			ubi_volume_notify(ubi, vol, UBI_VOLUME_UPDATED);
 			revoke_exclusive(desc, UBI_READWRITE);
+		}
 		break;
 	}
 



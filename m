Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab3K0QvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:51:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:1373 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756809Ab3K0QvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:51:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,783,1378882800"; 
   d="scan'208";a="443137816"
From: Ashutosh Dixit <ashutosh.dixit@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Siva Krishna Kumar Reddy Yerramreddy 
	<siva.krishna.kumar.reddy.yerramreddy@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>
Subject: [PATCH char-misc-linus v3 1/6] misc: mic: Change mic_notify(...) to return true.
Date: Wed, 27 Nov 2013 08:58:38 -0800
Message-Id: <100078a1f4e7f56ef9dc1c4a51c8165a2e090de9.1385569514.git.ashutosh.dixit@intel.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1385527468.git.ashutosh.dixit@intel.com>
References: <cover.1385527468.git.ashutosh.dixit@intel.com>
In-Reply-To: <cover.1385569514.git.ashutosh.dixit@intel.com>
References: <cover.1385569514.git.ashutosh.dixit@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudeep Dutt <sudeep.dutt@intel.com>

virtqueue_{kick()/notify()} methods are required to return bool due to
API changes introduced in commit 5b1bf7cb673a.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
---
 drivers/misc/mic/card/mic_virtio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mic/card/mic_virtio.c b/drivers/misc/mic/card/mic_virtio.c
index 8aa42e7..1ebc51c 100644
--- a/drivers/misc/mic/card/mic_virtio.c
+++ b/drivers/misc/mic/card/mic_virtio.c
@@ -187,11 +187,12 @@ static void mic_reset(struct virtio_device *vdev)
 /*
  * The virtio_ring code calls this API when it wants to notify the Host.
  */
-static void mic_notify(struct virtqueue *vq)
+static bool mic_notify(struct virtqueue *vq)
 {
 	struct mic_vdev *mvdev = vq->priv;
 
 	mic_send_intr(mvdev->mdev, mvdev->c2h_vdev_db);
+	return true;
 }
 
 static void mic_del_vq(struct virtqueue *vq, int n)
-- 
1.8.2.3


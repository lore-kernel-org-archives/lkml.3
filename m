Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933928AbaLBTds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:33:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46978 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933624AbaLBT0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:26:43 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars-Peter Clausen <lars@metafoo.de>, Jonathan Cameron <jic23@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 033/121] staging:iio:ade7758: Fix check if channels are enabled in prenable
Date: Tue,  2 Dec 2014 11:18:32 -0800
Message-Id: <1417548000-1794-34-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 79fa64eb2ee8ccb4bcad7f54caa2699730b10b22 upstream.

We should check if a channel is enabled, not if no channels are enabled.

Fixes: 550268ca1111 ("staging:iio: scrap scan_count and ensure all drivers use active_scan_mask")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/iio/meter/ade7758_ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/iio/meter/ade7758_ring.c b/drivers/staging/iio/meter/ade7758_ring.c
index 628e902..6e90064 100644
--- a/drivers/staging/iio/meter/ade7758_ring.c
+++ b/drivers/staging/iio/meter/ade7758_ring.c
@@ -87,7 +87,7 @@ static int ade7758_ring_preenable(struct iio_dev *indio_dev)
 {
 	unsigned channel;
 
-	if (!bitmap_empty(indio_dev->active_scan_mask, indio_dev->masklength))
+	if (bitmap_empty(indio_dev->active_scan_mask, indio_dev->masklength))
 		return -EINVAL;
 
 	channel = find_first_bit(indio_dev->active_scan_mask,
-- 
1.9.1


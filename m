Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaKYKkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:40:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58119 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaKYKkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars-Peter Clausen <lars@metafoo.de>, Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 033/254] staging:iio:ade7758: Fix check if channels are enabled in prenable
Date: Tue, 25 Nov 2014 10:36:23 +0000
Message-Id: <1416912004-5928-34-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 79fa64eb2ee8ccb4bcad7f54caa2699730b10b22 upstream.

We should check if a channel is enabled, not if no channels are enabled.

Fixes: 550268ca1111 ("staging:iio: scrap scan_count and ensure all drivers use active_scan_mask")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/iio/meter/ade7758_ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/iio/meter/ade7758_ring.c b/drivers/staging/iio/meter/ade7758_ring.c
index 628e902dd815..6e9006490742 100644
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
2.1.0


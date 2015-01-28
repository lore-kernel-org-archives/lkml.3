Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965176AbbA1EY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:24:58 -0500
Received: from mail.kernel.org ([198.145.29.136]:40843 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934488AbbA1EYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:24:49 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 137/177] staging:iio:ade7758: Fix check if channels are enabled in prenable
Date: Wed, 28 Jan 2015 12:09:55 +0800
Message-Id: <1422418236-12852-228-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 79fa64eb2ee8ccb4bcad7f54caa2699730b10b22 upstream.

We should check if a channel is enabled, not if no channels are enabled.

Fixes: 550268ca1111 ("staging:iio: scrap scan_count and ensure all drivers use active_scan_mask")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/staging/iio/meter/ade7758_ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/iio/meter/ade7758_ring.c b/drivers/staging/iio/meter/ade7758_ring.c
index c45b23b..629a6ed 100644
--- a/drivers/staging/iio/meter/ade7758_ring.c
+++ b/drivers/staging/iio/meter/ade7758_ring.c
@@ -96,7 +96,7 @@ static int ade7758_ring_preenable(struct iio_dev *indio_dev)
 	size_t d_size;
 	unsigned channel;
 
-	if (!bitmap_empty(indio_dev->active_scan_mask, indio_dev->masklength))
+	if (bitmap_empty(indio_dev->active_scan_mask, indio_dev->masklength))
 		return -EINVAL;
 
 	channel = find_first_bit(indio_dev->active_scan_mask,
-- 
1.9.1


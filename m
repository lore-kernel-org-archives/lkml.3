Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbaKROmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:42:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57207 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755008AbaKROKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:06 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 141/206] staging:iio:ade7758: Fix check if channels are enabled in prenable
Date: Tue, 18 Nov 2014 15:08:16 +0100
Message-Id: <4cf866e11cf4f921a0ac20f696031cdf24b2281b.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 79fa64eb2ee8ccb4bcad7f54caa2699730b10b22 upstream.

We should check if a channel is enabled, not if no channels are enabled.

Fixes: 550268ca1111 ("staging:iio: scrap scan_count and ensure all drivers use active_scan_mask")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/staging/iio/meter/ade7758_ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/iio/meter/ade7758_ring.c b/drivers/staging/iio/meter/ade7758_ring.c
index 6590944a6678..46eb15d25d4b 100644
--- a/drivers/staging/iio/meter/ade7758_ring.c
+++ b/drivers/staging/iio/meter/ade7758_ring.c
@@ -92,7 +92,7 @@ static int ade7758_ring_preenable(struct iio_dev *indio_dev)
 	unsigned channel;
 	int ret;
 
-	if (!bitmap_empty(indio_dev->active_scan_mask, indio_dev->masklength))
+	if (bitmap_empty(indio_dev->active_scan_mask, indio_dev->masklength))
 		return -EINVAL;
 
 	ret = iio_sw_buffer_preenable(indio_dev);
-- 
2.1.3


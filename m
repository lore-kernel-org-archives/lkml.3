Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbaKKLnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:43:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57562 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbaKKLK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Robin van der Gracht <robin@protonic.nl>,
        Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 091/170] iio: st_sensors: Fix buffer copy
Date: Tue, 11 Nov 2014 11:07:30 +0000
Message-Id: <1415704129-12709-92-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin van der Gracht <robin@protonic.nl>

commit 4250c90b30b8bf2a1a21122ba0484f8f351f152d upstream.

Use byte_for_channel as iterator to properly initialize the buffer.

Signed-off-by: Robin van der Gracht <robin@protonic.nl>
Acked-by: Denis Ciocca <denis.ciocca@st.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iio/common/st_sensors/st_sensors_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/common/st_sensors/st_sensors_buffer.c b/drivers/iio/common/st_sensors/st_sensors_buffer.c
index 1665c8e4b62b..e18bc6782256 100644
--- a/drivers/iio/common/st_sensors/st_sensors_buffer.c
+++ b/drivers/iio/common/st_sensors/st_sensors_buffer.c
@@ -71,7 +71,7 @@ int st_sensors_get_buffer_element(struct iio_dev *indio_dev, u8 *buf)
 				goto st_sensors_free_memory;
 			}
 
-			for (i = 0; i < n * num_data_channels; i++) {
+			for (i = 0; i < n * byte_for_channel; i++) {
 				if (i < n)
 					buf[i] = rx_array[i];
 				else
-- 
2.1.0


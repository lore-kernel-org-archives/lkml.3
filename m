Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaKFWms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:42:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58909 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaKFWmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:42:42 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Robin van der Gracht <robin@protonic.nl>,
        Jonathan Cameron <jic23@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 109/162] iio: st_sensors: Fix buffer copy
Date: Thu,  6 Nov 2014 14:36:13 -0800
Message-Id: <1415313426-9622-110-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin van der Gracht <robin@protonic.nl>

commit 4250c90b30b8bf2a1a21122ba0484f8f351f152d upstream.

Use byte_for_channel as iterator to properly initialize the buffer.

Signed-off-by: Robin van der Gracht <robin@protonic.nl>
Acked-by: Denis Ciocca <denis.ciocca@st.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/iio/common/st_sensors/st_sensors_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/common/st_sensors/st_sensors_buffer.c b/drivers/iio/common/st_sensors/st_sensors_buffer.c
index 1665c8e..e18bc67 100644
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
1.9.1


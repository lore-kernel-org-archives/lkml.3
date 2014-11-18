Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133AbaKROou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:44:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57198 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999AbaKROKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:03 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Robin van der Gracht <robin@protonic.nl>,
        Jonathan Cameron <jic23@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 137/206] iio: st_sensors: Fix buffer copy
Date: Tue, 18 Nov 2014 15:08:12 +0100
Message-Id: <3d375f0ef0a06455f4a9ddac56718f0df1e83a56.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin van der Gracht <robin@protonic.nl>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4250c90b30b8bf2a1a21122ba0484f8f351f152d upstream.

Use byte_for_channel as iterator to properly initialize the buffer.

Signed-off-by: Robin van der Gracht <robin@protonic.nl>
Acked-by: Denis Ciocca <denis.ciocca@st.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/iio/common/st_sensors/st_sensors_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/common/st_sensors/st_sensors_buffer.c b/drivers/iio/common/st_sensors/st_sensors_buffer.c
index 71a2c5f63b9c..af6f2570a55c 100644
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
2.1.3


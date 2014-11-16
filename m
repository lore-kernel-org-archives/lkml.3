Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbaKPMd4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:33:56 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:64711 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755524AbaKPMdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:33:53 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4SAFCZaFRbsk2U/2dsb2JhbABbgw6BLrhMBQF1mg8EAoEKFwEBAQEBfYQwLyOBGjeIRQHAbI8+LIY+igBkHYQ1BZ5MlnqBRwGCNTwwgQaBRQEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-iio@vger.kernel.org
Subject: [PATCH 1/1 linux-next] iio: common: remove unnecessary sizeof(u8)
Date: Sun, 16 Nov 2014 13:33:24 +0100
Message-Id: <1416141204-19989-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizeof(u8) is always 1.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/iio/common/st_sensors/st_sensors_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/common/st_sensors/st_sensors_spi.c b/drivers/iio/common/st_sensors/st_sensors_spi.c
index 78a6a1a..5b37737 100644
--- a/drivers/iio/common/st_sensors/st_sensors_spi.c
+++ b/drivers/iio/common/st_sensors/st_sensors_spi.c
@@ -54,7 +54,7 @@ static int st_sensors_spi_read(struct st_sensor_transfer_buffer *tb,
 	if (err)
 		goto acc_spi_read_error;
 
-	memcpy(data, tb->rx_buf, len*sizeof(u8));
+	memcpy(data, tb->rx_buf, len);
 	mutex_unlock(&tb->buf_lock);
 	return len;
 
-- 
1.9.3


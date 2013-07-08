Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab3GHNns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:43:48 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43381 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab3GHNnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:43:46 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <broonie@kernel.org>, <spi-devel-general@lists.sourceforge.net>,
        <grant.likely@linaro.org>
CC: <balbi@ti.com>, <rnayak@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sourav Poddar <sourav.poddar@ti.com>
Subject: [RFC/PATCH 1/3] driver: spi: Modify core to compute the message length
Date: Mon, 8 Jul 2013 19:12:58 +0530
Message-ID: <1373290980-17883-2-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1373290980-17883-1-git-send-email-sourav.poddar@ti.com>
References: <1373290980-17883-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make spi core calculate the message length while
populating the other transfer parameters. This will
be useful in cases where controller driver need to configure its 
framelength field without iterating through the linklist again in the
driver controller.

Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
 drivers/spi/spi.c       |    1 +
 include/linux/spi/spi.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 32b7bb1..6a05b3c 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1375,6 +1375,7 @@ static int __spi_async(struct spi_device *spi, struct spi_message *message)
 	 * it is not set for this transfer.
 	 */
 	list_for_each_entry(xfer, &message->transfers, transfer_list) {
+		message->frame_length += xfer->len;
 		if (!xfer->bits_per_word)
 			xfer->bits_per_word = spi->bits_per_word;
 		if (!xfer->speed_hz)
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 6ff26c8..d83841e 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -575,6 +575,7 @@ struct spi_message {
 	/* completion is reported through a callback */
 	void			(*complete)(void *context);
 	void			*context;
+	unsigned		frame_length;
 	unsigned		actual_length;
 	int			status;
 
-- 
1.7.1


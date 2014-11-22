Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaKVPZT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 10:25:19 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53899 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaKVPYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 10:24:20 -0500
From: Beniamino Galvani <b.galvani@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, Carlo Caione <carlo@caione.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v3 1/4] spi: core: Add spi_transfer_is_last() helper
Date: Sat, 22 Nov 2014 16:21:39 +0100
Message-Id: <1416669702-7841-2-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416669702-7841-1-git-send-email-b.galvani@gmail.com>
References: <1416669702-7841-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the function spi_transfer_is_last() which can be used by
drivers to know whether a given transfer is the last one in the
current message.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 include/linux/spi/spi.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 46d188a..a6ef2a8 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -1049,4 +1049,10 @@ spi_unregister_device(struct spi_device *spi)
 extern const struct spi_device_id *
 spi_get_device_id(const struct spi_device *sdev);
 
+static inline bool
+spi_transfer_is_last(struct spi_master *master, struct spi_transfer *xfer)
+{
+	return list_is_last(&xfer->transfer_list, &master->cur_msg->transfers);
+}
+
 #endif /* __LINUX_SPI_H */
-- 
1.9.1


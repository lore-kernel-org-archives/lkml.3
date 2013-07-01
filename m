Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab3GAOU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:20:56 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:41500 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3GAOUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:20:53 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] iio: Fix iio_channel_has_info
Date: Mon,  1 Jul 2013 16:20:30 +0200
Message-Id: <1372688430-13120-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the info_mask split, iio_channel_has_info() is not working correctly.
info_mask_separate and info_mask_shared_by_type, it is not possible to compare
them directly with the iio_chan_info_enum enum. Correct that bit using the BIT()
macro.

Cc: <stable@vger.kernel.org> # 3.10.x
Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 include/linux/iio/iio.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index 8d171f4..3d35b70 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -211,8 +211,8 @@ struct iio_chan_spec {
 static inline bool iio_channel_has_info(const struct iio_chan_spec *chan,
 	enum iio_chan_info_enum type)
 {
-	return (chan->info_mask_separate & type) |
-	       (chan->info_mask_shared_by_type & type);
+	return (chan->info_mask_separate & BIT(type)) |
+	       (chan->info_mask_shared_by_type & BIT(type));
 }
 
 #define IIO_ST(si, rb, sb, sh)						\
-- 
1.8.1.2


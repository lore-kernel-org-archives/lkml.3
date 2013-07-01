Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab3GAQk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:40:27 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:42324 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab3GAQkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:40:25 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] iio: inkern: fix iio_convert_raw_to_processed_unlocked
Date: Mon,  1 Jul 2013 18:40:09 +0200
Message-Id: <1372696809-14661-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When reading IIO_CHAN_INFO_OFFSET, the return value of iio_channel_read() for
success will be IIO_VAL*, checking for 0 is not correct.

Cc: <stable@vger.kernel.org> # 3.10.x
Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/iio/inkern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index 98ddc32..0cf5f8e 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -451,7 +451,7 @@ static int iio_convert_raw_to_processed_unlocked(struct iio_channel *chan,
 	int ret;
 
 	ret = iio_channel_read(chan, &offset, NULL, IIO_CHAN_INFO_OFFSET);
-	if (ret == 0)
+	if (ret >= 0)
 		raw64 += offset;
 
 	scale_type = iio_channel_read(chan, &scale_val, &scale_val2,
-- 
1.8.1.2


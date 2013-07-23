Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934579Ab3GWW1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:27:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41535 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934533Ab3GWW1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [ 025/103] iio: inkern: fix iio_convert_raw_to_processed_unlocked
Date: Tue, 23 Jul 2013 15:25:36 -0700
Message-Id: <20130723220421.371969200@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Belloni <alexandre.belloni@free-electrons.com>

commit f91d1b63a4e096d3023aaaafec9d9d3aff25997f upstream.

When reading IIO_CHAN_INFO_OFFSET, the return value of iio_channel_read() for
success will be IIO_VAL*, checking for 0 is not correct.

Without this fix the offset applied by iio drivers will be ignored when
converting a raw value to one in appropriate base units (e.g mV) in
a IIO client drivers that use iio_convert_raw_to_processed including
iio-hwmon.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/inkern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -451,7 +451,7 @@ static int iio_convert_raw_to_processed_
 	int ret;
 
 	ret = iio_channel_read(chan, &offset, NULL, IIO_CHAN_INFO_OFFSET);
-	if (ret == 0)
+	if (ret >= 0)
 		raw64 += offset;
 
 	scale_type = iio_channel_read(chan, &scale_val, &scale_val2,



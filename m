Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965066AbaFSVEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:04:06 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:52699 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933503AbaFSVEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:04:02 -0400
Message-ID: <53A35062.7070705@gmail.com>
Date: Thu, 19 Jun 2014 23:04:34 +0200
From: Federico Di Pierro <nierro92@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>, gregkh@linuxfoundation.org,
        jg1.han@samsung.com, sachin.kamat@linaro.org
CC: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: iio: kernel style neatening
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
I've finally found some spare time from my studies to sit back and try 
again this eudyptula challenge task.
This is a very small patch that fixes 3 little coding style problems.
I'm using linux-next.

Signed-off-by: Federico Di Pierro <nierro92@gmail.org>

--- linux/drivers/staging/iio/frequency/ad9832.c.orig	2014-06-02 
17:26:12.929978122 +0200
+++ linux/drivers/staging/iio/frequency/ad9832.c	2014-06-02 
19:34:57.129506826 +0200
@@ -57,7 +57,7 @@ static int ad9832_write_frequency(struct
  }

  static int ad9832_write_phase(struct ad9832_state *st,
-				  unsigned long addr, unsigned long phase)
+			      unsigned long addr, unsigned long phase)
  {
  	if (phase > (1 << AD9832_PHASE_BITS))
  		return -EINVAL;
@@ -72,10 +72,8 @@ static int ad9832_write_phase(struct ad9
  	return spi_sync(st->spi, &st->phase_msg);
  }

-static ssize_t ad9832_write(struct device *dev,
-		struct device_attribute *attr,
-		const char *buf,
-		size_t len)
+static ssize_t ad9832_write(struct device *dev, struct device_attribute 
*attr,
+			    const char *buf,size_t len)
  {
  	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
  	struct ad9832_state *st = iio_priv(indio_dev);
@@ -109,11 +107,11 @@ static ssize_t ad9832_write(struct devic
  		ret = spi_sync(st->spi, &st->msg);
  		break;
  	case AD9832_FREQ_SYM:
-		if (val == 1)
+		if (val == 1) {
  			st->ctrl_fp |= AD9832_FREQ;
-		else if (val == 0)
+		} else if (val == 0) {
  			st->ctrl_fp &= ~AD9832_FREQ;
-		else {
+		} else {
  			ret = -EINVAL;
  			break;
  		}

-- 
Federico

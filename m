Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035AbbA0V3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:29:13 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:55264 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759836AbbA0V3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:29:12 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joel Porquet <joel@porquet.org>,
        Darshana Padmadas <darshanapadmadas@gmail.com>,
        Catalina Mocanu <catalina.mocanu@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: iio: trigger: iio-trig-periodic-rtc: Change type in printf format string
Date: Tue, 27 Jan 2015 22:32:28 +0100
Message-Id: <1422394348-8057-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrong type in printf format string, requires 'unsigned int'
but the argument type is 'int'

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/iio/trigger/iio-trig-periodic-rtc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/iio/trigger/iio-trig-periodic-rtc.c b/drivers/staging/iio/trigger/iio-trig-periodic-rtc.c
index a24caf7..66d54a0 100644
--- a/drivers/staging/iio/trigger/iio-trig-periodic-rtc.c
+++ b/drivers/staging/iio/trigger/iio-trig-periodic-rtc.c
@@ -52,7 +52,7 @@ static ssize_t iio_trig_periodic_read_freq(struct device *dev,
 	struct iio_trigger *trig = to_iio_trigger(dev);
 	struct iio_prtc_trigger_info *trig_info = iio_trigger_get_drvdata(trig);
 
-	return sprintf(buf, "%u\n", trig_info->frequency);
+	return sprintf(buf, "%d\n", trig_info->frequency);
 }
 
 static ssize_t iio_trig_periodic_write_freq(struct device *dev,
-- 
1.7.10.4


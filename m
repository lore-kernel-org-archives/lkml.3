Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbaD2Fzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 01:55:54 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:44798 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbaD2Fzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 01:55:52 -0400
Date: Tue, 29 Apr 2014 13:55:44 +0800
From: Jimmy Li <coder.liss@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jingoo Han <jg1.han@samsung.com>, Lars-Peter Clausen <lars@metafoo.de>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Monam Agarwal <monamagarwal123@gmail.com>
Cc: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging:iio:ad2s1210 fix a leak when device removed
Message-ID: <20140429055544.GA23599@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jimmy Li <coder.liss@gmail.com>
---
 drivers/staging/iio/resolver/ad2s1210.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/iio/resolver/ad2s1210.c b/drivers/staging/iio/resolver/ad2s1210.c
index 7fbaba4..3d6e123 100644
--- a/drivers/staging/iio/resolver/ad2s1210.c
+++ b/drivers/staging/iio/resolver/ad2s1210.c
@@ -716,6 +716,7 @@ static int ad2s1210_remove(struct spi_device *spi)
 
 	iio_device_unregister(indio_dev);
 	ad2s1210_free_gpios(iio_priv(indio_dev));
+	devm_iio_device_free(&spi->dev, indio_dev);
 
 	return 0;
 }
-- 
1.7.9.5


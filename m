Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbaKYMA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:00:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58109 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaKYKkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: George McCollister <george.mccollister@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 031/254] iio: as3935: allocate correct iio_device size
Date: Tue, 25 Nov 2014 10:36:21 +0000
Message-Id: <1416912004-5928-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: George McCollister <george.mccollister@gmail.com>

commit f73cde600d410ad4b31362a9c348016e40a146ea upstream.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
Acked-by: Hartmut Knaack <knaack.h@gmx.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iio/proximity/as3935.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/proximity/as3935.c b/drivers/iio/proximity/as3935.c
index bf677bfe8eb2..d102210b207d 100644
--- a/drivers/iio/proximity/as3935.c
+++ b/drivers/iio/proximity/as3935.c
@@ -330,7 +330,7 @@ static int as3935_probe(struct spi_device *spi)
 		return -EINVAL;
 	}
 
-	indio_dev = devm_iio_device_alloc(&spi->dev, sizeof(st));
+	indio_dev = devm_iio_device_alloc(&spi->dev, sizeof(*st));
 	if (!indio_dev)
 		return -ENOMEM;
 
-- 
2.1.0


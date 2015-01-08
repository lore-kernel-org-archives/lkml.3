Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbbAHQky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 11:40:54 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59755 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752AbbAHQkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 11:40:51 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-76-54aeb3121770
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>, Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH 2/2] iio: Deselect IIO_TRIGGER for IIO_KFIFO_BUF
Date: Thu, 08 Jan 2015 17:40:27 +0100
Message-id: <1420735227-21091-3-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420735227-21091-1-git-send-email-k.wrona@samsung.com>
References: <1420735227-21091-1-git-send-email-k.wrona@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e/4FV2hzetCDCa9lLXYOGM9q8WDplVM
	FqeW7Wey2PX/DbPF2aY37BZLJs9ntZh35B2LxeVdc9gsfu86xm6xZ90WJgcuj52z7rJ7fPgY
	57FpVSebx5I3h1g9zjcfYfTo27KK0ePzJrkA9igum5TUnMyy1CJ9uwSujFN3xAu2slYcud/M
	1MC4kqWLkZNDQsBE4tL3b2wQtpjEhXvrgWwuDiGBpYwSb5r/MEI4fUwS028+YgepYhNQl2je
	sZgZJCEicIFR4vihLSwgDrPAGkaJM2cngFUJCzhI7Ll6C2wHi4CqxOVFE8FsXgFnid5vIJM4
	gPYpSMyZZAMS5hRwkXh55QRYWAioZPMfnwmMvAsYGVYxiqaWJhcUJ6XnGukVJ+YWl+al6yXn
	525ihATh1x2MS49ZHWIU4GBU4uH9cH9tiBBrYllxZe4hRgkOZiURXh3PdSFCvCmJlVWpRfnx
	RaU5qcWHGJk4OKUaGGNN3/gZerCFFnl2VsW0PXsdkH3qzUs1q5a4IItuS66um7sF2a6vkdys
	ukNo6j35A5WMT2ZtvX7P9YnRjuRKw3z1tpDrF2Zt3m1xICwqbu2Xva3VB7dUF19/n/jq6ATx
	1hfvkm7c6JW7Pr1H+8+Px4wr7sx7vGPP5pozvcv3LKyt0eUp1opjUFBiKc5INNRiLipOBAD+
	KtXaIAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iio kfifo can be used without trigger support so there is no need to build it.

Signed-off-by: Karol Wrona <k.wrona@samsung.com>
---
 drivers/iio/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
index 50f6599..dfda2c3 100644
--- a/drivers/iio/Kconfig
+++ b/drivers/iio/Kconfig
@@ -27,7 +27,6 @@ boolean "IIO callback buffer used for push in-kernel interfaces"
 	  usage.  That is, those where the data is pushed to the consumer.
 
 config IIO_KFIFO_BUF
-	select IIO_TRIGGER
 	tristate "Industrial I/O buffering based on kfifo"
 	help
 	  A simple fifo based on kfifo.  Note that this currently provides
-- 
1.7.9.5


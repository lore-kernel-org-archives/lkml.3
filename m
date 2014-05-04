Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbaEDQsH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:48:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35967 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbaEDPlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kevin Tsai <ktsai@capellamicro.com>,
        Beomho Seo <beomho.seo@samsung.com>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.14 067/158] iio: cm32181: Fix read integration time function
Date: Sun,  4 May 2014 11:39:36 -0400
Message-Id: <20140504154039.036484719@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Beomho Seo <beomho.seo@samsung.com>

commit 41c897f8789d0d1039ed873ddcd0caabd5756e0f upstream.

In read integration time function, assign 0 to val.
Because, prevent return inaccurate value when call read integration time.

Cc: Kevin Tsai <ktsai@capellamicro.com>
Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/light/cm32181.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/light/cm32181.c
+++ b/drivers/iio/light/cm32181.c
@@ -221,6 +221,7 @@ static int cm32181_read_raw(struct iio_d
 		*val = cm32181->calibscale;
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_INT_TIME:
+		*val = 0;
 		ret = cm32181_read_als_it(cm32181, val2);
 		return ret;
 	}



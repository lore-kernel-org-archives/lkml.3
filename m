Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaHRJfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:35:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42858 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbaHRJf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:35:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars-Peter Clausen <lars@metafoo.de>, Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 083/137] iio: buffer: Fix demux table creation
Date: Mon, 18 Aug 2014 10:32:24 +0100
Message-Id: <1408354398-10226-84-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 61bd55ce1667809f022be88da77db17add90ea4e upstream.

When creating the demux table we need to iterate over the selected scan mask for
the buffer to get the samples which should be copied to destination buffer.
Right now the code uses the mask which contains all active channels, which means
the demux table contains entries which causes it to copy all the samples from
source to destination buffer one by one without doing any demuxing.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iio/industrialio-buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index 54adea8f0134..45f5c0fd18f5 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -847,7 +847,7 @@ static int iio_buffer_update_demux(struct iio_dev *indio_dev,
 
 	/* Now we have the two masks, work from least sig and build up sizes */
 	for_each_set_bit(out_ind,
-			 indio_dev->active_scan_mask,
+			 buffer->scan_mask,
 			 indio_dev->masklength) {
 		in_ind = find_next_bit(indio_dev->active_scan_mask,
 				       indio_dev->masklength,
-- 
1.9.1


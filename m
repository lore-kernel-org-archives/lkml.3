Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaHTMMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:12:23 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58882 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbaHTLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 014/104] iio: buffer: Fix demux table creation
Date: Wed, 20 Aug 2014 13:42:37 +0200
Message-Id: <8504485d7e3adb86929a240e7e3fafc855c52bc2.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 61bd55ce1667809f022be88da77db17add90ea4e upstream.

When creating the demux table we need to iterate over the selected scan mask for
the buffer to get the samples which should be copied to destination buffer.
Right now the code uses the mask which contains all active channels, which means
the demux table contains entries which causes it to copy all the samples from
source to destination buffer one by one without doing any demuxing.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/iio/industrialio-buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index 376de1cc85db..ae7ac20edf2c 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -876,7 +876,7 @@ static int iio_buffer_update_demux(struct iio_dev *indio_dev,
 
 	/* Now we have the two masks, work from least sig and build up sizes */
 	for_each_set_bit(out_ind,
-			 indio_dev->active_scan_mask,
+			 buffer->scan_mask,
 			 indio_dev->masklength) {
 		in_ind = find_next_bit(indio_dev->active_scan_mask,
 				       indio_dev->masklength,
-- 
2.0.4


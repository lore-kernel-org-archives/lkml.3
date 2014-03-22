Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750934AbaCVF7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 01:59:19 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:35073 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaCVF7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 01:59:17 -0400
Date: Sat, 22 Mar 2014 13:58:58 +0800
From: Jimmy Li <coder.liss@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fix a missing break in devivers/staging/iio
Message-ID: <20140322055858.GA11734@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix a missing break.

Signed-off-by: Jimmy Li <coder.liss@gmail.com>
---
 drivers/staging/iio/resolver/ad2s1200.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/iio/resolver/ad2s1200.c b/drivers/staging/iio/resolver/ad2s1200.c
index 36eedd8..e2b4820 100644
--- a/drivers/staging/iio/resolver/ad2s1200.c
+++ b/drivers/staging/iio/resolver/ad2s1200.c
@@ -70,6 +70,7 @@ static int ad2s1200_read_raw(struct iio_dev *indio_dev,
 		vel = (((s16)(st->rx[0])) << 4) | ((st->rx[1] & 0xF0) >> 4);
 		vel = (vel << 4) >> 4;
 		*val = vel;
+		break;
 	default:
 		mutex_unlock(&st->lock);
 		return -EINVAL;
-- 
1.7.9.5


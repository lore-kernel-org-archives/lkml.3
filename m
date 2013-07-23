Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935026Ab3GWWxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:53:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41528 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934526Ab3GWW1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [ 024/103] iio: Fix iio_channel_has_info
Date: Tue, 23 Jul 2013 15:25:35 -0700
Message-Id: <20130723220421.265515348@linuxfoundation.org>
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

commit 1c297a66654a3295ae87e2b7f3724d214eb2b5ec upstream.

Since the info_mask split, iio_channel_has_info() is not working correctly.
info_mask_separate and info_mask_shared_by_type, it is not possible to compare
them directly with the iio_chan_info_enum enum. Correct that bit using the BIT()
macro.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/iio/iio.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -211,8 +211,8 @@ struct iio_chan_spec {
 static inline bool iio_channel_has_info(const struct iio_chan_spec *chan,
 	enum iio_chan_info_enum type)
 {
-	return (chan->info_mask_separate & type) |
-	       (chan->info_mask_shared_by_type & type);
+	return (chan->info_mask_separate & BIT(type)) |
+	       (chan->info_mask_shared_by_type & BIT(type));
 }
 
 #define IIO_ST(si, rb, sb, sh)						\



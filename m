Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067AbbA0WTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:19:19 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:59470 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264AbbA0WTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:19:17 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: iio: resolver: ad2s1210: Change type in printf format string
Date: Tue, 27 Jan 2015 23:22:34 +0100
Message-Id: <1422397354-9326-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrong type in printf format string, requires 'int'
but the argument type is 'unsigned int'

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/iio/resolver/ad2s1210.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/resolver/ad2s1210.c b/drivers/staging/iio/resolver/ad2s1210.c
index b4c14ba..a8ecf87 100644
--- a/drivers/staging/iio/resolver/ad2s1210.c
+++ b/drivers/staging/iio/resolver/ad2s1210.c
@@ -198,7 +198,7 @@ static ssize_t ad2s1210_show_fclkin(struct device *dev,
 {
 	struct ad2s1210_state *st = iio_priv(dev_to_iio_dev(dev));
 
-	return sprintf(buf, "%d\n", st->fclkin);
+	return sprintf(buf, "%u\n", st->fclkin);
 }
 
 static ssize_t ad2s1210_store_fclkin(struct device *dev,
@@ -237,7 +237,7 @@ static ssize_t ad2s1210_show_fexcit(struct device *dev,
 {
 	struct ad2s1210_state *st = iio_priv(dev_to_iio_dev(dev));
 
-	return sprintf(buf, "%d\n", st->fexcit);
+	return sprintf(buf, "%u\n", st->fexcit);
 }
 
 static ssize_t ad2s1210_store_fexcit(struct device *dev,
-- 
1.7.10.4


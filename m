Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaFEUuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 16:50:07 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:50416 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbaFEUtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 16:49:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH 2/5] staging/iio: IIO_SIMPLE_DUMMY_BUFFER neds IIO_BUFFER
Date: Thu,  5 Jun 2014 22:48:12 +0200
Message-Id: <1402001295-1980118-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402001295-1980118-1-git-send-email-arnd@arndb.de>
References: <1402001295-1980118-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Iekz5lrD8IlhFLI//NxUokYMGWDl5ZxGT5K7WRWhKiy
 pSWQcjnc1+iGJC4TvTSadnUU0gNTZu214VlghghYQOrg60HrXo
 NaLGhcA8iJIPPuBrQGwE0589avVo4+SQ295hB2v+zBq5U9zzkt
 +G3sbcjpEnXuQEMygfyN5lbeIGq3Q9xh5DDeGA2p+L43x9qzfN
 ipYVlevcGWKgEF+CXiBcevyM9FKywoB7SLROoVIAvAn51erRUR
 cubuF8SQZ0My7aBEWxtbwlrHAsC7jik6NAK9KRyhTWSza4A3By
 lzjshLXhH7GDVvJPYmbIK2PKF8o4TT2f8aq7CwDTmDcJYJWrcH
 5Qql97pjWNVgaKFKnvNmV2CaHdfYT/SUCLTLUTaoO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An obviously missing 'select' statement, without this we
get a link error

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio@vger.kernel.org
---
 drivers/staging/iio/Kconfig | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/iio/Kconfig b/drivers/staging/iio/Kconfig
index b36feb0..fa38be0 100644
--- a/drivers/staging/iio/Kconfig
+++ b/drivers/staging/iio/Kconfig
@@ -36,10 +36,11 @@ config IIO_SIMPLE_DUMMY_EVENTS
          Add some dummy events to the simple dummy driver.
 
 config IIO_SIMPLE_DUMMY_BUFFER
-       boolean "Buffered capture support"
-       select IIO_KFIFO_BUF
-       help
-         Add buffered data capture to the simple dummy driver.
+	boolean "Buffered capture support"
+	select IIO_BUFFER
+	select IIO_KFIFO_BUF
+	help
+	  Add buffered data capture to the simple dummy driver.
 
 endif # IIO_SIMPLE_DUMMY
 
-- 
1.8.3.2


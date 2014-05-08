Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbaEHPAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:00:22 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:53622 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbaEHO5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:57:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH 1/2] iio: always select ANON_INODES
Date: Thu,  8 May 2014 16:56:23 +0200
Message-Id: <1399560990-1402858-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399560990-1402858-1-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:lEVPthgi3J7ZzjExiLHMtuPRViuQeSOGI5UcRNaLsgw
 zJEsCVfZzOyXRaH8Glahj00oAhaS05Sf2MYJU+FXilOVCy7fAz
 80QsG1t2IPdkmbXedJr+p/XuTsXX7qP6bqUX4f3/Enm7xn9TQQ
 aGe372LDgFBF+759X6NbU9y2xy9Gy7j0YXh1fBp3Gnez+bEytI
 zrC4EyULgVkkyq06SdOkVT1oYNL/X/Gc7R3l/RcOI5EpSpYgJ9
 2CSpXWYA1qQ/41OOz3qmCdqnhLdm2ydHKXwMUWTwKGH1gEPxKa
 K9ecDPFiwn3HO4i15i7vvdt3xYf1r8c2p6AHxSyu8HQwDRc0mP
 S3GOJTp6TXq+JRwRxD73LvmwcSf1S1m6DysgWIOlQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without ANON_INODES, we get this build error:

drivers/built-in.o: In function `iio_event_getfd':
:(.text+0x14bf18): undefined reference to `anon_inode_getfd'

All other users explicitly select this symbol, so we should
do the same thing here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio@vger.kernel.org
---
 drivers/iio/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
index 743485e..345395e 100644
--- a/drivers/iio/Kconfig
+++ b/drivers/iio/Kconfig
@@ -4,6 +4,7 @@
 
 menuconfig IIO
 	tristate "Industrial I/O support"
+	select ANON_INODES
 	help
 	  The industrial I/O subsystem provides a unified framework for
 	  drivers for many different types of embedded sensors using a
-- 
1.8.3.2


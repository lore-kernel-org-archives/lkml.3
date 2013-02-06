Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab3BFQYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:24:40 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:36215 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757590Ab3BFQYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:24:35 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: arnd@arndb.de, axboe@kernel.dk, cbou@mail.ru, davem@davemloft.net,
        dtor@mail.ru, dwmw2@infradead.org, grant.likely@secretlab.ca,
        gregkh@linuxfoundation.org, jkosina@suse.cz, jslaby@suse.cz,
        khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz,
        sameo@linux.intel.com, tiwai@suse.de, w.sang@pengutronix.de
Cc: linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, schwidefsky@de.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 15/15] drivers/serial: add GENERIC_HARDIRQS dependency
Date: Wed,  6 Feb 2013 17:24:03 +0100
Message-Id: <1360167843-3587-16-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 13020616-4966-0000-0000-000004D45561
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since SERIAL_CORE needs GENERIC_HARDIRQS (see below) and most serial drivers
select it, just add a GENERIC_HARDIRQS dependency to all serial drivers.

Fixes the compile error below:

drivers/tty/serial/serial_core.c: In function ‘uart_set_info’:
drivers/tty/serial/serial_core.c:725:2: error: implicit declaration of function ‘irq_canonicalize’

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/tty/serial/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index e9ff3f6..cf9210d 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -5,7 +5,7 @@
 if TTY
 
 menu "Serial drivers"
-	depends on HAS_IOMEM
+	depends on HAS_IOMEM && GENERIC_HARDIRQS
 
 source "drivers/tty/serial/8250/Kconfig"
 
-- 
1.7.10.4


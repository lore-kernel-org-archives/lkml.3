Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbaFWOcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:32:08 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:64465 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbaFWOcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:32:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, Scott Alfter <scott@alfter.us>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] w1: select crc16 library for ds2406
Date: Mon, 23 Jun 2014 16:31:47 +0200
Message-ID: <12173493.Olv1pKMOGK@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:YZGvclvvHwV8FJ+PfycYaFjcJS7FfTP+VBR6RLZmSxa
 RU8q7gkvgkwzT/zaEa0MsuucKkSYA4qo2m9sNQxD3UnIYMRb9u
 bILW9TJ1DizWLTpwoXNflnmSfQjfoqkhtCFLR1yA7L4phiuGSI
 xqf96Z11MOXrtlxz5n6QWRFCD8YdNVv/PDIz3kdf9x0QahRBlv
 8JCE1WxjhXJnWEsZYxKxNJabFvrqUPOLh/SbG4Z5JkEKmDxeQf
 u1+d/VFy7uhGoKuy6tPYGtDW7NRvwsxm05M+AqPXSgOtZE52RO
 9kc+SCyR/u0+0Zvfs8bUeAeiKGJWfWN85aYQA4ovrp30c+GvQQ
 mUPMw1u1aoumx0PCwf2o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 94859308a21b "w1: new w1_ds2406 driver" added a new driver
that uses the crc16 library, but didn't ensure that the core is
there. This adds the necessary Kconfig statements, just like we
have it for other w1 drivers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Scott Alfter <scott@alfter.us>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/w1/slaves/Kconfig b/drivers/w1/slaves/Kconfig
index fd31d2f..cfe74d0 100644
--- a/drivers/w1/slaves/Kconfig
+++ b/drivers/w1/slaves/Kconfig
@@ -40,6 +40,7 @@ config W1_SLAVE_DS2413
 
 config W1_SLAVE_DS2406
 	tristate "Dual Channel Addressable Switch 0x12 family support (DS2406)"
+	select CRC16
 	help
 	  Say Y or M here if you want to use a 1-wire
 	  DS2406 Dual Channel Addressable Switch.  EPROM read/write


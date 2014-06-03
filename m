Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaFCK3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:29:45 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:49917 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaFCK3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:29:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: [PATCH] staging: comedi: addi_apci_1564: add addi_watchdog dependency
Date: Tue, 03 Jun 2014 12:29:29 +0200
Message-ID: <6736164.51V0tJU9Jh@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:wceMaZswxrJIVAxC97YJv10c+JytEmHgRqGxiilfnbM
 3X7m89GexDk7t08ygpmRgXYXTR1ebQtAPD71pb5rY9As2ZjthX
 OXGUgLWsviq6L/ShsffG+bp04o10xwR4qKjdOrF5DKlQMR3zXl
 XpxwmT+bxjewFOoas/wndQHQkfoCo0G/WOxT/DfZrvssyfSZwU
 +0RjBJSOGvzrlwFTcNKQc9EheCYgHApkbPKWzKZLU1B8x6p9If
 rmpeY9ZA0ESiCU1z3s4mB5ab5f7D30bH4fyrg+mE9t7QPPA/00
 vVQ4CpsCdHZ7IiLTZV5d2OIPQSqZ3WcGPCsp4RDcCt5huoRu+/
 kywb84JuFzkTjxERE01I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With commit aed3f9d498b ("staging: comedi: addi_apci_1564:
absorb apci1564_reset()"), the apci 1564 driver has gained
a dependency on the addi watchdog module, which is not reflected
correctly in Kconfig, and that can lead to link errors
when the watchdog is disabled.

This adds an explicit 'select', like it is done in the other
addi apci drivers that need it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index 5d56428..a2f6957 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -651,6 +651,7 @@ config COMEDI_ADDI_APCI_1516
 
 config COMEDI_ADDI_APCI_1564
 	tristate "ADDI-DATA APCI_1564 support"
+	select COMEDI_ADDI_WATCHDOG
 	---help---
 	  Enable support for ADDI-DATA APCI_1564 cards
 


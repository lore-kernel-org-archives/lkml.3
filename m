Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab3L3WSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 17:18:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46037 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab3L3WSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 17:18:09 -0500
Date: Mon, 30 Dec 2013 23:18:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        Ville Tervo <ville.tervo@nokia.com>, Sebastian Reichel <sre@ring0.de>
Subject: Re: [PATCH v2] Bluetooth: Add hci_h4p driver
Message-ID: <20131230221806.GA32561@amd.pavel.ucw.cz>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
 <1727897.LBX8128hIo@izba>
 <C8D1F470-7964-4EAC-82E0-D53CF54DE086@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C8D1F470-7964-4EAC-82E0-D53CF54DE086@holtmann.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > +config BT_HCIH4P
> > +	tristate "HCI driver with H4 Nokia extensions"
> > +	depends on BT && ARCH_OMAP
> 
> Since then we moved away from doing hci_* prefix of drivers since that is misleading. See btusb.ko, btmrvl_sdio.ko etc.
> 
> So this might be better named BT_NOK_H4P or BT_NOKIA_H4P and the module named btnok_h4p.ko or btnokia_h4p.ko.
> 

Pali, please apply :-).

							Pavel

commit b724166911dcdae2c43170ce4040427c00e834e3
Author: Pavel <pavel@ucw.cz>
Date:   Mon Dec 30 23:16:25 2013 +0100

    Rename nokia h4p driver object to btnokia_h4p.ko.
    
    Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index 9d46f23..a53e8c7 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -251,5 +251,5 @@ config BT_NOKIA_H4P
 	  support for H4+ Bluetooth chip with vendor-specific H4 extensions.
 
 	  Say Y here to compile support for h4 extended devices into the kernel
-	  or say M to compile it as module (hci_h4p).
+	  or say M to compile it as module (btnokia_h4p).
 endmenu
diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
index c286dbe..a5ed271 100644
--- a/drivers/bluetooth/Makefile
+++ b/drivers/bluetooth/Makefile
@@ -31,7 +31,7 @@ hci_uart-$(CONFIG_BT_HCIUART_ATH3K)	+= hci_ath.o
 hci_uart-$(CONFIG_BT_HCIUART_3WIRE)	+= hci_h5.o
 hci_uart-objs				:= $(hci_uart-y)
 
-obj-$(CONFIG_BT_NOKIA_H4P)		+= hci_h4p.o
-hci_h4p-objs := nokia_core.o nokia_fw.o nokia_uart.o nokia_fw-csr.o \
+obj-$(CONFIG_BT_NOKIA_H4P)		+= btnokia_h4p.o
+btnokia_h4p-objs := nokia_core.o nokia_fw.o nokia_uart.o nokia_fw-csr.o \
 		nokia_fw-bcm.o nokia_fw-ti1273.o
 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

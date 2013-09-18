Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab3IRKRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 06:17:12 -0400
Received: from outm2.farsite.co.uk ([82.108.209.243]:37785 "EHLO m.farsite.eu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751343Ab3IRKRC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 06:17:02 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Sep 2013 06:16:52 EDT
From: Kevin Curtis <Kevin.Curtis@farsite.com>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Dermot Smith <dermot.smith@farsite.com>
Date: Wed, 18 Sep 2013 11:12:32 +0100
Subject: [PATCH 007/007] WAN Drivers: Update farsync driver and introduce
 fsflex driver
Thread-Topic: [PATCH 007/007] WAN Drivers: Update farsync driver and
 introduce fsflex driver
Thread-Index: Ac60V5bSRTS73jgsSiW0e69kwm409Q==
Message-ID: <E603DC592C92B54A89CEF6B0919A0B1CAAAA787DA6@SOLO.hq.farsitecommunications.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Farsite Communications FarSync driver update

Patch 7 of 7

Update the help text and description for farsync configuration in the Kernel.
Build farsync and fsflex when the farsync driver is selected.

Signed-off-by: Kevin Curtis <kevin.curtis@farsite.com>

---

diff -uprN -X linux-3.10.1/Documentation/dontdiff linux-3.10.1/drivers/net/wan/Kconfig linux-3.10.1_new/drivers/net/wan/Kconfig
--- linux-3.10.1/drivers/net/wan/Kconfig	2013-07-13 19:42:41.000000000 +0100
+++ linux-3.10.1_new/drivers/net/wan/Kconfig	2013-07-31 14:11:05.792775800 +0100
@@ -248,11 +248,11 @@ config C101
 	  If unsure, say N.
 
 config FARSYNC
-	tristate "FarSync T-Series support"
+	tristate "FarSync T-Series and Flex support"
 	depends on HDLC && PCI
 	---help---
-	  Support for the FarSync T-Series X.21 (and V.35/V.24) cards by
-	  FarSite Communications Ltd.
+	  Support for the FarSync T-Series and FarSync Flex X.21 (and
+          V.35/V.24) ports by FarSite Communications Ltd.
 
 	  Synchronous communication is supported on all ports at speeds up to
 	  8Mb/s (128K on V.24) using synchronous PPP, Cisco HDLC, raw HDLC,
diff -uprN -X linux-3.10.1/Documentation/dontdiff linux-3.10.1/drivers/net/wan/Makefile linux-3.10.1_new/drivers/net/wan/Makefile
--- linux-3.10.1/drivers/net/wan/Makefile	2013-07-13 19:42:41.000000000 +0100
+++ linux-3.10.1_new/drivers/net/wan/Makefile	2013-07-26 09:14:15.345354002 +0100
@@ -16,7 +16,7 @@ obj-$(CONFIG_HDLC_X25)		+= hdlc_x25.o
 obj-$(CONFIG_HOSTESS_SV11)	+= z85230.o	hostess_sv11.o
 obj-$(CONFIG_SEALEVEL_4021)	+= z85230.o	sealevel.o
 obj-$(CONFIG_COSA)		+= cosa.o
-obj-$(CONFIG_FARSYNC)		+= farsync.o
+obj-$(CONFIG_FARSYNC)		+= farsync.o fsflex.o
 obj-$(CONFIG_DSCC4)             += dscc4.o
 obj-$(CONFIG_X25_ASY)		+= x25_asy.o


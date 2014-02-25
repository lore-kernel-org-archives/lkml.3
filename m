Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaBYIPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 03:15:33 -0500
Received: from nm6-vm2.bullet.mail.gq1.yahoo.com ([98.136.218.193]:42686 "EHLO
	nm6-vm2.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708AbaBYIPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 03:15:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=cDkChgwPU0x26byn7XaPj2Pnlx85p7xy3LS4mupN/gPOvorH0ZyLd1cHsZ2KjoohYDrz3bv5rhvGZuE7rSY7HxxEdqZzzi1U62vKyvBc9DeM1+M0ImZLXyFR3KM9AkcgzirU3c2AKyjhZYByRqPxZ9ta9R5G1BQd7RrSzqL2RGc=;
X-Yahoo-Newman-Id: 219082.88268.bm@smtp225.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: oxcdtRgVM1mZ4lLEdFJlYU7o7RQb6WzQjgXFRdPgJ9kQpx9
 glWnrcVv5btc.nyltgjIdb722tU4ZDrjrytyASL5.tc0RYYoUfcjp1MPszfU
 pWcEMw.PP7zfyZQdkvUaVtzkX9dpB.TGLAZFLgRnxj2UpJQGbzGZu45Or80X
 YHaKeNFtcUAvf.f8GeFqEGpq64b9lsohvcrQWKa5kVMbGQhRg1GimYMHj2sn
 8Cj9KVX7fkgMJ6nE8gmbjJHWz3SlFFX8Ekf0LSneqG6xOEuVHRtJzqV1mrfW
 aIZiSZBSi23zW5h_ynwAzGApLQ8Hp04Q3FcRKz2luZFdsb7HU8f.o4Cv1YaF
 .BafwjiUq6IRoILYmpPLPo0wt3LRMCi7I3BiObiOC7yFzPtTsEwQBYgBf2oc
 pwcp_uqeQNZnC6oVpGsEkr0k7Fg_gJcTiAOrlHcfhsvAdJZinV1pKPyLv6n3
 Art.bAYqH7leZnmEjd4_KgaUoTnIuQSCVPjOgfSnSZjkChAOXx8XRf1uM2xj
 EbwkU3D7v.mmgg5xg6P_4nf_JOgPHORgxfr8v
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [63.250.193.228])
        by smtp225.mail.gq1.yahoo.com with SMTP; 25 Feb 2014 08:15:31 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH] Staging: comedi: addi-data: clean-up variable use in hwdrv_apci035.c
Date: Tue, 25 Feb 2014 02:15:27 -0600
Message-Id: <1393316127-28777-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The static variable ui_Command is as of right now being cleared to a
value of zero between everytime that it writes to a port and then takes a
new value from a port.  Seems like this zeroing is unnecessary, so we can
just remove these lines.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
This sort of thing seems like a copy/paste sort of error to me, but there
could as easily be some reason here that I'm missing that this is needed
here.  My first impression, however, was that this extra clearing is
useless.

 drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
index 6fca105..9041fdf 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
@@ -182,11 +182,9 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
 	else
 		ui_Mode = 0;
 
-/* ui_Command = inl(devpriv->iobase+((i_WatchdogNbr-1)*32)+12); */
 	ui_Command = 0;
-/* ui_Command = ui_Command & 0xFFFFF9FEUL; */
 	outl(ui_Command, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
-	ui_Command = 0;
+
 	ui_Command = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
 
 	/* Set the reload value */
@@ -224,7 +222,7 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
 	}
 
 	outl(ui_Command, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
-	ui_Command = 0;
+
 	ui_Command = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
 
 	/* Disable the hardware trigger */
@@ -235,7 +233,7 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
 		ui_Command = ui_Command | (data[5] << 5);
 	}
 	outl(ui_Command, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
-	ui_Command = 0;
+
 	ui_Command = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
 
 	/* Disable the hardware gate */
@@ -246,7 +244,7 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
 		ui_Command = ui_Command | (data[7] << 7);
 	}
 	outl(ui_Command, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
-	ui_Command = 0;
+
 	ui_Command = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
 
 	/* Disable the hardware output */
@@ -266,7 +264,6 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
 			devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 28);
 	}
 
-	ui_Command = 0;
 	ui_Command = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
 
 	/* Disable the hardware output */
@@ -277,7 +274,6 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
 	outl(ui_Command, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
 
 	/* Enable the watchdog interrupt */
-	ui_Command = 0;
 	ui_Command = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
 
 	/* Set the interrupt selection */
-- 
1.8.5.3


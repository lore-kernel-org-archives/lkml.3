Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3K3Ppq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 10:45:46 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:30410 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab3K3Ppn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 10:45:43 -0500
X-Greylist: delayed 716 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Nov 2013 10:45:43 EST
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Wim Van Sebroeck <wim@iguana.be>, <scottwood@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] watchdog: mpc8xxx_wdt: MPC8xx is HW enabled
Message-Id: <20131130154540.E83D743E15@localhost.localdomain>
Date: Sat, 30 Nov 2013 16:45:40 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Antivirus: avast! (VPS 131130-0, 30/11/2013), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MPC8xx watchdog is enabled at startup by HW.
If the bootloader disables it, it cannot be reenabled.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

diff -ur a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
--- a/drivers/watchdog/mpc8xxx_wdt.c	2013-05-11 22:57:46.000000000 +0200
+++ b/drivers/watchdog/mpc8xxx_wdt.c	2013-08-08 02:12:15.000000000 +0200
@@ -273,6 +310,7 @@
 		.compatible = "fsl,mpc823-wdt",
 		.data = &(struct mpc8xxx_wdt_type) {
 			.prescaler = 0x800,
+			.hw_enabled = true,
 		},
 	},
 	{},

---
Ce courrier électronique ne contient aucun virus ou logiciel malveillant parce que la protection avast! Antivirus est active.
http://www.avast.com


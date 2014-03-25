Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbaCYTKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 15:10:52 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41860 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaCYTKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 15:10:49 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-43-5331d4b7e54c
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        linux-ide@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ata: limit sata_rcar host driver to ARCH_SHMOBILE
Date: Tue, 25 Mar 2014 20:10:27 +0100
Message-id: <9835622.nRa3VdL61G@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t9jQd3tVwyDDc6uULNo3vqV0WLT42us
	Fsd2PGKyuLxrDpvFnD9TmC0erH7LZvFr+VFGB3aPnbPusntsWtXJ5rF5Sb3HnJ/fWDw+b5IL
	YI3isklJzcksSy3St0vgyvj4+ixTwXW2iuVPVzE2MJ5h7WLk5JAQMJF4eXY9M4QtJnHh3no2
	EFtIYDqjxNk3gl2MXEB2C5PEt7erwBrYBKwkJravYgSxRQRkJa5Me8gIUsQscJxRovfGZRaQ
	hLCAk0T3lcNMIDaLgKrE+8/zwGxeAU2JL/O/gw0SFfCU2LF9JRtEXFDix+R7YL3MAvIS+/ZP
	ZYWwtSTW7zzONIGRbxaSsllIymYhKVvAyLyKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzho
	n0ntYFzZYHGIUYCDUYmHd8IEw2Ah1sSy4srcQ4wSHMxKIrx/TwKFeFMSK6tSi/Lji0pzUosP
	MUpzsCiJ8x5otQ4UEkhPLEnNTk0tSC2CyTJxcEo1MIq8z0ydk7vfY0XzX/FYw5bJpiZa7A/v
	6vzueXsvUYyzeW7EqzKPeZuSnrV8z4rPDwmc/3LV1GYp7yprS67V/MpfZGzbq9I+VHpuFNnK
	xXeG421bnujtgtKd0WuzrvO8eKu9nTuN3+jXPJn7/xjfbG38sKVu2nznfxF2+UaL8v6EzHI9
	tuersBJLcUaioRZzUXEiAG2nucRWAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit sata_rcar host driver to ARCH_SHMOBILE as Renesas R-Car SATA
support is specific to Renesas SoCs and the driver to work requires
suitable device tree node (or platform device) to be defined.

Cc: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/ata/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/ata/Kconfig
===================================================================
--- a/drivers/ata/Kconfig	2014-03-25 19:52:31.952327027 +0100
+++ b/drivers/ata/Kconfig	2014-03-25 19:57:21.104322097 +0100
@@ -298,6 +298,7 @@ config SATA_PROMISE
 
 config SATA_RCAR
 	tristate "Renesas R-Car SATA support"
+	depends on ARCH_SHMOBILE
 	help
 	  This option enables support for Renesas R-Car Serial ATA.
 


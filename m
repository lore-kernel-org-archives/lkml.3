Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab3ATQ7B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 11:59:01 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:58994 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab3ATQ65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 11:58:57 -0500
X-Auth-Info: xKvodAKB3+bO1Fu5aMFwpMO61eMBgdSz+7Slut+0kOk=
From: Andreas Schwab <schwab@linux-m68k.org>
To: linux-kbuild@vger.kernel.org
Subject: [PATCH] mod/file2alias: make modalias generation safe for cross compiling
CC: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
X-Yow: Do I hear th' SPINNING of various WHIRRING, ROUND, and WARM
 WHIRLOMATICS?!
Date: Sun, 20 Jan 2013 17:58:47 +0100
Message-ID: <m2txqbu6yg.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the target compiler to compute the offsets for the fields of the
device_id structures, so that it won't be broken by different alignments
between the host and target ABIs.

This also fixes missing endian corrections for some modaliases.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
---
This has been tested with an allmodconfig cross build of the m68k
kernel.  This is the difference in the generated module aliases before
and after the patch:

63,64c63,64
< drivers/media/radio/radio-sf16fmi.mod.c:MODULE_ALIAS("pnp:dtQT10ad*");
< drivers/media/radio/radio-sf16fmi.mod.c:MODULE_ALIAS("pnp:dtQT12ad*");
---
> drivers/media/radio/radio-sf16fmi.mod.c:MODULE_ALIAS("pnp:dMFRad10*");
> drivers/media/radio/radio-sf16fmi.mod.c:MODULE_ALIAS("pnp:dMFRad12*");
85,87c85,87
< drivers/ipack/devices/ipoctal.mod.c:MODULE_ALIAS("ipack:f01v00F00000d00220100*");
< drivers/ipack/devices/ipoctal.mod.c:MODULE_ALIAS("ipack:f00v0000002Ad01000000*");
< drivers/ipack/devices/ipoctal.mod.c:MODULE_ALIAS("ipack:f00v00480000d00000000*");
---
> drivers/ipack/devices/ipoctal.mod.c:MODULE_ALIAS("ipack:f01v000000F0d00000022*");
> drivers/ipack/devices/ipoctal.mod.c:MODULE_ALIAS("ipack:f01v000000F0d0000002A*");
> drivers/ipack/devices/ipoctal.mod.c:MODULE_ALIAS("ipack:f01v000000F0d00000048*");
139,193c139,193
< drivers/net/phy/micrel.mod.c:MODULE_ALIAS("mdio:0001000?00010110????0010????????");
< drivers/net/phy/micrel.mod.c:MODULE_ALIAS("mdio:000110100001011000100010????????");
< drivers/net/phy/micrel.mod.c:MODULE_ALIAS("mdio:0010????0001011100100010????????");
< drivers/net/phy/micrel.mod.c:MODULE_ALIAS("mdio:010101010001010100100010????????");
< drivers/net/phy/micrel.mod.c:MODULE_ALIAS("mdio:0001????0001010100100010????????");
< drivers/net/phy/micrel.mod.c:MODULE_ALIAS("mdio:0101????0001010100100010????????");
< drivers/net/phy/micrel.mod.c:MODULE_ALIAS("mdio:0011????0111001000001110????????");
< drivers/net/phy/vitesse.mod.c:MODULE_ALIAS("mdio:11??????11000110????1111????????");
< drivers/net/phy/vitesse.mod.c:MODULE_ALIAS("mdio:0101????11000101????1111????????");
< drivers/net/phy/cicada.mod.c:MODULE_ALIAS("mdio:0001????11000100????1111????????");
< drivers/net/phy/cicada.mod.c:MODULE_ALIAS("mdio:01??????11000100????1111????????");
< drivers/net/phy/qsemi.mod.c:MODULE_ALIAS("mdio:0100????000101000001100000000000");
< drivers/net/phy/davicom.mod.c:MODULE_ALIAS("mdio:1000????1011100010000001????0001");
< drivers/net/phy/davicom.mod.c:MODULE_ALIAS("mdio:1010????1011100010000001????0001");
< drivers/net/phy/davicom.mod.c:MODULE_ALIAS("mdio:1000????0001101100011000????0000");
< drivers/net/phy/at803x.mod.c:MODULE_ALIAS("mdio:011?0110110100000100110100000000");
< drivers/net/phy/at803x.mod.c:MODULE_ALIAS("mdio:011?0010110100000100110100000000");
< drivers/net/phy/realtek.mod.c:MODULE_ALIAS("mdio:0001001011001001???11100????????");
< drivers/net/phy/et1011c.mod.c:MODULE_ALIAS("mdio:0001????111100001000001000000010");
< drivers/net/phy/national.mod.c:MODULE_ALIAS("mdio:0111????010111000000000000100000");
< drivers/net/phy/amd.mod.c:MODULE_ALIAS("mdio:0001????010101100010001000000000");
< drivers/net/phy/dp83640.mod.c:MODULE_ALIAS("mdio:1110????010111000000000000100000");
< drivers/net/phy/broadcom.mod.c:MODULE_ALIAS("mdio:0111????011000000010000000000000");
< drivers/net/phy/broadcom.mod.c:MODULE_ALIAS("mdio:1110????011000000010000000000000");
< drivers/net/phy/broadcom.mod.c:MODULE_ALIAS("mdio:1100????011000000010000000000000");
< drivers/net/phy/broadcom.mod.c:MODULE_ALIAS("mdio:1011????011000000010000000000000");
< drivers/net/phy/broadcom.mod.c:MODULE_ALIAS("mdio:1011????101111000100001100000001");
< drivers/net/phy/broadcom.mod.c:MODULE_ALIAS("mdio:1011????101111000100001100000001");
< drivers/net/phy/broadcom.mod.c:MODULE_ALIAS("mdio:0110????101111010100001100000001");
< drivers/net/phy/broadcom.mod.c:MODULE_ALIAS("mdio:0111????101111010100001100000001");
< drivers/net/phy/broadcom.mod.c:MODULE_ALIAS("mdio:1001????010111010110001000000011");
< drivers/net/phy/broadcom.mod.c:MODULE_ALIAS("mdio:0111????101111000100001100000001");
< drivers/net/phy/broadcom.mod.c:MODULE_ALIAS("mdio:0011????101111000100001100000001");
< drivers/net/phy/icplus.mod.c:MODULE_ALIAS("mdio:1000????0000110101000011????0010");
< drivers/net/phy/icplus.mod.c:MODULE_ALIAS("mdio:1001????0000110101000011????0010");
< drivers/net/phy/icplus.mod.c:MODULE_ALIAS("mdio:0101????0000110001000011????0010");
< drivers/net/phy/ste10Xp.mod.c:MODULE_ALIAS("mdio:0101????000111000000011000000000");
< drivers/net/phy/ste10Xp.mod.c:MODULE_ALIAS("mdio:00010001000000000000010000011100");
< drivers/net/phy/smsc.mod.c:MODULE_ALIAS("mdio:1010????110000000000011100000000");
< drivers/net/phy/smsc.mod.c:MODULE_ALIAS("mdio:1011????110000000000011100000000");
< drivers/net/phy/smsc.mod.c:MODULE_ALIAS("mdio:1100????110000000000011100000000");
< drivers/net/phy/smsc.mod.c:MODULE_ALIAS("mdio:1101????110000000000011100000000");
< drivers/net/phy/smsc.mod.c:MODULE_ALIAS("mdio:1111????110000000000011100000000");
< drivers/net/phy/lxt.mod.c:MODULE_ALIAS("mdio:0000????000000000001000001111000");
< drivers/net/phy/lxt.mod.c:MODULE_ALIAS("mdio:1110????011110000001001100000000");
< drivers/net/phy/lxt.mod.c:MODULE_ALIAS("mdio:0001????011110100001001100000000");
< drivers/net/phy/marvell.mod.c:MODULE_ALIAS("mdio:0110????000011000100000100000001");
< drivers/net/phy/marvell.mod.c:MODULE_ALIAS("mdio:1001????000011000100000100000001");
< drivers/net/phy/marvell.mod.c:MODULE_ALIAS("mdio:1100????000011000100000100000001");
< drivers/net/phy/marvell.mod.c:MODULE_ALIAS("mdio:0001????000011100100000100000001");
< drivers/net/phy/marvell.mod.c:MODULE_ALIAS("mdio:1011????000011000100000100000001");
< drivers/net/phy/marvell.mod.c:MODULE_ALIAS("mdio:1101????000011000100000100000001");
< drivers/net/phy/marvell.mod.c:MODULE_ALIAS("mdio:0101????000011100100000100000001");
< drivers/net/phy/marvell.mod.c:MODULE_ALIAS("mdio:0011????000011100100000100000001");
< drivers/net/phy/marvell.mod.c:MODULE_ALIAS("mdio:1001????000011100100000100000001");
---
> drivers/net/phy/micrel.mod.c:MODULE_ALIAS("mdio:????????????0010000101100001000?");
> drivers/net/phy/micrel.mod.c:MODULE_ALIAS("mdio:????????001000100001011000011010");
> drivers/net/phy/micrel.mod.c:MODULE_ALIAS("mdio:????????00100010000101110010????");
> drivers/net/phy/micrel.mod.c:MODULE_ALIAS("mdio:????????001000100001010101010101");
> drivers/net/phy/micrel.mod.c:MODULE_ALIAS("mdio:????????00100010000101010001????");
> drivers/net/phy/micrel.mod.c:MODULE_ALIAS("mdio:????????00100010000101010101????");
> drivers/net/phy/micrel.mod.c:MODULE_ALIAS("mdio:????????00001110011100100011????");
> drivers/net/phy/vitesse.mod.c:MODULE_ALIAS("mdio:????????????11111100011011??????");
> drivers/net/phy/vitesse.mod.c:MODULE_ALIAS("mdio:????????????1111110001010101????");
> drivers/net/phy/cicada.mod.c:MODULE_ALIAS("mdio:????????????1111110001000001????");
> drivers/net/phy/cicada.mod.c:MODULE_ALIAS("mdio:????????????11111100010001??????");
> drivers/net/phy/qsemi.mod.c:MODULE_ALIAS("mdio:0000000000011000000101000100????");
> drivers/net/phy/davicom.mod.c:MODULE_ALIAS("mdio:????000110000001101110001000????");
> drivers/net/phy/davicom.mod.c:MODULE_ALIAS("mdio:????000110000001101110001010????");
> drivers/net/phy/davicom.mod.c:MODULE_ALIAS("mdio:????000000011000000110111000????");
> drivers/net/phy/at803x.mod.c:MODULE_ALIAS("mdio:000000000100110111010000011?0110");
> drivers/net/phy/at803x.mod.c:MODULE_ALIAS("mdio:000000000100110111010000011?0010");
> drivers/net/phy/realtek.mod.c:MODULE_ALIAS("mdio:???????????111001100100100010010");
> drivers/net/phy/et1011c.mod.c:MODULE_ALIAS("mdio:0000001010000010111100000001????");
> drivers/net/phy/national.mod.c:MODULE_ALIAS("mdio:0010000000000000010111000111????");
> drivers/net/phy/amd.mod.c:MODULE_ALIAS("mdio:0000000000100010010101100001????");
> drivers/net/phy/dp83640.mod.c:MODULE_ALIAS("mdio:0010000000000000010111001110????");
> drivers/net/phy/broadcom.mod.c:MODULE_ALIAS("mdio:0000000000100000011000000111????");
> drivers/net/phy/broadcom.mod.c:MODULE_ALIAS("mdio:0000000000100000011000001110????");
> drivers/net/phy/broadcom.mod.c:MODULE_ALIAS("mdio:0000000000100000011000001100????");
> drivers/net/phy/broadcom.mod.c:MODULE_ALIAS("mdio:0000000000100000011000001011????");
> drivers/net/phy/broadcom.mod.c:MODULE_ALIAS("mdio:0000000101000011101111001011????");
> drivers/net/phy/broadcom.mod.c:MODULE_ALIAS("mdio:0000000101000011101111001011????");
> drivers/net/phy/broadcom.mod.c:MODULE_ALIAS("mdio:0000000101000011101111010110????");
> drivers/net/phy/broadcom.mod.c:MODULE_ALIAS("mdio:0000000101000011101111010111????");
> drivers/net/phy/broadcom.mod.c:MODULE_ALIAS("mdio:0000001101100010010111011001????");
> drivers/net/phy/broadcom.mod.c:MODULE_ALIAS("mdio:0000000101000011101111000111????");
> drivers/net/phy/broadcom.mod.c:MODULE_ALIAS("mdio:0000000101000011101111000011????");
> drivers/net/phy/icplus.mod.c:MODULE_ALIAS("mdio:????001001000011000011011000????");
> drivers/net/phy/icplus.mod.c:MODULE_ALIAS("mdio:????001001000011000011011001????");
> drivers/net/phy/icplus.mod.c:MODULE_ALIAS("mdio:????001001000011000011000101????");
> drivers/net/phy/ste10Xp.mod.c:MODULE_ALIAS("mdio:0000000000000110000111000101????");
> drivers/net/phy/ste10Xp.mod.c:MODULE_ALIAS("mdio:00011100000001000000000000010001");
> drivers/net/phy/smsc.mod.c:MODULE_ALIAS("mdio:0000000000000111110000001010????");
> drivers/net/phy/smsc.mod.c:MODULE_ALIAS("mdio:0000000000000111110000001011????");
> drivers/net/phy/smsc.mod.c:MODULE_ALIAS("mdio:0000000000000111110000001100????");
> drivers/net/phy/smsc.mod.c:MODULE_ALIAS("mdio:0000000000000111110000001101????");
> drivers/net/phy/smsc.mod.c:MODULE_ALIAS("mdio:0000000000000111110000001111????");
> drivers/net/phy/lxt.mod.c:MODULE_ALIAS("mdio:0111100000010000000000000000????");
> drivers/net/phy/lxt.mod.c:MODULE_ALIAS("mdio:0000000000010011011110001110????");
> drivers/net/phy/lxt.mod.c:MODULE_ALIAS("mdio:0000000000010011011110100001????");
> drivers/net/phy/marvell.mod.c:MODULE_ALIAS("mdio:0000000101000001000011000110????");
> drivers/net/phy/marvell.mod.c:MODULE_ALIAS("mdio:0000000101000001000011001001????");
> drivers/net/phy/marvell.mod.c:MODULE_ALIAS("mdio:0000000101000001000011001100????");
> drivers/net/phy/marvell.mod.c:MODULE_ALIAS("mdio:0000000101000001000011100001????");
> drivers/net/phy/marvell.mod.c:MODULE_ALIAS("mdio:0000000101000001000011001011????");
> drivers/net/phy/marvell.mod.c:MODULE_ALIAS("mdio:0000000101000001000011001101????");
> drivers/net/phy/marvell.mod.c:MODULE_ALIAS("mdio:0000000101000001000011100101????");
> drivers/net/phy/marvell.mod.c:MODULE_ALIAS("mdio:0000000101000001000011100011????");
> drivers/net/phy/marvell.mod.c:MODULE_ALIAS("mdio:0000000101000001000011101001????");
195,200c195,200
< drivers/net/ethernet/8390/atari_ethernec.mod.c:MODULE_ALIAS("pnp:dAHG1120*");
< drivers/net/ethernet/8390/atari_ethernec.mod.c:MODULE_ALIAS("pnp:dbHT1602*");
< drivers/net/ethernet/8390/atari_ethernec.mod.c:MODULE_ALIAS("pnp:dtBAd680*");
< drivers/net/ethernet/8390/ne.mod.c:MODULE_ALIAS("pnp:dAHG1120*");
< drivers/net/ethernet/8390/ne.mod.c:MODULE_ALIAS("pnp:dbHT1602*");
< drivers/net/ethernet/8390/ne.mod.c:MODULE_ALIAS("pnp:dtBAd680*");
---
> drivers/net/ethernet/8390/atari_ethernec.mod.c:MODULE_ALIAS("pnp:dAXE2011*");
> drivers/net/ethernet/8390/atari_ethernec.mod.c:MODULE_ALIAS("pnp:dEDI0216*");
> drivers/net/ethernet/8390/atari_ethernec.mod.c:MODULE_ALIAS("pnp:dPNP80d6*");
> drivers/net/ethernet/8390/ne.mod.c:MODULE_ALIAS("pnp:dAXE2011*");
> drivers/net/ethernet/8390/ne.mod.c:MODULE_ALIAS("pnp:dEDI0216*");
> drivers/net/ethernet/8390/ne.mod.c:MODULE_ALIAS("pnp:dPNP80d6*");
203c203
< drivers/net/ethernet/8390/smc-ultra.mod.c:MODULE_ALIAS("pnp:dhZM1684*");
---
> drivers/net/ethernet/8390/smc-ultra.mod.c:MODULE_ALIAS("pnp:dSMC8416*");
844,845c844,845
< drivers/scsi/sym53c416.mod.c:MODULE_ALIAS("pnp:dbJM6141*");
< drivers/scsi/sym53c416.mod.c:MODULE_ALIAS("pnp:dbJM6341*");
---
> drivers/scsi/sym53c416.mod.c:MODULE_ALIAS("pnp:dSLI4161*");
> drivers/scsi/sym53c416.mod.c:MODULE_ALIAS("pnp:dSLI4163*");
854c854
< drivers/scsi/g_NCR5380.mod.c:MODULE_ALIAS("pnp:d`XR6e43*");
---
> drivers/scsi/g_NCR5380.mod.c:MODULE_ALIAS("pnp:dDTC436e*");
857,869c857,869
< drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dd@D0215*");
< drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dd@D0515*");
< drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dd@D1015*");
< drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dd@D1515*");
< drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dd@D2015*");
< drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dd@D1520*");
< drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dd@D2215*");
< drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dd@D1522*");
< drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dd@D3015*");
< drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dd@D1530*");
< drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dd@D3215*");
< drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dd@D1532*");
< drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dd@D6063*");
---
> drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dADP1502*");
> drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dADP1505*");
> drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dADP1510*");
> drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dADP1515*");
> drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dADP1520*");
> drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dADP2015*");
> drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dADP1522*");
> drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dADP2215*");
> drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dADP1530*");
> drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dADP3015*");
> drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dADP1532*");
> drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dADP3215*");
> drivers/scsi/aha152x.mod.c:MODULE_ALIAS("pnp:dADP6360*");
875,880c875,880
< drivers/input/joydev.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*k*r*a*m*l*s*f*w*");
< drivers/input/joydev.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*k*r*a*m*l*s*f*w*");
< drivers/input/joydev.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*k*r*a*m*l*s*f*w*");
< drivers/input/joydev.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*k*r*a*m*l*s*f*w*");
< drivers/input/joydev.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*k*r*a*m*l*s*f*w*");
< drivers/input/joydev.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*k*r*a*m*l*s*f*w*");
---
> drivers/input/joydev.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*3,*k*r*a*0,*m*l*s*f*w*");
> drivers/input/joydev.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*3,*k*r*a*8,*m*l*s*f*w*");
> drivers/input/joydev.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*3,*k*r*a*6,*m*l*s*f*w*");
> drivers/input/joydev.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*1,*k*120,*r*a*m*l*s*f*w*");
> drivers/input/joydev.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*1,*k*130,*r*a*m*l*s*f*w*");
> drivers/input/joydev.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*1,*k*2C0,*r*a*m*l*s*f*w*");
908,912c908,912
< drivers/input/mousedev.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*k*r*a*m*l*s*f*w*");
< drivers/input/mousedev.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*k*r*a*m*l*s*f*w*");
< drivers/input/mousedev.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*k*r*a*m*l*s*f*w*");
< drivers/input/mousedev.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*k*r*a*m*l*s*f*w*");
< drivers/input/mousedev.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*k*r*a*m*l*s*f*w*");
---
> drivers/input/mousedev.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*1,*2,*k*110,*r*0,*1,*a*m*l*s*f*w*");
> drivers/input/mousedev.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*1,*2,*k*r*8,*a*m*l*s*f*w*");
> drivers/input/mousedev.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*1,*3,*k*14A,*r*a*0,*1,*m*l*s*f*w*");
> drivers/input/mousedev.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*1,*3,*k*145,*r*a*0,*1,*18,*1C,*m*l*s*f*w*");
> drivers/input/mousedev.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*1,*3,*k*110,*r*a*0,*1,*m*l*s*f*w*");
1107c1107
< drivers/macintosh/mac_hid.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*k*r*a*m*l*s*f*w*");
---
> drivers/macintosh/mac_hid.mod.c:MODULE_ALIAS("input:b*v*p*e*-e*1,*k*r*a*m*l*s*f*w*");

---
 Makefile                          |   1 -
 include/linux/mod_devicetable.h   |  58 +---
 scripts/Makefile.modpost          |   7 +-
 scripts/mod/.gitignore            |   1 +
 scripts/mod/Makefile              |  35 ++
 scripts/mod/devicetable-offsets.c | 178 ++++++++++
 scripts/mod/file2alias.c          | 674 +++++++++++++++++++++-----------------
 scripts/mod/modpost.c             |   5 +-
 8 files changed, 591 insertions(+), 368 deletions(-)
 create mode 100644 scripts/mod/devicetable-offsets.c

diff --git a/Makefile b/Makefile
index 253a455..7d95aaf 100644
--- a/Makefile
+++ b/Makefile
@@ -191,7 +191,6 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 # "make" in the configured kernel build directory always uses that.
 # Default value for CROSS_COMPILE is not to prefix executables
 # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
-export KBUILD_BUILDHOST := $(SUBARCH)
 ARCH		?= $(SUBARCH)
 CROSS_COMPILE	?= $(CONFIG_CROSS_COMPILE:"%"=%)
 
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index fed3def..779cf7c 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -33,8 +33,7 @@ struct ieee1394_device_id {
 	__u32 model_id;
 	__u32 specifier_id;
 	__u32 version;
-	kernel_ulong_t driver_data
-		__attribute__((aligned(sizeof(kernel_ulong_t))));
+	kernel_ulong_t driver_data;
 };
 
 
@@ -148,8 +147,7 @@ struct hid_device_id {
 	__u16 group;
 	__u32 vendor;
 	__u32 product;
-	kernel_ulong_t driver_data
-		__attribute__((aligned(sizeof(kernel_ulong_t))));
+	kernel_ulong_t driver_data;
 };
 
 /* s390 CCW devices */
@@ -173,8 +171,6 @@ struct ccw_device_id {
 struct ap_device_id {
 	__u16 match_flags;	/* which fields to match against */
 	__u8 dev_type;		/* device type */
-	__u8 pad1;
-	__u32 pad2;
 	kernel_ulong_t driver_info;
 };
 
@@ -184,13 +180,10 @@ struct ap_device_id {
 struct css_device_id {
 	__u8 match_flags;
 	__u8 type; /* subchannel type */
-	__u16 pad2;
-	__u32 pad3;
 	kernel_ulong_t driver_data;
 };
 
-#define ACPI_ID_LEN	16 /* only 9 bytes needed here, 16 bytes are used */
-			   /* to workaround crosscompile issues */
+#define ACPI_ID_LEN	9
 
 struct acpi_device_id {
 	__u8 id[ACPI_ID_LEN];
@@ -231,11 +224,7 @@ struct of_device_id
 	char	name[32];
 	char	type[32];
 	char	compatible[128];
-#ifdef __KERNEL__
 	const void *data;
-#else
-	kernel_ulong_t data;
-#endif
 };
 
 /* VIO */
@@ -260,24 +249,14 @@ struct pcmcia_device_id {
 	/* for pseudo multi-function devices */
 	__u8  		device_no;
 
-	__u32 		prod_id_hash[4]
-		__attribute__((aligned(sizeof(__u32))));
+	__u32 		prod_id_hash[4];
 
 	/* not matched against in kernelspace*/
-#ifdef __KERNEL__
 	const char *	prod_id[4];
-#else
-	kernel_ulong_t	prod_id[4]
-		__attribute__((aligned(sizeof(kernel_ulong_t))));
-#endif
 
 	/* not matched against */
 	kernel_ulong_t	driver_info;
-#ifdef __KERNEL__
 	char *		cisfile;
-#else
-	kernel_ulong_t	cisfile;
-#endif
 };
 
 #define PCMCIA_DEV_ID_MATCH_MANF_ID	0x0001
@@ -373,8 +352,7 @@ struct sdio_device_id {
 	__u8	class;			/* Standard interface or SDIO_ANY_ID */
 	__u16	vendor;			/* Vendor or SDIO_ANY_ID */
 	__u16	device;			/* Device ID or SDIO_ANY_ID */
-	kernel_ulong_t driver_data	/* Data private to the driver */
-		__attribute__((aligned(sizeof(kernel_ulong_t))));
+	kernel_ulong_t driver_data;	/* Data private to the driver */
 };
 
 /* SSB core, see drivers/ssb/ */
@@ -420,8 +398,7 @@ struct virtio_device_id {
  */
 struct hv_vmbus_device_id {
 	__u8 guid[16];
-	kernel_ulong_t driver_data	/* Data private to the driver */
-			__attribute__((aligned(sizeof(kernel_ulong_t))));
+	kernel_ulong_t driver_data;	/* Data private to the driver */
 };
 
 /* rpmsg */
@@ -440,8 +417,7 @@ struct rpmsg_device_id {
 
 struct i2c_device_id {
 	char name[I2C_NAME_SIZE];
-	kernel_ulong_t driver_data	/* Data private to the driver */
-			__attribute__((aligned(sizeof(kernel_ulong_t))));
+	kernel_ulong_t driver_data;	/* Data private to the driver */
 };
 
 /* spi */
@@ -451,8 +427,7 @@ struct i2c_device_id {
 
 struct spi_device_id {
 	char name[SPI_NAME_SIZE];
-	kernel_ulong_t driver_data	/* Data private to the driver */
-			__attribute__((aligned(sizeof(kernel_ulong_t))));
+	kernel_ulong_t driver_data;	/* Data private to the driver */
 };
 
 /* dmi */
@@ -484,15 +459,6 @@ struct dmi_strmatch {
 	char substr[79];
 };
 
-#ifndef __KERNEL__
-struct dmi_system_id {
-	kernel_ulong_t callback;
-	kernel_ulong_t ident;
-	struct dmi_strmatch matches[4];
-	kernel_ulong_t driver_data
-			__attribute__((aligned(sizeof(kernel_ulong_t))));
-};
-#else
 struct dmi_system_id {
 	int (*callback)(const struct dmi_system_id *);
 	const char *ident;
@@ -506,7 +472,6 @@ struct dmi_system_id {
  *	error: storage size of '__mod_dmi_device_table' isn't known
  */
 #define dmi_device_id dmi_system_id
-#endif
 
 #define DMI_MATCH(a, b)	{ a, b }
 
@@ -515,8 +480,7 @@ struct dmi_system_id {
 
 struct platform_device_id {
 	char name[PLATFORM_NAME_SIZE];
-	kernel_ulong_t driver_data
-			__attribute__((aligned(sizeof(kernel_ulong_t))));
+	kernel_ulong_t driver_data;
 };
 
 #define MDIO_MODULE_PREFIX	"mdio:"
@@ -572,11 +536,7 @@ struct isapnp_device_id {
 struct amba_id {
 	unsigned int		id;
 	unsigned int		mask;
-#ifndef __KERNEL__
-	kernel_ulong_t		data;
-#else
 	void			*data;
-#endif
 };
 
 /*
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index a1cb022..cf82c83 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -66,10 +66,6 @@ modules   := $(patsubst %.o,%.ko, $(wildcard $(__modules:.ko=.o)))
 # Stop after building .o files if NOFINAL is set. Makes compile tests quicker
 _modpost: $(if $(KBUILD_MODPOST_NOFINAL), $(modules:.ko:.o),$(modules))
 
-ifneq ($(KBUILD_BUILDHOST),$(ARCH))
-        cross_build := 1
-endif
-
 # Step 2), invoke modpost
 #  Includes step 3,4
 modpost = scripts/mod/modpost                    \
@@ -80,8 +76,7 @@ modpost = scripts/mod/modpost                    \
  $(if $(KBUILD_EXTRA_SYMBOLS), $(patsubst %, -e %,$(KBUILD_EXTRA_SYMBOLS))) \
  $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
  $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)      \
- $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w) \
- $(if $(cross_build),-c)
+ $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)
 
 quiet_cmd_modpost = MODPOST $(words $(filter-out vmlinux FORCE, $^)) modules
       cmd_modpost = $(modpost) -s
diff --git a/scripts/mod/.gitignore b/scripts/mod/.gitignore
index e9b7abe..33bae0d 100644
--- a/scripts/mod/.gitignore
+++ b/scripts/mod/.gitignore
@@ -1,4 +1,5 @@
 elfconfig.h
 mk_elfconfig
 modpost
+devicetable-offsets.h
 
diff --git a/scripts/mod/Makefile b/scripts/mod/Makefile
index ff954f8..9415b56 100644
--- a/scripts/mod/Makefile
+++ b/scripts/mod/Makefile
@@ -3,9 +3,44 @@ always		:= $(hostprogs-y) empty.o
 
 modpost-objs	:= modpost.o file2alias.o sumversion.o
 
+devicetable-offsets-file := devicetable-offsets.h
+
+define sed-y
+	"/^->/{s:->#\(.*\):/* \1 */:; \
+	s:^->\([^ ]*\) [\$$#]*\([-0-9]*\) \(.*\):#define \1 \2 /* \3 */:; \
+	s:^->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; \
+	s:->::; p;}"
+endef
+
+quiet_cmd_offsets = GEN     $@
+define cmd_offsets
+	(set -e; \
+	 echo "#ifndef __DEVICEVTABLE_OFFSETS_H__"; \
+	 echo "#define __DEVICEVTABLE_OFFSETS_H__"; \
+	 echo "/*"; \
+	 echo " * DO NOT MODIFY."; \
+	 echo " *"; \
+	 echo " * This file was generated by Kbuild"; \
+	 echo " *"; \
+	 echo " */"; \
+	 echo ""; \
+	 sed -ne $(sed-y) $<; \
+	 echo ""; \
+	 echo "#endif" ) > $@
+endef
+
+# We use internal kbuild rules to avoid the "is up to date" message from make
+scripts/mod/devicetable-offsets.s: scripts/mod/devicetable-offsets.c FORCE
+	$(Q)mkdir -p $(dir $@)
+	$(call if_changed_dep,cc_s_c)
+
+$(obj)/$(devicetable-offsets-file): scripts/mod/devicetable-offsets.s
+	$(call cmd,offsets)
+
 # dependencies on generated files need to be listed explicitly
 
 $(obj)/modpost.o $(obj)/file2alias.o $(obj)/sumversion.o: $(obj)/elfconfig.h
+$(obj)/file2alias.o: $(obj)/$(devicetable-offsets-file)
 
 quiet_cmd_elfconfig = MKELF   $@
       cmd_elfconfig = $(obj)/mk_elfconfig < $< > $@
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
new file mode 100644
index 0000000..b45260b
--- /dev/null
+++ b/scripts/mod/devicetable-offsets.c
@@ -0,0 +1,178 @@
+#include <linux/kbuild.h>
+#include <linux/mod_devicetable.h>
+
+#define DEVID(devid) DEFINE(SIZE_##devid, sizeof(struct devid))
+#define DEVID_FIELD(devid, field) \
+	DEFINE(OFF_##devid##_##field, offsetof(struct devid, field))
+
+int main(void)
+{
+	DEVID(usb_device_id);
+	DEVID_FIELD(usb_device_id, match_flags);
+	DEVID_FIELD(usb_device_id, idVendor);
+	DEVID_FIELD(usb_device_id, idProduct);
+	DEVID_FIELD(usb_device_id, bcdDevice_lo);
+	DEVID_FIELD(usb_device_id, bcdDevice_hi);
+	DEVID_FIELD(usb_device_id, bDeviceClass);
+	DEVID_FIELD(usb_device_id, bDeviceSubClass);
+	DEVID_FIELD(usb_device_id, bDeviceProtocol);
+	DEVID_FIELD(usb_device_id, bInterfaceClass);
+	DEVID_FIELD(usb_device_id, bInterfaceSubClass);
+	DEVID_FIELD(usb_device_id, bInterfaceProtocol);
+	DEVID_FIELD(usb_device_id, bInterfaceNumber);
+
+	DEVID(hid_device_id);
+	DEVID_FIELD(hid_device_id, bus);
+	DEVID_FIELD(hid_device_id, group);
+	DEVID_FIELD(hid_device_id, vendor);
+	DEVID_FIELD(hid_device_id, product);
+
+	DEVID(ieee1394_device_id);
+	DEVID_FIELD(ieee1394_device_id, match_flags);
+	DEVID_FIELD(ieee1394_device_id, vendor_id);
+	DEVID_FIELD(ieee1394_device_id, model_id);
+	DEVID_FIELD(ieee1394_device_id, specifier_id);
+	DEVID_FIELD(ieee1394_device_id, version);
+
+	DEVID(pci_device_id);
+	DEVID_FIELD(pci_device_id, vendor);
+	DEVID_FIELD(pci_device_id, device);
+	DEVID_FIELD(pci_device_id, subvendor);
+	DEVID_FIELD(pci_device_id, subdevice);
+	DEVID_FIELD(pci_device_id, class);
+	DEVID_FIELD(pci_device_id, class_mask);
+
+	DEVID(ccw_device_id);
+	DEVID_FIELD(ccw_device_id, match_flags);
+	DEVID_FIELD(ccw_device_id, cu_type);
+	DEVID_FIELD(ccw_device_id, cu_model);
+	DEVID_FIELD(ccw_device_id, dev_type);
+	DEVID_FIELD(ccw_device_id, dev_model);
+
+	DEVID(ap_device_id);
+	DEVID_FIELD(ap_device_id, dev_type);
+
+	DEVID(css_device_id);
+	DEVID_FIELD(css_device_id, type);
+
+	DEVID(serio_device_id);
+	DEVID_FIELD(serio_device_id, type);
+	DEVID_FIELD(serio_device_id, proto);
+	DEVID_FIELD(serio_device_id, id);
+	DEVID_FIELD(serio_device_id, extra);
+
+	DEVID(acpi_device_id);
+	DEVID_FIELD(acpi_device_id, id);
+
+	DEVID(pnp_device_id);
+	DEVID_FIELD(pnp_device_id, id);
+
+	DEVID(pnp_card_device_id);
+	DEVID_FIELD(pnp_card_device_id, devs);
+
+	DEVID(pcmcia_device_id);
+	DEVID_FIELD(pcmcia_device_id, match_flags);
+	DEVID_FIELD(pcmcia_device_id, manf_id);
+	DEVID_FIELD(pcmcia_device_id, card_id);
+	DEVID_FIELD(pcmcia_device_id, func_id);
+	DEVID_FIELD(pcmcia_device_id, function);
+	DEVID_FIELD(pcmcia_device_id, device_no);
+	DEVID_FIELD(pcmcia_device_id, prod_id_hash);
+
+	DEVID(of_device_id);
+	DEVID_FIELD(of_device_id, name);
+	DEVID_FIELD(of_device_id, type);
+	DEVID_FIELD(of_device_id, compatible);
+
+	DEVID(vio_device_id);
+	DEVID_FIELD(vio_device_id, type);
+	DEVID_FIELD(vio_device_id, compat);
+
+	DEVID(input_device_id);
+	DEVID_FIELD(input_device_id, flags);
+	DEVID_FIELD(input_device_id, bustype);
+	DEVID_FIELD(input_device_id, vendor);
+	DEVID_FIELD(input_device_id, product);
+	DEVID_FIELD(input_device_id, version);
+	DEVID_FIELD(input_device_id, evbit);
+	DEVID_FIELD(input_device_id, keybit);
+	DEVID_FIELD(input_device_id, relbit);
+	DEVID_FIELD(input_device_id, absbit);
+	DEVID_FIELD(input_device_id, mscbit);
+	DEVID_FIELD(input_device_id, ledbit);
+	DEVID_FIELD(input_device_id, sndbit);
+	DEVID_FIELD(input_device_id, ffbit);
+	DEVID_FIELD(input_device_id, swbit);
+
+	DEVID(eisa_device_id);
+	DEVID_FIELD(eisa_device_id, sig);
+
+	DEVID(parisc_device_id);
+	DEVID_FIELD(parisc_device_id, hw_type);
+	DEVID_FIELD(parisc_device_id, hversion);
+	DEVID_FIELD(parisc_device_id, hversion_rev);
+	DEVID_FIELD(parisc_device_id, sversion);
+
+	DEVID(sdio_device_id);
+	DEVID_FIELD(sdio_device_id, class);
+	DEVID_FIELD(sdio_device_id, vendor);
+	DEVID_FIELD(sdio_device_id, device);
+
+	DEVID(ssb_device_id);
+	DEVID_FIELD(ssb_device_id, vendor);
+	DEVID_FIELD(ssb_device_id, coreid);
+	DEVID_FIELD(ssb_device_id, revision);
+
+	DEVID(bcma_device_id);
+	DEVID_FIELD(bcma_device_id, manuf);
+	DEVID_FIELD(bcma_device_id, id);
+	DEVID_FIELD(bcma_device_id, rev);
+	DEVID_FIELD(bcma_device_id, class);
+
+	DEVID(virtio_device_id);
+	DEVID_FIELD(virtio_device_id, device);
+	DEVID_FIELD(virtio_device_id, vendor);
+
+	DEVID(hv_vmbus_device_id);
+	DEVID_FIELD(hv_vmbus_device_id, guid);
+
+	DEVID(i2c_device_id);
+	DEVID_FIELD(i2c_device_id, name);
+
+	DEVID(spi_device_id);
+	DEVID_FIELD(spi_device_id, name);
+
+	DEVID(dmi_system_id);
+	DEVID_FIELD(dmi_system_id, matches);
+
+	DEVID(platform_device_id);
+	DEVID_FIELD(platform_device_id, name);
+
+	DEVID(mdio_device_id);
+	DEVID_FIELD(mdio_device_id, phy_id);
+	DEVID_FIELD(mdio_device_id, phy_id_mask);
+
+	DEVID(zorro_device_id);
+	DEVID_FIELD(zorro_device_id, id);
+
+	DEVID(isapnp_device_id);
+	DEVID_FIELD(isapnp_device_id, vendor);
+	DEVID_FIELD(isapnp_device_id, function);
+
+	DEVID(ipack_device_id);
+	DEVID_FIELD(ipack_device_id, format);
+	DEVID_FIELD(ipack_device_id, vendor);
+	DEVID_FIELD(ipack_device_id, device);
+
+	DEVID(amba_id);
+	DEVID_FIELD(amba_id, id);
+	DEVID_FIELD(amba_id, mask);
+
+	DEVID(x86_cpu_id);
+	DEVID_FIELD(x86_cpu_id, feature);
+	DEVID_FIELD(x86_cpu_id, family);
+	DEVID_FIELD(x86_cpu_id, model);
+	DEVID_FIELD(x86_cpu_id, vendor);
+
+	return 0;
+}
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index df4fc23..771ac17 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -11,6 +11,7 @@
  */
 
 #include "modpost.h"
+#include "devicetable-offsets.h"
 
 /* We use the ELF typedefs for kernel_ulong_t but bite the bullet and
  * use either stdint.h or inttypes.h for the rest. */
@@ -84,13 +85,25 @@ extern struct devtable *__start___devtable[], *__stop___devtable[];
 # define __used			__attribute__((__used__))
 #endif
 
+/* Define a variable f that holds the value of field f of struct devid
+ * based at address m.
+ */
+#define DEF_FIELD(m, devid, f) \
+	typeof(((struct devid *)0)->f) f = TO_NATIVE(*(typeof(f) *)((m) + OFF_##devid##_##f))
+/* Define a variable f that holds the address of field f of struct devid
+ * based at address m.  Due to the way typeof works, for a field of type
+ * T[N] the variable has type T(*)[N], _not_ T*.
+ */
+#define DEF_FIELD_ADDR(m, devid, f) \
+	typeof(((struct devid *)0)->f) *f = ((m) + OFF_##devid##_##f)
+
 /* Add a table entry.  We test function type matches while we're here. */
 #define ADD_TO_DEVTABLE(device_id, type, function) \
 	static struct devtable __cat(devtable,__LINE__) = {	\
 		device_id + 0*sizeof((function)((const char *)NULL,	\
-						(type *)NULL,		\
+						(void *)NULL,		\
 						(char *)NULL)),		\
-		sizeof(type), (function) };				\
+		SIZE_##type, (function) };				\
 	static struct devtable *SECTION(__devtable) __used \
 		__cat(devtable_ptr,__LINE__) = &__cat(devtable,__LINE__)
 
@@ -116,7 +129,6 @@ static inline void add_wildcard(char *str)
 		strcat(str + len, "*");
 }
 
-unsigned int cross_build = 0;
 /**
  * Check that sizeof(device_id type) are consistent with size of section
  * in .o file. If in-consistent then userspace and kernel does not agree
@@ -131,8 +143,6 @@ static void device_id_check(const char *modname, const char *device_id,
 	int i;
 
 	if (size % id_size || size < id_size) {
-		if (cross_build != 0)
-			return;
 		fatal("%s: sizeof(struct %s_device_id)=%lu is not a modulo "
 		      "of the size of section __mod_%s_device_table=%lu.\n"
 		      "Fix definition of struct %s_device_id "
@@ -157,17 +167,29 @@ static void device_id_check(const char *modname, const char *device_id,
 
 /* USB is special because the bcdDevice can be matched against a numeric range */
 /* Looks like "usb:vNpNdNdcNdscNdpNicNiscNipNinN" */
-static void do_usb_entry(struct usb_device_id *id,
+static void do_usb_entry(void *symval,
 			 unsigned int bcdDevice_initial, int bcdDevice_initial_digits,
 			 unsigned char range_lo, unsigned char range_hi,
 			 unsigned char max, struct module *mod)
 {
 	char alias[500];
+	DEF_FIELD(symval, usb_device_id, match_flags);
+	DEF_FIELD(symval, usb_device_id, idVendor);
+	DEF_FIELD(symval, usb_device_id, idProduct);
+	DEF_FIELD(symval, usb_device_id, bcdDevice_lo);
+	DEF_FIELD(symval, usb_device_id, bDeviceClass);
+	DEF_FIELD(symval, usb_device_id, bDeviceSubClass);
+	DEF_FIELD(symval, usb_device_id, bDeviceProtocol);
+	DEF_FIELD(symval, usb_device_id, bInterfaceClass);
+	DEF_FIELD(symval, usb_device_id, bInterfaceSubClass);
+	DEF_FIELD(symval, usb_device_id, bInterfaceProtocol);
+	DEF_FIELD(symval, usb_device_id, bInterfaceNumber);
+
 	strcpy(alias, "usb:");
-	ADD(alias, "v", id->match_flags&USB_DEVICE_ID_MATCH_VENDOR,
-	    id->idVendor);
-	ADD(alias, "p", id->match_flags&USB_DEVICE_ID_MATCH_PRODUCT,
-	    id->idProduct);
+	ADD(alias, "v", match_flags&USB_DEVICE_ID_MATCH_VENDOR,
+	    idVendor);
+	ADD(alias, "p", match_flags&USB_DEVICE_ID_MATCH_PRODUCT,
+	    idProduct);
 
 	strcat(alias, "d");
 	if (bcdDevice_initial_digits)
@@ -190,29 +212,23 @@ static void do_usb_entry(struct usb_device_id *id,
 				range_lo);
 		}
 	}
-	if (bcdDevice_initial_digits < (sizeof(id->bcdDevice_lo) * 2 - 1))
+	if (bcdDevice_initial_digits < (sizeof(bcdDevice_lo) * 2 - 1))
 		strcat(alias, "*");
 
-	ADD(alias, "dc", id->match_flags&USB_DEVICE_ID_MATCH_DEV_CLASS,
-	    id->bDeviceClass);
-	ADD(alias, "dsc",
-	    id->match_flags&USB_DEVICE_ID_MATCH_DEV_SUBCLASS,
-	    id->bDeviceSubClass);
-	ADD(alias, "dp",
-	    id->match_flags&USB_DEVICE_ID_MATCH_DEV_PROTOCOL,
-	    id->bDeviceProtocol);
-	ADD(alias, "ic",
-	    id->match_flags&USB_DEVICE_ID_MATCH_INT_CLASS,
-	    id->bInterfaceClass);
-	ADD(alias, "isc",
-	    id->match_flags&USB_DEVICE_ID_MATCH_INT_SUBCLASS,
-	    id->bInterfaceSubClass);
-	ADD(alias, "ip",
-	    id->match_flags&USB_DEVICE_ID_MATCH_INT_PROTOCOL,
-	    id->bInterfaceProtocol);
-	ADD(alias, "in",
-	    id->match_flags&USB_DEVICE_ID_MATCH_INT_NUMBER,
-	    id->bInterfaceNumber);
+	ADD(alias, "dc", match_flags&USB_DEVICE_ID_MATCH_DEV_CLASS,
+	    bDeviceClass);
+	ADD(alias, "dsc", match_flags&USB_DEVICE_ID_MATCH_DEV_SUBCLASS,
+	    bDeviceSubClass);
+	ADD(alias, "dp", match_flags&USB_DEVICE_ID_MATCH_DEV_PROTOCOL,
+	    bDeviceProtocol);
+	ADD(alias, "ic", match_flags&USB_DEVICE_ID_MATCH_INT_CLASS,
+	    bInterfaceClass);
+	ADD(alias, "isc", match_flags&USB_DEVICE_ID_MATCH_INT_SUBCLASS,
+	    bInterfaceSubClass);
+	ADD(alias, "ip", match_flags&USB_DEVICE_ID_MATCH_INT_PROTOCOL,
+	    bInterfaceProtocol);
+	ADD(alias, "in", match_flags&USB_DEVICE_ID_MATCH_INT_NUMBER,
+	    bInterfaceNumber);
 
 	add_wildcard(alias);
 	buf_printf(&mod->dev_table_buf,
@@ -258,24 +274,28 @@ static unsigned int incbcd(unsigned int *bcd,
 	return init;
 }
 
-static void do_usb_entry_multi(struct usb_device_id *id, struct module *mod)
+static void do_usb_entry_multi(void *symval, struct module *mod)
 {
 	unsigned int devlo, devhi;
 	unsigned char chi, clo, max;
 	int ndigits;
 
-	id->match_flags = TO_NATIVE(id->match_flags);
-	id->idVendor = TO_NATIVE(id->idVendor);
-	id->idProduct = TO_NATIVE(id->idProduct);
+	DEF_FIELD(symval, usb_device_id, match_flags);
+	DEF_FIELD(symval, usb_device_id, idVendor);
+	DEF_FIELD(symval, usb_device_id, idProduct);
+	DEF_FIELD(symval, usb_device_id, bcdDevice_lo);
+	DEF_FIELD(symval, usb_device_id, bcdDevice_hi);
+	DEF_FIELD(symval, usb_device_id, bDeviceClass);
+	DEF_FIELD(symval, usb_device_id, bInterfaceClass);
 
-	devlo = id->match_flags & USB_DEVICE_ID_MATCH_DEV_LO ?
-		TO_NATIVE(id->bcdDevice_lo) : 0x0U;
-	devhi = id->match_flags & USB_DEVICE_ID_MATCH_DEV_HI ?
-		TO_NATIVE(id->bcdDevice_hi) : ~0x0U;
+	devlo = match_flags & USB_DEVICE_ID_MATCH_DEV_LO ?
+		bcdDevice_lo : 0x0U;
+	devhi = match_flags & USB_DEVICE_ID_MATCH_DEV_HI ?
+		bcdDevice_hi : ~0x0U;
 
 	/* Figure out if this entry is in bcd or hex format */
 	max = 0x9; /* Default to decimal format */
-	for (ndigits = 0 ; ndigits < sizeof(id->bcdDevice_lo) * 2 ; ndigits++) {
+	for (ndigits = 0 ; ndigits < sizeof(bcdDevice_lo) * 2 ; ndigits++) {
 		clo = (devlo >> (ndigits << 2)) & 0xf;
 		chi = ((devhi > 0x9999 ? 0x9999 : devhi) >> (ndigits << 2)) & 0xf;
 		if (clo > max || chi > max) {
@@ -288,11 +308,11 @@ static void do_usb_entry_multi(struct usb_device_id *id, struct module *mod)
 	 * Some modules (visor) have empty slots as placeholder for
 	 * run-time specification that results in catch-all alias
 	 */
-	if (!(id->idVendor | id->idProduct | id->bDeviceClass | id->bInterfaceClass))
+	if (!(idVendor | idProduct | bDeviceClass | bInterfaceClass))
 		return;
 
 	/* Convert numeric bcdDevice range into fnmatch-able pattern(s) */
-	for (ndigits = sizeof(id->bcdDevice_lo) * 2 - 1; devlo <= devhi; ndigits--) {
+	for (ndigits = sizeof(bcdDevice_lo) * 2 - 1; devlo <= devhi; ndigits--) {
 		clo = devlo & 0xf;
 		chi = devhi & 0xf;
 		if (chi > max)	/* If we are in bcd mode, truncate if necessary */
@@ -301,20 +321,20 @@ static void do_usb_entry_multi(struct usb_device_id *id, struct module *mod)
 		devhi >>= 4;
 
 		if (devlo == devhi || !ndigits) {
-			do_usb_entry(id, devlo, ndigits, clo, chi, max, mod);
+			do_usb_entry(symval, devlo, ndigits, clo, chi, max, mod);
 			break;
 		}
 
 		if (clo > 0x0)
-			do_usb_entry(id,
+			do_usb_entry(symval,
 				     incbcd(&devlo, 1, max,
-					    sizeof(id->bcdDevice_lo) * 2),
+					    sizeof(bcdDevice_lo) * 2),
 				     ndigits, clo, max, max, mod);
 
 		if (chi < max)
-			do_usb_entry(id,
+			do_usb_entry(symval,
 				     incbcd(&devhi, -1, max,
-					    sizeof(id->bcdDevice_lo) * 2),
+					    sizeof(bcdDevice_lo) * 2),
 				     ndigits, 0x0, chi, max, mod);
 	}
 }
@@ -323,7 +343,7 @@ static void do_usb_table(void *symval, unsigned long size,
 			 struct module *mod)
 {
 	unsigned int i;
-	const unsigned long id_size = sizeof(struct usb_device_id);
+	const unsigned long id_size = SIZE_usb_device_id;
 
 	device_id_check(mod->name, "usb", size, id_size, symval);
 
@@ -336,81 +356,81 @@ static void do_usb_table(void *symval, unsigned long size,
 
 /* Looks like: hid:bNvNpN */
 static int do_hid_entry(const char *filename,
-			     struct hid_device_id *id, char *alias)
+			     void *symval, char *alias)
 {
-	id->bus = TO_NATIVE(id->bus);
-	id->group = TO_NATIVE(id->group);
-	id->vendor = TO_NATIVE(id->vendor);
-	id->product = TO_NATIVE(id->product);
+	DEF_FIELD(symval, hid_device_id, bus);
+	DEF_FIELD(symval, hid_device_id, group);
+	DEF_FIELD(symval, hid_device_id, vendor);
+	DEF_FIELD(symval, hid_device_id, product);
 
 	sprintf(alias, "hid:");
-	ADD(alias, "b", id->bus != HID_BUS_ANY, id->bus);
-	ADD(alias, "g", id->group != HID_GROUP_ANY, id->group);
-	ADD(alias, "v", id->vendor != HID_ANY_ID, id->vendor);
-	ADD(alias, "p", id->product != HID_ANY_ID, id->product);
+	ADD(alias, "b", bus != HID_BUS_ANY, bus);
+	ADD(alias, "g", group != HID_GROUP_ANY, group);
+	ADD(alias, "v", vendor != HID_ANY_ID, vendor);
+	ADD(alias, "p", product != HID_ANY_ID, product);
 
 	return 1;
 }
-ADD_TO_DEVTABLE("hid", struct hid_device_id, do_hid_entry);
+ADD_TO_DEVTABLE("hid", hid_device_id, do_hid_entry);
 
 /* Looks like: ieee1394:venNmoNspNverN */
 static int do_ieee1394_entry(const char *filename,
-			     struct ieee1394_device_id *id, char *alias)
+			     void *symval, char *alias)
 {
-	id->match_flags = TO_NATIVE(id->match_flags);
-	id->vendor_id = TO_NATIVE(id->vendor_id);
-	id->model_id = TO_NATIVE(id->model_id);
-	id->specifier_id = TO_NATIVE(id->specifier_id);
-	id->version = TO_NATIVE(id->version);
+	DEF_FIELD(symval, ieee1394_device_id, match_flags);
+	DEF_FIELD(symval, ieee1394_device_id, vendor_id);
+	DEF_FIELD(symval, ieee1394_device_id, model_id);
+	DEF_FIELD(symval, ieee1394_device_id, specifier_id);
+	DEF_FIELD(symval, ieee1394_device_id, version);
 
 	strcpy(alias, "ieee1394:");
-	ADD(alias, "ven", id->match_flags & IEEE1394_MATCH_VENDOR_ID,
-	    id->vendor_id);
-	ADD(alias, "mo", id->match_flags & IEEE1394_MATCH_MODEL_ID,
-	    id->model_id);
-	ADD(alias, "sp", id->match_flags & IEEE1394_MATCH_SPECIFIER_ID,
-	    id->specifier_id);
-	ADD(alias, "ver", id->match_flags & IEEE1394_MATCH_VERSION,
-	    id->version);
+	ADD(alias, "ven", match_flags & IEEE1394_MATCH_VENDOR_ID,
+	    vendor_id);
+	ADD(alias, "mo", match_flags & IEEE1394_MATCH_MODEL_ID,
+	    model_id);
+	ADD(alias, "sp", match_flags & IEEE1394_MATCH_SPECIFIER_ID,
+	    specifier_id);
+	ADD(alias, "ver", match_flags & IEEE1394_MATCH_VERSION,
+	    version);
 
 	add_wildcard(alias);
 	return 1;
 }
-ADD_TO_DEVTABLE("ieee1394", struct ieee1394_device_id, do_ieee1394_entry);
+ADD_TO_DEVTABLE("ieee1394", ieee1394_device_id, do_ieee1394_entry);
 
 /* Looks like: pci:vNdNsvNsdNbcNscNiN. */
 static int do_pci_entry(const char *filename,
-			struct pci_device_id *id, char *alias)
+			void *symval, char *alias)
 {
 	/* Class field can be divided into these three. */
 	unsigned char baseclass, subclass, interface,
 		baseclass_mask, subclass_mask, interface_mask;
 
-	id->vendor = TO_NATIVE(id->vendor);
-	id->device = TO_NATIVE(id->device);
-	id->subvendor = TO_NATIVE(id->subvendor);
-	id->subdevice = TO_NATIVE(id->subdevice);
-	id->class = TO_NATIVE(id->class);
-	id->class_mask = TO_NATIVE(id->class_mask);
+	DEF_FIELD(symval, pci_device_id, vendor);
+	DEF_FIELD(symval, pci_device_id, device);
+	DEF_FIELD(symval, pci_device_id, subvendor);
+	DEF_FIELD(symval, pci_device_id, subdevice);
+	DEF_FIELD(symval, pci_device_id, class);
+	DEF_FIELD(symval, pci_device_id, class_mask);
 
 	strcpy(alias, "pci:");
-	ADD(alias, "v", id->vendor != PCI_ANY_ID, id->vendor);
-	ADD(alias, "d", id->device != PCI_ANY_ID, id->device);
-	ADD(alias, "sv", id->subvendor != PCI_ANY_ID, id->subvendor);
-	ADD(alias, "sd", id->subdevice != PCI_ANY_ID, id->subdevice);
-
-	baseclass = (id->class) >> 16;
-	baseclass_mask = (id->class_mask) >> 16;
-	subclass = (id->class) >> 8;
-	subclass_mask = (id->class_mask) >> 8;
-	interface = id->class;
-	interface_mask = id->class_mask;
+	ADD(alias, "v", vendor != PCI_ANY_ID, vendor);
+	ADD(alias, "d", device != PCI_ANY_ID, device);
+	ADD(alias, "sv", subvendor != PCI_ANY_ID, subvendor);
+	ADD(alias, "sd", subdevice != PCI_ANY_ID, subdevice);
+
+	baseclass = (class) >> 16;
+	baseclass_mask = (class_mask) >> 16;
+	subclass = (class) >> 8;
+	subclass_mask = (class_mask) >> 8;
+	interface = class;
+	interface_mask = class_mask;
 
 	if ((baseclass_mask != 0 && baseclass_mask != 0xFF)
 	    || (subclass_mask != 0 && subclass_mask != 0xFF)
 	    || (interface_mask != 0 && interface_mask != 0xFF)) {
 		warn("Can't handle masks in %s:%04X\n",
-		     filename, id->class_mask);
+		     filename, class_mask);
 		return 0;
 	}
 
@@ -420,101 +440,105 @@ static int do_pci_entry(const char *filename,
 	add_wildcard(alias);
 	return 1;
 }
-ADD_TO_DEVTABLE("pci", struct pci_device_id, do_pci_entry);
+ADD_TO_DEVTABLE("pci", pci_device_id, do_pci_entry);
 
 /* looks like: "ccw:tNmNdtNdmN" */
 static int do_ccw_entry(const char *filename,
-			struct ccw_device_id *id, char *alias)
+			void *symval, char *alias)
 {
-	id->match_flags = TO_NATIVE(id->match_flags);
-	id->cu_type = TO_NATIVE(id->cu_type);
-	id->cu_model = TO_NATIVE(id->cu_model);
-	id->dev_type = TO_NATIVE(id->dev_type);
-	id->dev_model = TO_NATIVE(id->dev_model);
+	DEF_FIELD(symval, ccw_device_id, match_flags);
+	DEF_FIELD(symval, ccw_device_id, cu_type);
+	DEF_FIELD(symval, ccw_device_id, cu_model);
+	DEF_FIELD(symval, ccw_device_id, dev_type);
+	DEF_FIELD(symval, ccw_device_id, dev_model);
 
 	strcpy(alias, "ccw:");
-	ADD(alias, "t", id->match_flags&CCW_DEVICE_ID_MATCH_CU_TYPE,
-	    id->cu_type);
-	ADD(alias, "m", id->match_flags&CCW_DEVICE_ID_MATCH_CU_MODEL,
-	    id->cu_model);
-	ADD(alias, "dt", id->match_flags&CCW_DEVICE_ID_MATCH_DEVICE_TYPE,
-	    id->dev_type);
-	ADD(alias, "dm", id->match_flags&CCW_DEVICE_ID_MATCH_DEVICE_MODEL,
-	    id->dev_model);
+	ADD(alias, "t", match_flags&CCW_DEVICE_ID_MATCH_CU_TYPE,
+	    cu_type);
+	ADD(alias, "m", match_flags&CCW_DEVICE_ID_MATCH_CU_MODEL,
+	    cu_model);
+	ADD(alias, "dt", match_flags&CCW_DEVICE_ID_MATCH_DEVICE_TYPE,
+	    dev_type);
+	ADD(alias, "dm", match_flags&CCW_DEVICE_ID_MATCH_DEVICE_MODEL,
+	    dev_model);
 	add_wildcard(alias);
 	return 1;
 }
-ADD_TO_DEVTABLE("ccw", struct ccw_device_id, do_ccw_entry);
+ADD_TO_DEVTABLE("ccw", ccw_device_id, do_ccw_entry);
 
 /* looks like: "ap:tN" */
 static int do_ap_entry(const char *filename,
-		       struct ap_device_id *id, char *alias)
+		       void *symval, char *alias)
 {
-	sprintf(alias, "ap:t%02X*", id->dev_type);
+	DEF_FIELD(symval, ap_device_id, dev_type);
+
+	sprintf(alias, "ap:t%02X*", dev_type);
 	return 1;
 }
-ADD_TO_DEVTABLE("ap", struct ap_device_id, do_ap_entry);
+ADD_TO_DEVTABLE("ap", ap_device_id, do_ap_entry);
 
 /* looks like: "css:tN" */
 static int do_css_entry(const char *filename,
-			struct css_device_id *id, char *alias)
+			void *symval, char *alias)
 {
-	sprintf(alias, "css:t%01X", id->type);
+	DEF_FIELD(symval, css_device_id, type);
+
+	sprintf(alias, "css:t%01X", type);
 	return 1;
 }
-ADD_TO_DEVTABLE("css", struct css_device_id, do_css_entry);
+ADD_TO_DEVTABLE("css", css_device_id, do_css_entry);
 
 /* Looks like: "serio:tyNprNidNexN" */
 static int do_serio_entry(const char *filename,
-			  struct serio_device_id *id, char *alias)
+			  void *symval, char *alias)
 {
-	id->type = TO_NATIVE(id->type);
-	id->proto = TO_NATIVE(id->proto);
-	id->id = TO_NATIVE(id->id);
-	id->extra = TO_NATIVE(id->extra);
+	DEF_FIELD(symval, serio_device_id, type);
+	DEF_FIELD(symval, serio_device_id, proto);
+	DEF_FIELD(symval, serio_device_id, id);
+	DEF_FIELD(symval, serio_device_id, extra);
 
 	strcpy(alias, "serio:");
-	ADD(alias, "ty", id->type != SERIO_ANY, id->type);
-	ADD(alias, "pr", id->proto != SERIO_ANY, id->proto);
-	ADD(alias, "id", id->id != SERIO_ANY, id->id);
-	ADD(alias, "ex", id->extra != SERIO_ANY, id->extra);
+	ADD(alias, "ty", type != SERIO_ANY, type);
+	ADD(alias, "pr", proto != SERIO_ANY, proto);
+	ADD(alias, "id", id != SERIO_ANY, id);
+	ADD(alias, "ex", extra != SERIO_ANY, extra);
 
 	add_wildcard(alias);
 	return 1;
 }
-ADD_TO_DEVTABLE("serio", struct serio_device_id, do_serio_entry);
+ADD_TO_DEVTABLE("serio", serio_device_id, do_serio_entry);
 
 /* looks like: "acpi:ACPI0003 or acpi:PNP0C0B" or "acpi:LNXVIDEO" */
 static int do_acpi_entry(const char *filename,
-			struct acpi_device_id *id, char *alias)
+			void *symval, char *alias)
 {
-	sprintf(alias, "acpi*:%s:*", id->id);
+	DEF_FIELD_ADDR(symval, acpi_device_id, id);
+	sprintf(alias, "acpi*:%s:*", *id);
 	return 1;
 }
-ADD_TO_DEVTABLE("acpi", struct acpi_device_id, do_acpi_entry);
+ADD_TO_DEVTABLE("acpi", acpi_device_id, do_acpi_entry);
 
 /* looks like: "pnp:dD" */
 static void do_pnp_device_entry(void *symval, unsigned long size,
 				struct module *mod)
 {
-	const unsigned long id_size = sizeof(struct pnp_device_id);
+	const unsigned long id_size = SIZE_pnp_device_id;
 	const unsigned int count = (size / id_size)-1;
-	const struct pnp_device_id *devs = symval;
 	unsigned int i;
 
 	device_id_check(mod->name, "pnp", size, id_size, symval);
 
 	for (i = 0; i < count; i++) {
-		const char *id = (char *)devs[i].id;
-		char acpi_id[sizeof(devs[0].id)];
+		DEF_FIELD_ADDR(symval + i*id_size, pnp_device_id, id);
+		char acpi_id[sizeof(*id)];
 		int j;
 
 		buf_printf(&mod->dev_table_buf,
-			   "MODULE_ALIAS(\"pnp:d%s*\");\n", id);
+			   "MODULE_ALIAS(\"pnp:d%s*\");\n", *id);
 
 		/* fix broken pnp bus lowercasing */
 		for (j = 0; j < sizeof(acpi_id); j++)
-			acpi_id[j] = toupper(id[j]);
+			acpi_id[j] = toupper((*id)[j]);
 		buf_printf(&mod->dev_table_buf,
 			   "MODULE_ALIAS(\"acpi*:%s:*\");\n", acpi_id);
 	}
@@ -524,19 +548,18 @@ static void do_pnp_device_entry(void *symval, unsigned long size,
 static void do_pnp_card_entries(void *symval, unsigned long size,
 				struct module *mod)
 {
-	const unsigned long id_size = sizeof(struct pnp_card_device_id);
+	const unsigned long id_size = SIZE_pnp_card_device_id;
 	const unsigned int count = (size / id_size)-1;
-	const struct pnp_card_device_id *cards = symval;
 	unsigned int i;
 
 	device_id_check(mod->name, "pnp", size, id_size, symval);
 
 	for (i = 0; i < count; i++) {
 		unsigned int j;
-		const struct pnp_card_device_id *card = &cards[i];
+		DEF_FIELD_ADDR(symval + i*id_size, pnp_card_device_id, devs);
 
 		for (j = 0; j < PNP_MAX_DEVICES; j++) {
-			const char *id = (char *)card->devs[j].id;
+			const char *id = (char *)(*devs)[j].id;
 			int i2, j2;
 			int dup = 0;
 
@@ -545,10 +568,10 @@ static void do_pnp_card_entries(void *symval, unsigned long size,
 
 			/* find duplicate, already added value */
 			for (i2 = 0; i2 < i && !dup; i2++) {
-				const struct pnp_card_device_id *card2 = &cards[i2];
+				DEF_FIELD_ADDR(symval + i2*id_size, pnp_card_device_id, devs);
 
 				for (j2 = 0; j2 < PNP_MAX_DEVICES; j2++) {
-					const char *id2 = (char *)card2->devs[j2].id;
+					const char *id2 = (char *)(*devs)[j2].id;
 
 					if (!id2[0])
 						break;
@@ -562,7 +585,7 @@ static void do_pnp_card_entries(void *symval, unsigned long size,
 
 			/* add an individual alias for every device entry */
 			if (!dup) {
-				char acpi_id[sizeof(card->devs[0].id)];
+				char acpi_id[PNP_ID_LEN];
 				int k;
 
 				buf_printf(&mod->dev_table_buf,
@@ -580,54 +603,58 @@ static void do_pnp_card_entries(void *symval, unsigned long size,
 
 /* Looks like: pcmcia:mNcNfNfnNpfnNvaNvbNvcNvdN. */
 static int do_pcmcia_entry(const char *filename,
-			   struct pcmcia_device_id *id, char *alias)
+			   void *symval, char *alias)
 {
 	unsigned int i;
-
-	id->match_flags = TO_NATIVE(id->match_flags);
-	id->manf_id = TO_NATIVE(id->manf_id);
-	id->card_id = TO_NATIVE(id->card_id);
-	id->func_id = TO_NATIVE(id->func_id);
-	id->function = TO_NATIVE(id->function);
-	id->device_no = TO_NATIVE(id->device_no);
+	DEF_FIELD(symval, pcmcia_device_id, match_flags);
+	DEF_FIELD(symval, pcmcia_device_id, manf_id);
+	DEF_FIELD(symval, pcmcia_device_id, card_id);
+	DEF_FIELD(symval, pcmcia_device_id, func_id);
+	DEF_FIELD(symval, pcmcia_device_id, function);
+	DEF_FIELD(symval, pcmcia_device_id, device_no);
+	DEF_FIELD_ADDR(symval, pcmcia_device_id, prod_id_hash);
 
 	for (i=0; i<4; i++) {
-		id->prod_id_hash[i] = TO_NATIVE(id->prod_id_hash[i]);
-       }
-
-       strcpy(alias, "pcmcia:");
-       ADD(alias, "m", id->match_flags & PCMCIA_DEV_ID_MATCH_MANF_ID,
-	   id->manf_id);
-       ADD(alias, "c", id->match_flags & PCMCIA_DEV_ID_MATCH_CARD_ID,
-	   id->card_id);
-       ADD(alias, "f", id->match_flags & PCMCIA_DEV_ID_MATCH_FUNC_ID,
-	   id->func_id);
-       ADD(alias, "fn", id->match_flags & PCMCIA_DEV_ID_MATCH_FUNCTION,
-	   id->function);
-       ADD(alias, "pfn", id->match_flags & PCMCIA_DEV_ID_MATCH_DEVICE_NO,
-	   id->device_no);
-       ADD(alias, "pa", id->match_flags & PCMCIA_DEV_ID_MATCH_PROD_ID1, id->prod_id_hash[0]);
-       ADD(alias, "pb", id->match_flags & PCMCIA_DEV_ID_MATCH_PROD_ID2, id->prod_id_hash[1]);
-       ADD(alias, "pc", id->match_flags & PCMCIA_DEV_ID_MATCH_PROD_ID3, id->prod_id_hash[2]);
-       ADD(alias, "pd", id->match_flags & PCMCIA_DEV_ID_MATCH_PROD_ID4, id->prod_id_hash[3]);
+		(*prod_id_hash)[i] = TO_NATIVE((*prod_id_hash)[i]);
+	}
+
+	strcpy(alias, "pcmcia:");
+	ADD(alias, "m", match_flags & PCMCIA_DEV_ID_MATCH_MANF_ID,
+	    manf_id);
+	ADD(alias, "c", match_flags & PCMCIA_DEV_ID_MATCH_CARD_ID,
+	    card_id);
+	ADD(alias, "f", match_flags & PCMCIA_DEV_ID_MATCH_FUNC_ID,
+	    func_id);
+	ADD(alias, "fn", match_flags & PCMCIA_DEV_ID_MATCH_FUNCTION,
+	    function);
+	ADD(alias, "pfn", match_flags & PCMCIA_DEV_ID_MATCH_DEVICE_NO,
+	    device_no);
+	ADD(alias, "pa", match_flags & PCMCIA_DEV_ID_MATCH_PROD_ID1, (*prod_id_hash)[0]);
+	ADD(alias, "pb", match_flags & PCMCIA_DEV_ID_MATCH_PROD_ID2, (*prod_id_hash)[1]);
+	ADD(alias, "pc", match_flags & PCMCIA_DEV_ID_MATCH_PROD_ID3, (*prod_id_hash)[2]);
+	ADD(alias, "pd", match_flags & PCMCIA_DEV_ID_MATCH_PROD_ID4, (*prod_id_hash)[3]);
 
 	add_wildcard(alias);
-       return 1;
+	return 1;
 }
-ADD_TO_DEVTABLE("pcmcia", struct pcmcia_device_id, do_pcmcia_entry);
+ADD_TO_DEVTABLE("pcmcia", pcmcia_device_id, do_pcmcia_entry);
 
-static int do_of_entry (const char *filename, struct of_device_id *of, char *alias)
+static int do_of_entry (const char *filename, void *symval, char *alias)
 {
     int len;
     char *tmp;
+    DEF_FIELD_ADDR(symval, of_device_id, name);
+    DEF_FIELD_ADDR(symval, of_device_id, type);
+    DEF_FIELD_ADDR(symval, of_device_id, compatible);
+
     len = sprintf (alias, "of:N%sT%s",
-                    of->name[0] ? of->name : "*",
-                    of->type[0] ? of->type : "*");
+                    (*name)[0] ? *name : "*",
+                    (*type)[0] ? *type : "*");
 
-    if (of->compatible[0])
+    if (compatible[0])
         sprintf (&alias[len], "%sC%s",
-                     of->type[0] ? "*" : "",
-                     of->compatible);
+                     (*type)[0] ? "*" : "",
+                     *compatible);
 
     /* Replace all whitespace with underscores */
     for (tmp = alias; tmp && *tmp; tmp++)
@@ -637,15 +664,17 @@ static int do_of_entry (const char *filename, struct of_device_id *of, char *ali
     add_wildcard(alias);
     return 1;
 }
-ADD_TO_DEVTABLE("of", struct of_device_id, do_of_entry);
+ADD_TO_DEVTABLE("of", of_device_id, do_of_entry);
 
-static int do_vio_entry(const char *filename, struct vio_device_id *vio,
+static int do_vio_entry(const char *filename, void *symval,
 		char *alias)
 {
 	char *tmp;
+	DEF_FIELD_ADDR(symval, vio_device_id, type);
+	DEF_FIELD_ADDR(symval, vio_device_id, compat);
 
-	sprintf(alias, "vio:T%sS%s", vio->type[0] ? vio->type : "*",
-			vio->compat[0] ? vio->compat : "*");
+	sprintf(alias, "vio:T%sS%s", (*type)[0] ? *type : "*",
+			(*compat)[0] ? *compat : "*");
 
 	/* Replace all whitespace with underscores */
 	for (tmp = alias; tmp && *tmp; tmp++)
@@ -655,7 +684,7 @@ static int do_vio_entry(const char *filename, struct vio_device_id *vio,
 	add_wildcard(alias);
 	return 1;
 }
-ADD_TO_DEVTABLE("vio", struct vio_device_id, do_vio_entry);
+ADD_TO_DEVTABLE("vio", vio_device_id, do_vio_entry);
 
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 
@@ -664,154 +693,172 @@ static void do_input(char *alias,
 {
 	unsigned int i;
 
+	for (i = min / BITS_PER_LONG; i < max / BITS_PER_LONG + 1; i++)
+		arr[i] = TO_NATIVE(arr[i]);
 	for (i = min; i < max; i++)
 		if (arr[i / BITS_PER_LONG] & (1L << (i%BITS_PER_LONG)))
 			sprintf(alias + strlen(alias), "%X,*", i);
 }
 
 /* input:b0v0p0e0-eXkXrXaXmXlXsXfXwX where X is comma-separated %02X. */
-static int do_input_entry(const char *filename, struct input_device_id *id,
+static int do_input_entry(const char *filename, void *symval,
 			  char *alias)
 {
+	DEF_FIELD(symval, input_device_id, flags);
+	DEF_FIELD(symval, input_device_id, bustype);
+	DEF_FIELD(symval, input_device_id, vendor);
+	DEF_FIELD(symval, input_device_id, product);
+	DEF_FIELD(symval, input_device_id, version);
+	DEF_FIELD_ADDR(symval, input_device_id, evbit);
+	DEF_FIELD_ADDR(symval, input_device_id, keybit);
+	DEF_FIELD_ADDR(symval, input_device_id, relbit);
+	DEF_FIELD_ADDR(symval, input_device_id, absbit);
+	DEF_FIELD_ADDR(symval, input_device_id, mscbit);
+	DEF_FIELD_ADDR(symval, input_device_id, ledbit);
+	DEF_FIELD_ADDR(symval, input_device_id, sndbit);
+	DEF_FIELD_ADDR(symval, input_device_id, ffbit);
+	DEF_FIELD_ADDR(symval, input_device_id, swbit);
+
 	sprintf(alias, "input:");
 
-	ADD(alias, "b", id->flags & INPUT_DEVICE_ID_MATCH_BUS, id->bustype);
-	ADD(alias, "v", id->flags & INPUT_DEVICE_ID_MATCH_VENDOR, id->vendor);
-	ADD(alias, "p", id->flags & INPUT_DEVICE_ID_MATCH_PRODUCT, id->product);
-	ADD(alias, "e", id->flags & INPUT_DEVICE_ID_MATCH_VERSION, id->version);
+	ADD(alias, "b", flags & INPUT_DEVICE_ID_MATCH_BUS, bustype);
+	ADD(alias, "v", flags & INPUT_DEVICE_ID_MATCH_VENDOR, vendor);
+	ADD(alias, "p", flags & INPUT_DEVICE_ID_MATCH_PRODUCT, product);
+	ADD(alias, "e", flags & INPUT_DEVICE_ID_MATCH_VERSION, version);
 
 	sprintf(alias + strlen(alias), "-e*");
-	if (id->flags & INPUT_DEVICE_ID_MATCH_EVBIT)
-		do_input(alias, id->evbit, 0, INPUT_DEVICE_ID_EV_MAX);
+	if (flags & INPUT_DEVICE_ID_MATCH_EVBIT)
+		do_input(alias, *evbit, 0, INPUT_DEVICE_ID_EV_MAX);
 	sprintf(alias + strlen(alias), "k*");
-	if (id->flags & INPUT_DEVICE_ID_MATCH_KEYBIT)
-		do_input(alias, id->keybit,
+	if (flags & INPUT_DEVICE_ID_MATCH_KEYBIT)
+		do_input(alias, *keybit,
 			 INPUT_DEVICE_ID_KEY_MIN_INTERESTING,
 			 INPUT_DEVICE_ID_KEY_MAX);
 	sprintf(alias + strlen(alias), "r*");
-	if (id->flags & INPUT_DEVICE_ID_MATCH_RELBIT)
-		do_input(alias, id->relbit, 0, INPUT_DEVICE_ID_REL_MAX);
+	if (flags & INPUT_DEVICE_ID_MATCH_RELBIT)
+		do_input(alias, *relbit, 0, INPUT_DEVICE_ID_REL_MAX);
 	sprintf(alias + strlen(alias), "a*");
-	if (id->flags & INPUT_DEVICE_ID_MATCH_ABSBIT)
-		do_input(alias, id->absbit, 0, INPUT_DEVICE_ID_ABS_MAX);
+	if (flags & INPUT_DEVICE_ID_MATCH_ABSBIT)
+		do_input(alias, *absbit, 0, INPUT_DEVICE_ID_ABS_MAX);
 	sprintf(alias + strlen(alias), "m*");
-	if (id->flags & INPUT_DEVICE_ID_MATCH_MSCIT)
-		do_input(alias, id->mscbit, 0, INPUT_DEVICE_ID_MSC_MAX);
+	if (flags & INPUT_DEVICE_ID_MATCH_MSCIT)
+		do_input(alias, *mscbit, 0, INPUT_DEVICE_ID_MSC_MAX);
 	sprintf(alias + strlen(alias), "l*");
-	if (id->flags & INPUT_DEVICE_ID_MATCH_LEDBIT)
-		do_input(alias, id->ledbit, 0, INPUT_DEVICE_ID_LED_MAX);
+	if (flags & INPUT_DEVICE_ID_MATCH_LEDBIT)
+		do_input(alias, *ledbit, 0, INPUT_DEVICE_ID_LED_MAX);
 	sprintf(alias + strlen(alias), "s*");
-	if (id->flags & INPUT_DEVICE_ID_MATCH_SNDBIT)
-		do_input(alias, id->sndbit, 0, INPUT_DEVICE_ID_SND_MAX);
+	if (flags & INPUT_DEVICE_ID_MATCH_SNDBIT)
+		do_input(alias, *sndbit, 0, INPUT_DEVICE_ID_SND_MAX);
 	sprintf(alias + strlen(alias), "f*");
-	if (id->flags & INPUT_DEVICE_ID_MATCH_FFBIT)
-		do_input(alias, id->ffbit, 0, INPUT_DEVICE_ID_FF_MAX);
+	if (flags & INPUT_DEVICE_ID_MATCH_FFBIT)
+		do_input(alias, *ffbit, 0, INPUT_DEVICE_ID_FF_MAX);
 	sprintf(alias + strlen(alias), "w*");
-	if (id->flags & INPUT_DEVICE_ID_MATCH_SWBIT)
-		do_input(alias, id->swbit, 0, INPUT_DEVICE_ID_SW_MAX);
+	if (flags & INPUT_DEVICE_ID_MATCH_SWBIT)
+		do_input(alias, *swbit, 0, INPUT_DEVICE_ID_SW_MAX);
 	return 1;
 }
-ADD_TO_DEVTABLE("input", struct input_device_id, do_input_entry);
+ADD_TO_DEVTABLE("input", input_device_id, do_input_entry);
 
-static int do_eisa_entry(const char *filename, struct eisa_device_id *eisa,
+static int do_eisa_entry(const char *filename, void *symval,
 		char *alias)
 {
-	if (eisa->sig[0])
-		sprintf(alias, EISA_DEVICE_MODALIAS_FMT "*", eisa->sig);
+	DEF_FIELD_ADDR(symval, eisa_device_id, sig);
+	if (sig[0])
+		sprintf(alias, EISA_DEVICE_MODALIAS_FMT "*", *sig);
 	else
 		strcat(alias, "*");
 	return 1;
 }
-ADD_TO_DEVTABLE("eisa", struct eisa_device_id, do_eisa_entry);
+ADD_TO_DEVTABLE("eisa", eisa_device_id, do_eisa_entry);
 
 /* Looks like: parisc:tNhvNrevNsvN */
-static int do_parisc_entry(const char *filename, struct parisc_device_id *id,
+static int do_parisc_entry(const char *filename, void *symval,
 		char *alias)
 {
-	id->hw_type = TO_NATIVE(id->hw_type);
-	id->hversion = TO_NATIVE(id->hversion);
-	id->hversion_rev = TO_NATIVE(id->hversion_rev);
-	id->sversion = TO_NATIVE(id->sversion);
+	DEF_FIELD(symval, parisc_device_id, hw_type);
+	DEF_FIELD(symval, parisc_device_id, hversion);
+	DEF_FIELD(symval, parisc_device_id, hversion_rev);
+	DEF_FIELD(symval, parisc_device_id, sversion);
 
 	strcpy(alias, "parisc:");
-	ADD(alias, "t", id->hw_type != PA_HWTYPE_ANY_ID, id->hw_type);
-	ADD(alias, "hv", id->hversion != PA_HVERSION_ANY_ID, id->hversion);
-	ADD(alias, "rev", id->hversion_rev != PA_HVERSION_REV_ANY_ID, id->hversion_rev);
-	ADD(alias, "sv", id->sversion != PA_SVERSION_ANY_ID, id->sversion);
+	ADD(alias, "t", hw_type != PA_HWTYPE_ANY_ID, hw_type);
+	ADD(alias, "hv", hversion != PA_HVERSION_ANY_ID, hversion);
+	ADD(alias, "rev", hversion_rev != PA_HVERSION_REV_ANY_ID, hversion_rev);
+	ADD(alias, "sv", sversion != PA_SVERSION_ANY_ID, sversion);
 
 	add_wildcard(alias);
 	return 1;
 }
-ADD_TO_DEVTABLE("parisc", struct parisc_device_id, do_parisc_entry);
+ADD_TO_DEVTABLE("parisc", parisc_device_id, do_parisc_entry);
 
 /* Looks like: sdio:cNvNdN. */
 static int do_sdio_entry(const char *filename,
-			struct sdio_device_id *id, char *alias)
+			void *symval, char *alias)
 {
-	id->class = TO_NATIVE(id->class);
-	id->vendor = TO_NATIVE(id->vendor);
-	id->device = TO_NATIVE(id->device);
+	DEF_FIELD(symval, sdio_device_id, class);
+	DEF_FIELD(symval, sdio_device_id, vendor);
+	DEF_FIELD(symval, sdio_device_id, device);
 
 	strcpy(alias, "sdio:");
-	ADD(alias, "c", id->class != (__u8)SDIO_ANY_ID, id->class);
-	ADD(alias, "v", id->vendor != (__u16)SDIO_ANY_ID, id->vendor);
-	ADD(alias, "d", id->device != (__u16)SDIO_ANY_ID, id->device);
+	ADD(alias, "c", class != (__u8)SDIO_ANY_ID, class);
+	ADD(alias, "v", vendor != (__u16)SDIO_ANY_ID, vendor);
+	ADD(alias, "d", device != (__u16)SDIO_ANY_ID, device);
 	add_wildcard(alias);
 	return 1;
 }
-ADD_TO_DEVTABLE("sdio", struct sdio_device_id, do_sdio_entry);
+ADD_TO_DEVTABLE("sdio", sdio_device_id, do_sdio_entry);
 
 /* Looks like: ssb:vNidNrevN. */
 static int do_ssb_entry(const char *filename,
-			struct ssb_device_id *id, char *alias)
+			void *symval, char *alias)
 {
-	id->vendor = TO_NATIVE(id->vendor);
-	id->coreid = TO_NATIVE(id->coreid);
-	id->revision = TO_NATIVE(id->revision);
+	DEF_FIELD(symval, ssb_device_id, vendor);
+	DEF_FIELD(symval, ssb_device_id, coreid);
+	DEF_FIELD(symval, ssb_device_id, revision);
 
 	strcpy(alias, "ssb:");
-	ADD(alias, "v", id->vendor != SSB_ANY_VENDOR, id->vendor);
-	ADD(alias, "id", id->coreid != SSB_ANY_ID, id->coreid);
-	ADD(alias, "rev", id->revision != SSB_ANY_REV, id->revision);
+	ADD(alias, "v", vendor != SSB_ANY_VENDOR, vendor);
+	ADD(alias, "id", coreid != SSB_ANY_ID, coreid);
+	ADD(alias, "rev", revision != SSB_ANY_REV, revision);
 	add_wildcard(alias);
 	return 1;
 }
-ADD_TO_DEVTABLE("ssb", struct ssb_device_id, do_ssb_entry);
+ADD_TO_DEVTABLE("ssb", ssb_device_id, do_ssb_entry);
 
 /* Looks like: bcma:mNidNrevNclN. */
 static int do_bcma_entry(const char *filename,
-			 struct bcma_device_id *id, char *alias)
+			 void *symval, char *alias)
 {
-	id->manuf = TO_NATIVE(id->manuf);
-	id->id = TO_NATIVE(id->id);
-	id->rev = TO_NATIVE(id->rev);
-	id->class = TO_NATIVE(id->class);
+	DEF_FIELD(symval, bcma_device_id, manuf);
+	DEF_FIELD(symval, bcma_device_id, id);
+	DEF_FIELD(symval, bcma_device_id, rev);
+	DEF_FIELD(symval, bcma_device_id, class);
 
 	strcpy(alias, "bcma:");
-	ADD(alias, "m", id->manuf != BCMA_ANY_MANUF, id->manuf);
-	ADD(alias, "id", id->id != BCMA_ANY_ID, id->id);
-	ADD(alias, "rev", id->rev != BCMA_ANY_REV, id->rev);
-	ADD(alias, "cl", id->class != BCMA_ANY_CLASS, id->class);
+	ADD(alias, "m", manuf != BCMA_ANY_MANUF, manuf);
+	ADD(alias, "id", id != BCMA_ANY_ID, id);
+	ADD(alias, "rev", rev != BCMA_ANY_REV, rev);
+	ADD(alias, "cl", class != BCMA_ANY_CLASS, class);
 	add_wildcard(alias);
 	return 1;
 }
-ADD_TO_DEVTABLE("bcma", struct bcma_device_id, do_bcma_entry);
+ADD_TO_DEVTABLE("bcma", bcma_device_id, do_bcma_entry);
 
 /* Looks like: virtio:dNvN */
-static int do_virtio_entry(const char *filename, struct virtio_device_id *id,
+static int do_virtio_entry(const char *filename, void *symval,
 			   char *alias)
 {
-	id->device = TO_NATIVE(id->device);
-	id->vendor = TO_NATIVE(id->vendor);
+	DEF_FIELD(symval, virtio_device_id, device);
+	DEF_FIELD(symval, virtio_device_id, vendor);
 
 	strcpy(alias, "virtio:");
-	ADD(alias, "d", id->device != VIRTIO_DEV_ANY_ID, id->device);
-	ADD(alias, "v", id->vendor != VIRTIO_DEV_ANY_ID, id->vendor);
+	ADD(alias, "d", device != VIRTIO_DEV_ANY_ID, device);
+	ADD(alias, "v", vendor != VIRTIO_DEV_ANY_ID, vendor);
 
 	add_wildcard(alias);
 	return 1;
 }
-ADD_TO_DEVTABLE("virtio", struct virtio_device_id, do_virtio_entry);
+ADD_TO_DEVTABLE("virtio", virtio_device_id, do_virtio_entry);
 
 /*
  * Looks like: vmbus:guid
@@ -819,41 +866,44 @@ ADD_TO_DEVTABLE("virtio", struct virtio_device_id, do_virtio_entry);
  * in the name.
  */
 
-static int do_vmbus_entry(const char *filename, struct hv_vmbus_device_id *id,
+static int do_vmbus_entry(const char *filename, void *symval,
 			  char *alias)
 {
 	int i;
-	char guid_name[((sizeof(id->guid) + 1)) * 2];
+	DEF_FIELD_ADDR(symval, hv_vmbus_device_id, guid);
+	char guid_name[(sizeof(*guid) + 1) * 2];
 
-	for (i = 0; i < (sizeof(id->guid) * 2); i += 2)
-		sprintf(&guid_name[i], "%02x", id->guid[i/2]);
+	for (i = 0; i < (sizeof(*guid) * 2); i += 2)
+		sprintf(&guid_name[i], "%02x", TO_NATIVE((*guid)[i/2]));
 
 	strcpy(alias, "vmbus:");
 	strcat(alias, guid_name);
 
 	return 1;
 }
-ADD_TO_DEVTABLE("vmbus", struct hv_vmbus_device_id, do_vmbus_entry);
+ADD_TO_DEVTABLE("vmbus", hv_vmbus_device_id, do_vmbus_entry);
 
 /* Looks like: i2c:S */
-static int do_i2c_entry(const char *filename, struct i2c_device_id *id,
+static int do_i2c_entry(const char *filename, void *symval,
 			char *alias)
 {
-	sprintf(alias, I2C_MODULE_PREFIX "%s", id->name);
+	DEF_FIELD_ADDR(symval, i2c_device_id, name);
+	sprintf(alias, I2C_MODULE_PREFIX "%s", *name);
 
 	return 1;
 }
-ADD_TO_DEVTABLE("i2c", struct i2c_device_id, do_i2c_entry);
+ADD_TO_DEVTABLE("i2c", i2c_device_id, do_i2c_entry);
 
 /* Looks like: spi:S */
-static int do_spi_entry(const char *filename, struct spi_device_id *id,
+static int do_spi_entry(const char *filename, void *symval,
 			char *alias)
 {
-	sprintf(alias, SPI_MODULE_PREFIX "%s", id->name);
+	DEF_FIELD_ADDR(symval, spi_device_id, name);
+	sprintf(alias, SPI_MODULE_PREFIX "%s", *name);
 
 	return 1;
 }
-ADD_TO_DEVTABLE("spi", struct spi_device_id, do_spi_entry);
+ADD_TO_DEVTABLE("spi", spi_device_id, do_spi_entry);
 
 static const struct dmifield {
 	const char *prefix;
@@ -885,21 +935,21 @@ static void dmi_ascii_filter(char *d, const char *s)
 }
 
 
-static int do_dmi_entry(const char *filename, struct dmi_system_id *id,
+static int do_dmi_entry(const char *filename, void *symval,
 			char *alias)
 {
 	int i, j;
-
+	DEF_FIELD_ADDR(symval, dmi_system_id, matches);
 	sprintf(alias, "dmi*");
 
 	for (i = 0; i < ARRAY_SIZE(dmi_fields); i++) {
 		for (j = 0; j < 4; j++) {
-			if (id->matches[j].slot &&
-			    id->matches[j].slot == dmi_fields[i].field) {
+			if ((*matches)[j].slot &&
+			    (*matches)[j].slot == dmi_fields[i].field) {
 				sprintf(alias + strlen(alias), ":%s*",
 					dmi_fields[i].prefix);
 				dmi_ascii_filter(alias + strlen(alias),
-						 id->matches[j].substr);
+						 (*matches)[j].substr);
 				strcat(alias, "*");
 			}
 		}
@@ -908,27 +958,30 @@ static int do_dmi_entry(const char *filename, struct dmi_system_id *id,
 	strcat(alias, ":");
 	return 1;
 }
-ADD_TO_DEVTABLE("dmi", struct dmi_system_id, do_dmi_entry);
+ADD_TO_DEVTABLE("dmi", dmi_system_id, do_dmi_entry);
 
 static int do_platform_entry(const char *filename,
-			     struct platform_device_id *id, char *alias)
+			     void *symval, char *alias)
 {
-	sprintf(alias, PLATFORM_MODULE_PREFIX "%s", id->name);
+	DEF_FIELD_ADDR(symval, platform_device_id, name);
+	sprintf(alias, PLATFORM_MODULE_PREFIX "%s", *name);
 	return 1;
 }
-ADD_TO_DEVTABLE("platform", struct platform_device_id, do_platform_entry);
+ADD_TO_DEVTABLE("platform", platform_device_id, do_platform_entry);
 
 static int do_mdio_entry(const char *filename,
-			 struct mdio_device_id *id, char *alias)
+			 void *symval, char *alias)
 {
 	int i;
+	DEF_FIELD(symval, mdio_device_id, phy_id);
+	DEF_FIELD(symval, mdio_device_id, phy_id_mask);
 
 	alias += sprintf(alias, MDIO_MODULE_PREFIX);
 
 	for (i = 0; i < 32; i++) {
-		if (!((id->phy_id_mask >> (31-i)) & 1))
+		if (!((phy_id_mask >> (31-i)) & 1))
 			*(alias++) = '?';
-		else if ((id->phy_id >> (31-i)) & 1)
+		else if ((phy_id >> (31-i)) & 1)
 			*(alias++) = '1';
 		else
 			*(alias++) = '0';
@@ -939,47 +992,50 @@ static int do_mdio_entry(const char *filename,
 
 	return 1;
 }
-ADD_TO_DEVTABLE("mdio", struct mdio_device_id, do_mdio_entry);
+ADD_TO_DEVTABLE("mdio", mdio_device_id, do_mdio_entry);
 
 /* Looks like: zorro:iN. */
-static int do_zorro_entry(const char *filename, struct zorro_device_id *id,
+static int do_zorro_entry(const char *filename, void *symval,
 			  char *alias)
 {
-	id->id = TO_NATIVE(id->id);
+	DEF_FIELD(symval, zorro_device_id, id);
 	strcpy(alias, "zorro:");
-	ADD(alias, "i", id->id != ZORRO_WILDCARD, id->id);
+	ADD(alias, "i", id != ZORRO_WILDCARD, id);
 	return 1;
 }
-ADD_TO_DEVTABLE("zorro", struct zorro_device_id, do_zorro_entry);
+ADD_TO_DEVTABLE("zorro", zorro_device_id, do_zorro_entry);
 
 /* looks like: "pnp:dD" */
 static int do_isapnp_entry(const char *filename,
-			   struct isapnp_device_id *id, char *alias)
+			   void *symval, char *alias)
 {
+	DEF_FIELD(symval, isapnp_device_id, vendor);
+	DEF_FIELD(symval, isapnp_device_id, function);
 	sprintf(alias, "pnp:d%c%c%c%x%x%x%x*",
-		'A' + ((id->vendor >> 2) & 0x3f) - 1,
-		'A' + (((id->vendor & 3) << 3) | ((id->vendor >> 13) & 7)) - 1,
-		'A' + ((id->vendor >> 8) & 0x1f) - 1,
-		(id->function >> 4) & 0x0f, id->function & 0x0f,
-		(id->function >> 12) & 0x0f, (id->function >> 8) & 0x0f);
+		'A' + ((vendor >> 2) & 0x3f) - 1,
+		'A' + (((vendor & 3) << 3) | ((vendor >> 13) & 7)) - 1,
+		'A' + ((vendor >> 8) & 0x1f) - 1,
+		(function >> 4) & 0x0f, function & 0x0f,
+		(function >> 12) & 0x0f, (function >> 8) & 0x0f);
 	return 1;
 }
-ADD_TO_DEVTABLE("isapnp", struct isapnp_device_id, do_isapnp_entry);
+ADD_TO_DEVTABLE("isapnp", isapnp_device_id, do_isapnp_entry);
 
 /* Looks like: "ipack:fNvNdN". */
 static int do_ipack_entry(const char *filename,
-			  struct ipack_device_id *id, char *alias)
+			  void *symval, char *alias)
 {
-	id->vendor = TO_NATIVE(id->vendor);
-	id->device = TO_NATIVE(id->device);
+	DEF_FIELD(symval, ipack_device_id, format);
+	DEF_FIELD(symval, ipack_device_id, vendor);
+	DEF_FIELD(symval, ipack_device_id, device);
 	strcpy(alias, "ipack:");
-	ADD(alias, "f", id->format != IPACK_ANY_FORMAT, id->format);
-	ADD(alias, "v", id->vendor != IPACK_ANY_ID, id->vendor);
-	ADD(alias, "d", id->device != IPACK_ANY_ID, id->device);
+	ADD(alias, "f", format != IPACK_ANY_FORMAT, format);
+	ADD(alias, "v", vendor != IPACK_ANY_ID, vendor);
+	ADD(alias, "d", device != IPACK_ANY_ID, device);
 	add_wildcard(alias);
 	return 1;
 }
-ADD_TO_DEVTABLE("ipack", struct ipack_device_id, do_ipack_entry);
+ADD_TO_DEVTABLE("ipack", ipack_device_id, do_ipack_entry);
 
 /*
  * Append a match expression for a single masked hex digit.
@@ -1030,25 +1086,27 @@ static void append_nibble_mask(char **outp,
  *	a ? or [] pattern matching exactly one digit.
  */
 static int do_amba_entry(const char *filename,
-			 struct amba_id *id, char *alias)
+			 void *symval, char *alias)
 {
 	unsigned int digit;
 	char *p = alias;
+	DEF_FIELD(symval, amba_id, id);
+	DEF_FIELD(symval, amba_id, mask);
 
-	if ((id->id & id->mask) != id->id)
+	if ((id & mask) != id)
 		fatal("%s: Masked-off bit(s) of AMBA device ID are non-zero: "
 		      "id=0x%08X, mask=0x%08X.  Please fix this driver.\n",
-		      filename, id->id, id->mask);
+		      filename, id, mask);
 
 	p += sprintf(alias, "amba:d");
 	for (digit = 0; digit < 8; digit++)
 		append_nibble_mask(&p,
-				   (id->id >> (4 * (7 - digit))) & 0xf,
-				   (id->mask >> (4 * (7 - digit))) & 0xf);
+				   (id >> (4 * (7 - digit))) & 0xf,
+				   (mask >> (4 * (7 - digit))) & 0xf);
 
 	return 1;
 }
-ADD_TO_DEVTABLE("amba", struct amba_id, do_amba_entry);
+ADD_TO_DEVTABLE("amba", amba_id, do_amba_entry);
 
 /* LOOKS like x86cpu:vendor:VVVV:family:FFFF:model:MMMM:feature:*,FEAT,*
  * All fields are numbers. It would be nicer to use strings for vendor
@@ -1056,24 +1114,24 @@ ADD_TO_DEVTABLE("amba", struct amba_id, do_amba_entry);
  * complicated.
  */
 
-static int do_x86cpu_entry(const char *filename, struct x86_cpu_id *id,
+static int do_x86cpu_entry(const char *filename, void *symval,
 			   char *alias)
 {
-	id->feature = TO_NATIVE(id->feature);
-	id->family = TO_NATIVE(id->family);
-	id->model = TO_NATIVE(id->model);
-	id->vendor = TO_NATIVE(id->vendor);
+	DEF_FIELD(symval, x86_cpu_id, feature);
+	DEF_FIELD(symval, x86_cpu_id, family);
+	DEF_FIELD(symval, x86_cpu_id, model);
+	DEF_FIELD(symval, x86_cpu_id, vendor);
 
 	strcpy(alias, "x86cpu:");
-	ADD(alias, "vendor:",  id->vendor != X86_VENDOR_ANY, id->vendor);
-	ADD(alias, ":family:", id->family != X86_FAMILY_ANY, id->family);
-	ADD(alias, ":model:",  id->model  != X86_MODEL_ANY,  id->model);
+	ADD(alias, "vendor:",  vendor != X86_VENDOR_ANY, vendor);
+	ADD(alias, ":family:", family != X86_FAMILY_ANY, family);
+	ADD(alias, ":model:",  model  != X86_MODEL_ANY,  model);
 	strcat(alias, ":feature:*");
-	if (id->feature != X86_FEATURE_ANY)
-		sprintf(alias + strlen(alias), "%04X*", id->feature);
+	if (feature != X86_FEATURE_ANY)
+		sprintf(alias + strlen(alias), "%04X*", feature);
 	return 1;
 }
-ADD_TO_DEVTABLE("x86cpu", struct x86_cpu_id, do_x86cpu_entry);
+ADD_TO_DEVTABLE("x86cpu", x86_cpu_id, do_x86cpu_entry);
 
 /* Does namelen bytes of name exactly match the symbol? */
 static bool sym_is(const char *name, unsigned namelen, const char *symbol)
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index ff36c50..11a8c30 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -2126,7 +2126,7 @@ int main(int argc, char **argv)
 	struct ext_sym_list *extsym_iter;
 	struct ext_sym_list *extsym_start = NULL;
 
-	while ((opt = getopt(argc, argv, "i:I:e:cmsSo:awM:K:")) != -1) {
+	while ((opt = getopt(argc, argv, "i:I:e:msSo:awM:K:")) != -1) {
 		switch (opt) {
 		case 'i':
 			kernel_read = optarg;
@@ -2135,9 +2135,6 @@ int main(int argc, char **argv)
 			module_read = optarg;
 			external_module = 1;
 			break;
-		case 'c':
-			cross_build = 1;
-			break;
 		case 'e':
 			external_module = 1;
 			extsym_iter =
-- 
1.8.1.1

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348Ab3LGE60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 23:58:26 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:44414 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab3LGE6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 23:58:24 -0500
From: Gary Rookard <garyrookard@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lisa@xenapiadmin.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Gary Rookard <garyrookard@gmail.com>
Subject: [PATCH 7/9] Staging: bcm: DDRInit: removed extra lines
Date: Fri,  6 Dec 2013 23:58:20 -0500
Message-Id: <1386392300-11847-1-git-send-email-garyrookard@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the seventh patch of a series.

Signed-off-by: Gary Alan Rookard <garyrookard@gmail.com>
---
On branch staging-next
 drivers/staging/bcm/DDRInit.c | 163 +++++++++++-------------------------------
 1 file changed, 43 insertions(+), 120 deletions(-)

diff --git a/drivers/staging/bcm/DDRInit.c b/drivers/staging/bcm/DDRInit.c
index 8bb3283..57e6023 100644
--- a/drivers/staging/bcm/DDRInit.c
+++ b/drivers/staging/bcm/DDRInit.c
@@ -6,23 +6,21 @@
 #define MIPS_CLOCK_REG 	0x0f000820
 
     /* DDR INIT-133Mhz */
-#define T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 12  /* index for 0x0F00700 */0
+#define T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 12  /* index for 0x0F007000 */
 static struct bcm_ddr_setting asT3_DDRSetting133MHz[] = {     /* # DPLL Clock Setting */
 	{0x0F000800, 0x00007212},
 	{0x0f000820, 0x07F13FFF},
 	{0x0f000810, 0x00000F95},
 	{0x0f000860, 0x00000000},
 	{0x0f000880, 0x000003DD},
-                                        /* Changed source for X-bar and MIPS clock to APLL */
-	{0x0f000840, 0x0FFF1B00},
+	{0x0f000840, 0x0FFF1B00},       /* Changed source for X-bar and MIPS clock to APLL */
 	{0x0f000870, 0x00000002},
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
 	{0x0F00a084, 0x1Cffffff},
 	{0x0F00a080, 0x1C000000},
 	{0x0F00a04C, 0x0000000C},
-                                        /* Memcontroller Default values */
-	{0x0F007000, 0x00010001},
+	{0x0F007000, 0x00010001},       /* Memcontroller Default values */
 	{0x0F007004, 0x01010100},
 	{0x0F007008, 0x01000001},
 	{0x0F00700c, 0x00000000},
@@ -56,12 +54,9 @@ static struct bcm_ddr_setting asT3_DDRSetting133MHz[] = {     /* # DPLL Clock Se
 	{0x0F00707C, 0x00000000},
 	{0x0F007080, 0x00000000},
 	{0x0F007084, 0x00000000},
-                                        /* # Enable BW improvement within memory controller */
-	{0x0F007094, 0x00000104},
-                                        /* # Enable 2 ports within X-bar */
-	{0x0F00A000, 0x00000016},
-                                        /* # Enable start bit within memory controller */
-	{0x0F007018, 0x01010000}
+        {0x0F007094, 0x00000104},       /* # Enable BW improvement within memory controller */
+	{0x0F00A000, 0x00000016},       /* # Enable 2 ports within X-bar */
+	{0x0F007018, 0x01010000}        /* # Enable start bit within memory controller */
 };
 /* 80Mhz */
 #define T3_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 10  /* index for 0x0F007000 */
@@ -76,8 +71,7 @@ static struct bcm_ddr_setting asT3_DDRSetting80MHz[] = { /*  # DPLL Clock Settin
 	{0x0F00a080, 0x1C000000},
 	{0x0F00a000, 0x00000016},
 	{0x0F00a04C, 0x0000000C},
-                                /* Memcontroller Default values */
-	{0x0F007000, 0x00010001},
+	{0x0F007000, 0x00010001},  /* Memcontroller Default values */
 	{0x0F007004, 0x01000000},
 	{0x0F007008, 0x01000001},
 	{0x0F00700c, 0x00000000},
@@ -112,8 +106,7 @@ static struct bcm_ddr_setting asT3_DDRSetting80MHz[] = { /*  # DPLL Clock Settin
 	{0x0F007080, 0x00000000},
 	{0x0F007084, 0x00000000},
 	{0x0F007094, 0x00000104},
-                                        /*# Enable start bit within memory controller */
-	{0x0F007018, 0x01010000}
+	{0x0F007018, 0x01010000}        /* # Enable start bit within memory controller */
 };
 /* 100Mhz */
 #define T3_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 13  /* index for 0x0F007000 */
@@ -123,19 +116,16 @@ static struct bcm_ddr_setting asT3_DDRSetting100MHz[] = {/*  # DPLL Clock Settin
 	{0x0f000820, 0x07F13E3F},
 	{0x0f000860, 0x00000000},
 	{0x0f000880, 0x000003DD},
-                                /* Changed source for X-bar and MIPS clock to APLL */
-                                /* 0x0f000840,0x0FFF1800, */
-	{0x0f000840, 0x0FFF1B00},
+	{0x0f000840, 0x0FFF1B00}, /* Changed source for X-bar and MIPS clock to APLL */
+	/* 0x0f000840,0x0FFF1800, */
 	{0x0f000870, 0x00000002},
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
 	{0x0F00a084, 0x1Cffffff},
 	{0x0F00a080, 0x1C000000},
 	{0x0F00a04C, 0x0000000C},
-                                /* # Enable 2 ports within X-bar */
-	{0x0F00A000, 0x00000016},
-                                /*Memcontroller Default values */
-	{0x0F007000, 0x00010001},
+	{0x0F00A000, 0x00000016},  /* # Enable 2 ports within X-bar */
+	{0x0F007000, 0x00010001},  /*Memcontroller Default values */
 	{0x0F007004, 0x01010100},
 	{0x0F007008, 0x01000001},
 	{0x0F00700c, 0x00000000},
@@ -169,12 +159,9 @@ static struct bcm_ddr_setting asT3_DDRSetting100MHz[] = {/*  # DPLL Clock Settin
 	{0x0F00707C, 0x00000000},
 	{0x0F007080, 0x00000000},
 	{0x0F007084, 0x00000000},
-                                /* # Enable BW improvement within memory controller */
-	{0x0F007094, 0x00000104},
-                                /* # Enable start bit within memory controller */
-	{0x0F007018, 0x01010000}
+	{0x0F007094, 0x00000104},  /* # Enable BW improvement within memory controller */
+	{0x0F007018, 0x01010000}  /* # Enable start bit within memory controller */
 };
-
 /* Net T3B DDR Settings */
 /* DDR INIT-133Mhz */
 static struct bcm_ddr_setting asDPLL_266MHZ[] = {
@@ -183,8 +170,7 @@ static struct bcm_ddr_setting asDPLL_266MHZ[] = {
 	{0x0f000810, 0x00000F95},
 	{0x0f000860, 0x00000000},
 	{0x0f000880, 0x000003DD},
-                                        /* Changed source for X-bar and MIPS clock to APLL */
-	{0x0f000840, 0x0FFF1B00},
+	{0x0f000840, 0x0FFF1B00},  /* Changed source for X-bar and MIPS clock to APLL */
 	{0x0f000870, 0x00000002}
 };
 
@@ -195,18 +181,14 @@ static struct bcm_ddr_setting asT3B_DDRSetting133MHz[] = {/* # DPLL Clock Settin
 	{0x0f000810, 0x00000F95},
 	{0x0f000820, 0x07F13652},
 	{0x0f000840, 0x0FFF0800},
-                                        /* Changed source for X-bar and MIPS clock to APLL */
-	{0x0f000880, 0x000003DD},
+	{0x0f000880, 0x000003DD},       /* Changed source for X-bar and MIPS clock to APLL */
 	{0x0f000860, 0x00000000},
-                                        /* Changed source for X-bar and MIPS clock to APLL */
-	{0x0F00a044, 0x1fffffff},
+	{0x0F00a044, 0x1fffffff},       /* Changed source for X-bar and MIPS clock to APLL */
 	{0x0F00a040, 0x1f000000},
 	{0x0F00a084, 0x1Cffffff},
 	{0x0F00a080, 0x1C000000},
-                                        /* # Enable 2 ports within X-bar */
-	{0x0F00A000, 0x00000016},
-                                        /* Memcontroller Default values */
-	{0x0F007000, 0x00010001},
+	{0x0F00A000, 0x00000016},       /* # Enable 2 ports within X-bar */
+	{0x0F007000, 0x00010001},       /* Memcontroller Default values */
 	{0x0F007004, 0x01010100},
 	{0x0F007008, 0x01000001},
 	{0x0F00700c, 0x00000000},
@@ -240,10 +222,8 @@ static struct bcm_ddr_setting asT3B_DDRSetting133MHz[] = {/* # DPLL Clock Settin
 	{0x0F00707C, 0x00000000},
 	{0x0F007080, 0x00000000},
 	{0x0F007084, 0x00000000},
-                                        /* # Enable BW improvement within memory controller */
-	{0x0F007094, 0x00000104},
-                                        /* # Enable start bit within memory controller */
-	{0x0F007018, 0x01010000},
+	{0x0F007094, 0x00000104},       /* # Enable BW improvement within memory controller */
+	{0x0F007018, 0x01010000},       /* # Enable start bit within memory controller */
 };
 
 #define T3B_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 9  /*index for 0x0F007000 */
@@ -253,14 +233,12 @@ static struct bcm_ddr_setting asT3B_DDRSetting80MHz[] = {/* # DPLL Clock Setting
 	{0x0f000840, 0x0FFF1F00},
 	{0x0f000880, 0x000003DD},
 	{0x0f000860, 0x00000000},
-
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
 	{0x0F00a084, 0x1Cffffff},
 	{0x0F00a080, 0x1C000000},
 	{0x0F00a000, 0x00000016},
-										/* Memcontroller Default values */
-	{0x0F007000, 0x00010001},
+	{0x0F007000, 0x00010001},                                               /* Memcontroller Default values */
 	{0x0F007004, 0x01000000},
 	{0x0F007008, 0x01000001},
 	{0x0F00700c, 0x00000000},
@@ -295,10 +273,8 @@ static struct bcm_ddr_setting asT3B_DDRSetting80MHz[] = {/* # DPLL Clock Setting
 	{0x0F007080, 0x00000000},
 	{0x0F007084, 0x00000000},
 	{0x0F007094, 0x00000104},
-										/* # Enable start bit within memory controller */
-	{0x0F007018, 0x01010000}
+	{0x0F007018, 0x01010000}                                                /* # Enable start bit within memory controller */
 };
-
 /* 100Mhz */
 #define T3B_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 9  /* index for 0x0F007000 */
 static struct bcm_ddr_setting asT3B_DDRSetting100MHz[] = {/* # DPLL Clock Setting */
@@ -311,10 +287,8 @@ static struct bcm_ddr_setting asT3B_DDRSetting100MHz[] = {/* # DPLL Clock Settin
 	{0x0F00a040, 0x1f000000},
 	{0x0F00a084, 0x1Cffffff},
 	{0x0F00a080, 0x1C000000},
-										/*# Enable 2 ports within X-bar */
-	{0x0F00A000, 0x00000016},
-								/* Memcontroller Default values */
-	{0x0F007000, 0x00010001},
+	{0x0F00A000, 0x00000016},                                               /*# Enable 2 ports within X-bar */
+	{0x0F007000, 0x00010001},                               /* Memcontroller Default values */
 	{0x0F007004, 0x01010100},
 	{0x0F007008, 0x01000001},
 	{0x0F00700c, 0x00000000},
@@ -348,28 +322,22 @@ static struct bcm_ddr_setting asT3B_DDRSetting100MHz[] = {/* # DPLL Clock Settin
 	{0x0F00707C, 0x00000000},
 	{0x0F007080, 0x00000000},
 	{0x0F007084, 0x00000000},
-								/* # Enable BW improvement within memory controller */
-	{0x0F007094, 0x00000104},
-								/* # Enable start bit within memory controller */
-	{0x0F007018, 0x01010000}
+	{0x0F007094, 0x00000104},                               /* # Enable BW improvement within memory controller */
+	{0x0F007018, 0x01010000}                                /* # Enable start bit within memory controller */
 };
-
-
 #define T3LP_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 9  /*index for 0x0F007000 */
 static struct bcm_ddr_setting asT3LP_DDRSetting133MHz[] = {/* # DPLL Clock Setting */
 	{0x0f000820, 0x03F1365B},
 	{0x0f000810, 0x00002F95},
 	{0x0f000880, 0x000003DD},
-								/* Changed source for X-bar and MIPS clock to APLL */
-	{0x0f000840, 0x0FFF0000},
+	{0x0f000840, 0x0FFF0000},                               /* Changed source for X-bar and MIPS clock to APLL */
 	{0x0f000860, 0x00000000},
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
 	{0x0F00a084, 0x1Cffffff},
 	{0x0F00a080, 0x1C000000},
 	{0x0F00A000, 0x00000016},
-								/* Memcontroller Default values */
-	{0x0F007000, 0x00010001},
+	{0x0F007000, 0x00010001},                               /* Memcontroller Default values */
 	{0x0F007004, 0x01010100},
 	{0x0F007008, 0x01000001},
 	{0x0F00700c, 0x00000000},
@@ -406,15 +374,12 @@ static struct bcm_ddr_setting asT3LP_DDRSetting133MHz[] = {/* # DPLL Clock Setti
 	{0x0F007088, 0x01000001},
 	{0x0F00708c, 0x00000101},
 	{0x0F007090, 0x00000000},
-								/*# Enable BW improvement within memory controller */
-	{0x0F007094, 0x00040000},
+	{0x0F007094, 0x00040000},                               /*# Enable BW improvement within memory controller */
 	{0x0F007098, 0x00000000},
 	{0x0F0070c8, 0x00000104},
 								/* # Enable 2 ports within X-bar */
-								/* # Enable start bit within memory controller */
-	{0x0F007018, 0x01010000}
+	{0x0F007018, 0x01010000}                                /* # Enable start bit within memory controller */
 };
-
 #define T3LP_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 11  /* index for 0x0F007000 */
 static struct bcm_ddr_setting asT3LP_DDRSetting100MHz[] = {/*	# DPLL Clock Setting */
 	{0x0f000810, 0x00002F95},
@@ -422,14 +387,12 @@ static struct bcm_ddr_setting asT3LP_DDRSetting100MHz[] = {/*	# DPLL Clock Setti
 	{0x0f000840, 0x0fff0000},
 	{0x0f000860, 0x00000000},
 	{0x0f000880, 0x000003DD},
-								/* Changed source for X-bar and MIPS clock to APLL */
-	{0x0f000840, 0x0FFF0000},
+	{0x0f000840, 0x0FFF0000},                               /* Changed source for X-bar and MIPS clock to APLL */
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
 	{0x0F00a084, 0x1Cffffff},
 	{0x0F00a080, 0x1C000000},
-								/* Memcontroller Default values */
-	{0x0F007000, 0x00010001},
+	{0x0F007000, 0x00010001},                               /* Memcontroller Default values */
 	{0x0F007004, 0x01010100},
 	{0x0F007008, 0x01000001},
 	{0x0F00700c, 0x00000000},
@@ -469,12 +432,9 @@ static struct bcm_ddr_setting asT3LP_DDRSetting100MHz[] = {/*	# DPLL Clock Setti
 	{0x0F007094, 0x00010000},
 	{0x0F007098, 0x00000000},
 	{0x0F0070C8, 0x00000104},
-								/* # Enable 2 ports within X-bar */
-	{0x0F00A000, 0x00000016},
-								/* # Enable start bit within memory controller */
-	{0x0F007018, 0x01010000}
+	{0x0F00A000, 0x00000016},                               /* # Enable 2 ports within X-bar */
+	{0x0F007018, 0x01010000}                                /* # Enable start bit within memory controller */
 };
-
 #define T3LP_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 9  /* index for 0x0F007000 */
 static struct bcm_ddr_setting asT3LP_DDRSetting80MHz[] = {/* # DPLL Clock Setting */
 	{0x0f000820, 0x07F13FFF},
@@ -529,15 +489,9 @@ static struct bcm_ddr_setting asT3LP_DDRSetting80MHz[] = {/* # DPLL Clock Settin
 	{0x0F0070C8, 0x00000104},
 	{0x0F007018, 0x01010000}
 };
-
-
-
-
 /* T3 LP-B (UMA-B) */
-
 #define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_160MHZ 7  /* index for 0x0F007000 */
 static struct bcm_ddr_setting asT3LPB_DDRSetting160MHz[] = {/* # DPLL Clock Setting */
-
 	{0x0f000820, 0x03F137DB},
 	{0x0f000810, 0x01842795},
 	{0x0f000860, 0x00000000},
@@ -591,15 +545,12 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting160MHz[] = {/* # DPLL Clock Sett
 	{0x0F0070C8, 0x00000104},
 	{0x0F007018, 0x01010000}
 };
-
-
 #define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 7  /* index for 0x0F007000 */
 static struct bcm_ddr_setting asT3LPB_DDRSetting133MHz[] = {/*	# DPLL Clock Setting */
 	{0x0f000820, 0x03F1365B},
 	{0x0f000810, 0x00002F95},
 	{0x0f000880, 0x000003DD},
-								/* Changed source for X-bar and MIPS clock to APLL */
-	{0x0f000840, 0x0FFF0000},
+	{0x0f000840, 0x0FFF0000},                               /* Changed source for X-bar and MIPS clock to APLL */
 	{0x0f000860, 0x00000000},
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
@@ -607,8 +558,7 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting133MHz[] = {/*	# DPLL Clock Sett
 	{0x0F00a084, 0x1Cffffff},/* dump from here in internal memory */
 	{0x0F00a080, 0x1C000000},
 	{0x0F00A000, 0x00000016},
-								/* Memcontroller Default values */
-	{0x0F007000, 0x00010001},
+	{0x0F007000, 0x00010001},                               /* Memcontroller Default values */
 	{0x0F007004, 0x01010100},
 	{0x0F007008, 0x01000001},
 	{0x0F00700c, 0x00000000},
@@ -645,15 +595,12 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting133MHz[] = {/*	# DPLL Clock Sett
 	{0x0F007088, 0x01000001},
 	{0x0F00708c, 0x00000101},
 	{0x0F007090, 0x00000000},
-								/* # Enable BW improvement within memory controller */
-	{0x0F007094, 0x00040000},
+	{0x0F007094, 0x00040000},                               /* # Enable BW improvement within memory controller */
 	{0x0F007098, 0x00000000},
 	{0x0F0070c8, 0x00000104},
 								/* # Enable 2 ports within X-bar */
-								/* # Enable start bit within memory controller */
-	{0x0F007018, 0x01010000}
+	{0x0F007018, 0x01010000}                                /* # Enable start bit within memory controller */
 };
-
 #define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 8  /*index for 0x0F007000 */
 static struct bcm_ddr_setting asT3LPB_DDRSetting100MHz[] = {/*	# DPLL Clock Setting */
 	{0x0f000810, 0x00002F95},
@@ -661,15 +608,13 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting100MHz[] = {/*	# DPLL Clock Sett
 	{0x0f000840, 0x0fff0000},
 	{0x0f000860, 0x00000000},
 	{0x0f000880, 0x000003DD},
-								/* Changed source for X-bar and MIPS clock to APLL */
-	{0x0f000840, 0x0FFF0000},
+	{0x0f000840, 0x0FFF0000},                               /* Changed source for X-bar and MIPS clock to APLL */
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
 	{0x0f003050, 0x00000021},/* flash/eeprom clock divisor which set the flash clock to 20 MHz */
 	{0x0F00a084, 0x1Cffffff}, /* dump from here in internal memory */
 	{0x0F00a080, 0x1C000000},
-								/* Memcontroller Default values */
-	{0x0F007000, 0x00010001},
+	{0x0F007000, 0x00010001},                               /* Memcontroller Default values */
 	{0x0F007004, 0x01010100},
 	{0x0F007008, 0x01000001},
 	{0x0F00700c, 0x00000000},
@@ -709,12 +654,9 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting100MHz[] = {/*	# DPLL Clock Sett
 	{0x0F007094, 0x00010000},
 	{0x0F007098, 0x00000000},
 	{0x0F0070C8, 0x00000104},
-								/* # Enable 2 ports within X-bar */
-	{0x0F00A000, 0x00000016},
-								/* # Enable start bit within memory controller */
-	{0x0F007018, 0x01010000}
+	{0x0F00A000, 0x00000016},				/* # Enable 2 ports within X-bar */
+	{0x0F007018, 0x01010000}                                /* # Enable start bit within memory controller */
 };
-
 #define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 7  /*index for 0x0F007000 */
 static struct bcm_ddr_setting asT3LPB_DDRSetting80MHz[] = {/* # DPLL Clock Setting */
 	{0x0f000820, 0x07F13FFF},
@@ -771,7 +713,6 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting80MHz[] = {/* # DPLL Clock Setti
 	{0x0F007018, 0x01010000}
 };
 
-
 int ddr_init(struct bcm_mini_adapter *Adapter)
 {
 	struct bcm_ddr_setting *psDDRSetting = NULL;
@@ -806,7 +747,6 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		    default:
 			    return -EINVAL;
         }
-
 		break;
 	case T3LPB:
 	case BCS220_2:
@@ -832,9 +772,6 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 				}
 		}
 		switch (Adapter->DDRSetting) {
-
-
-
 			case DDR_80_MHZ:
 				psDDRSetting = asT3LPB_DDRSetting80MHz;
 		        RegCount = (sizeof(asT3B_DDRSetting80MHz)/
@@ -849,24 +786,20 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 				psDDRSetting = asT3LPB_DDRSetting133MHz;
 				RegCount = (sizeof(asT3B_DDRSetting133MHz)/
 						 sizeof(struct bcm_ddr_setting));
-
 				if (Adapter->bMipsConfig == MIPS_200_MHZ) 
 					uiClockSetting = 0x03F13652;
 				else
 					uiClockSetting = 0x03F1365B;
 			break;
-
 			case DDR_160_MHZ:
 				psDDRSetting = asT3LPB_DDRSetting160MHz;
 				RegCount = sizeof(asT3LPB_DDRSetting160MHz)/sizeof(struct bcm_ddr_setting);
-
 				if (Adapter->bMipsConfig == MIPS_200_MHZ)
 					uiClockSetting = 0x03F137D2;
 				else
 					uiClockSetting = 0x03F137DB;
 			}
 			break;
-
 	case 0xbece0110:
 	case 0xbece0120:
 	case 0xbece0121:
@@ -906,7 +839,6 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		                 sizeof(struct bcm_ddr_setting));
 			break;
             case DDR_133_MHZ:
-
 				if (Adapter->bDPLLConfig == PLL_266_MHZ) { /*266Mhz PLL selected. */
 					memcpy(asT3B_DDRSetting133MHz, asDPLL_266MHZ,
 									 sizeof(asDPLL_266MHZ));
@@ -927,7 +859,6 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 			    return -EINVAL;
 		}
 		break;
-
 	}
 	default:
 		return -EINVAL;
@@ -949,7 +880,6 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		RegCount--;
 		psDDRSetting++;
 	}
-
 	if (Adapter->chip_id >= 0xbece3300) {
 		mdelay(3);
 		if ((Adapter->chip_id != BCS220_2) &&
@@ -982,7 +912,6 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 			}
 		}
 		mdelay(3);
-
 		/* DC/DC standby change...
 		 * This is to be done only for Hybrid PMU mode.
 		 * with the current h/w there is no way to detect this.
@@ -1023,7 +952,6 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 				return retval;
 			}
 		} else if (Adapter->PmuMode == HYBRID_MODE_6) {
-
 			retval = rdmalt(Adapter, (UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
 			if (retval < 0) {
 				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
@@ -1098,7 +1026,6 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 			    return -EINVAL;
         }
 		break;
-
 	case T3LPB:
 	case BCS220_2:
 	case BCS220_2BC:
@@ -1124,7 +1051,6 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 				RegCount -= T3LPB_SKIP_CLOCK_PROGRAM_DUMP_133MHZ ;
 		        psDDRSetting += T3LPB_SKIP_CLOCK_PROGRAM_DUMP_133MHZ;
 				break;
-
 			case DDR_160_MHZ:
 					bOverrideSelfRefresh = TRUE;
 					psDDRSetting = asT3LPB_DDRSetting160MHz;
@@ -1194,7 +1120,6 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 	retval = wrmalt(Adapter, ul_ddr_setting_load_addr, &value, sizeof(value));
 	if (retval) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
-
 		return retval;
 	}
 	ul_ddr_setting_load_addr += sizeof(ULONG);
@@ -1208,7 +1133,6 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 
 	ul_ddr_setting_load_addr += sizeof(ULONG);
 	RegCount *= (sizeof(struct bcm_ddr_setting)/sizeof(ULONG));
-
 	while (RegCount && !retval) {
 		value = psDDRSetting->ulRegAddress ;
 		retval = wrmalt(Adapter, ul_ddr_setting_load_addr, &value, sizeof(value));
@@ -1223,7 +1147,6 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 				}
 			} else {
 				value =  psDDRSetting->ulRegValue;
-
 				if (STATUS_SUCCESS != wrmalt(Adapter, ul_ddr_setting_load_addr ,
 							&value, sizeof(value))) {
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
-- 
1.8.4


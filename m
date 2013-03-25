Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab3CYLny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 07:43:54 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:63111 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756461Ab3CYLnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 07:43:53 -0400
Message-ID: <1364211831.1390.285.camel@x61.thuisdomein>
Subject: [PATCH] Blackfin: bf537: rename "CONFIG_ADT7310" and friends
From: Paul Bolle <pebolle@tiscali.nl>
To: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Date: Mon, 25 Mar 2013 12:43:51 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2013 11:43:51.0652 (UTC) FILETIME=[057BF240:01CE294E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol ADT7310 got removed in commit
2b0c856ad9571013db8fc369194b7108dff3c18e ("staging:iio: Consolidate
adt7310 and adt7410 driver"). That commit did not touch the references
to CONFIG_ADT7310 and CONFIG_ADT7310_MODULE in the BF537-STAMP code.
Convert these now, to their ADT7410 equivalents.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested. This took a bit of guesswork. I guessed that multiple AD
drivers can be enabled at the same time in this code. And I also guessed
that the "adt7310" modalias is still correct.

1) If this passes testing it could go in stable (3.8.y).

 arch/blackfin/mach-bf537/boards/stamp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 95114ed..23bb55d 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -700,7 +700,7 @@ static struct bfin5xx_spi_chip ad7816_spi_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_ADT7310) || defined(CONFIG_ADT7310_MODULE)
+#if defined(CONFIG_ADT7410) || defined(CONFIG_ADT7410_MODULE)
 static unsigned long adt7310_platform_data[3] = {
 /* INT bound temperature alarm event. line 1 */
 	IRQ_PG4, IRQF_TRIGGER_LOW,
@@ -1062,7 +1062,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_ADT7310) || defined(CONFIG_ADT7310_MODULE)
+#if defined(CONFIG_ADT7410) || defined(CONFIG_ADT7410_MODULE)
 	{
 		.modalias = "adt7310",
 		.max_speed_hz = 1000000,
-- 
1.7.11.7


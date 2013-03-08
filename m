Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695Ab3CHMGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 07:06:20 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:50317 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756681Ab3CHMGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 07:06:19 -0500
Message-ID: <1362744373.5994.57.camel@x61.thuisdomein>
Subject: [PATCH] blackfin: bf537: fix typo "CONFIG_SND_SOC_ADV80X_MODULE"
From: Paul Bolle <pebolle@tiscali.nl>
To: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Date: Fri, 08 Mar 2013 13:06:13 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2013 12:06:14.0391 (UTC) FILETIME=[54CBE870:01CE1BF5]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a (rather subtle) typo in "CONFIG_SND_SOC_ADV80X_MODULE". Fix it
once and for all by using IS_ENABLED(), which is designed to avoid
issues like this.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested! And this needs build- and runtime testing, especially for
the MODULE case!

1) There are many lines that might be converted to IS_ENABLED() in this
file. I'm not sure if and how that should be done.

 arch/blackfin/mach-bf537/boards/stamp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 95114ed..1872d15 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -985,7 +985,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SND_SOC_ADAV80X) || defined(CONFIG_SND_SOC_ADV80X_MODULE)
+#if IS_ENABLED(CONFIG_SND_SOC_ADAV80X)
 	{
 		.modalias = "adav801",
 		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
-- 
1.7.11.7


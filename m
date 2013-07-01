Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab3GAIku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:40:50 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45508 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab3GAIkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:40:23 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: devicetree-discuss@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [RFC PATCH 13/13] sound: codec: wm8371: correct capture line/mic
Date: Mon,  1 Jul 2013 10:39:38 +0200
Message-Id: <1372667978-4718-14-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
References: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the "switch" text, we can't enable the line and mic capture in
alsamixer.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 sound/soc/codecs/wm8731.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm8731.c b/sound/soc/codecs/wm8731.c
index 3cf6b20..dae1403 100644
--- a/sound/soc/codecs/wm8731.c
+++ b/sound/soc/codecs/wm8731.c
@@ -164,10 +164,10 @@ SOC_DOUBLE_R("Master Playback ZC Switch", WM8731_LOUT1V, WM8731_ROUT1V,
 
 SOC_DOUBLE_R_TLV("Capture Volume", WM8731_LINVOL, WM8731_RINVOL, 0, 31, 0,
 		 in_tlv),
-SOC_DOUBLE_R("Line Capture Switch", WM8731_LINVOL, WM8731_RINVOL, 7, 1, 1),
+SOC_DOUBLE_R("Line Capture", WM8731_LINVOL, WM8731_RINVOL, 7, 1, 1),
 
 SOC_SINGLE_TLV("Mic Boost Volume", WM8731_APANA, 0, 1, 0, mic_tlv),
-SOC_SINGLE("Mic Capture Switch", WM8731_APANA, 1, 1, 1),
+SOC_SINGLE("Mic Capture", WM8731_APANA, 1, 1, 1),
 
 SOC_SINGLE_TLV("Sidetone Playback Volume", WM8731_APANA, 6, 3, 1,
 	       sidetone_tlv),
-- 
1.7.10.4


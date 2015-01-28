Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259AbbA2BqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:46:10 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:49029 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbbA2BqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:46:07 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        navin patidar <navin.patidar@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Elena Oat <oat.elena@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8188eu: core: rtw_efuse: Removed variables that is never used
Date: Wed, 28 Jan 2015 23:49:01 +0100
Message-Id: <1422485341-11472-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index 8816d11..5a21e4a 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -224,7 +224,7 @@ static void efuse_read_phymap_from_txpktbuf(
 	)
 {
 	u16 dbg_addr = 0;
-	u32 start  = 0, passing_time = 0;
+	u32 start  = 0;
 	u8 reg_0x143 = 0;
 	u32 lo32 = 0, hi32 = 0;
 	u16 len = 0, count = 0;
@@ -248,7 +248,7 @@ static void efuse_read_phymap_from_txpktbuf(
 		usb_write8(adapter, REG_TXPKTBUF_DBG, 0);
 		start = jiffies;
 		while (!(reg_0x143 = usb_read8(adapter, REG_TXPKTBUF_DBG)) &&
-		       (passing_time = rtw_get_passing_time_ms(start)) < 1000) {
+		       rtw_get_passing_time_ms(start) < 1000) {
 			DBG_88E("%s polling reg_0x143:0x%02x, reg_0x106:0x%02x\n", __func__, reg_0x143, usb_read8(adapter, 0x106));
 			usleep_range(1000, 2000);
 		}
-- 
1.7.10.4


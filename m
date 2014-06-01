Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbaFAM23 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:28:29 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56556 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbaFAM20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:28:26 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: usb: dvb-usb-v2: mxl111sf.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 14:29:19 +0200
Message-Id: <1401625759-14610-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/media/usb/dvb-usb-v2/mxl111sf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index c7304fa..b8a707e 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -129,7 +129,7 @@ int mxl111sf_write_reg_mask(struct mxl111sf_state *state,
 				   u8 addr, u8 mask, u8 data)
 {
 	int ret;
-	u8 val;
+	u8 val = 0;
 
 	if (mask != 0xff) {
 		ret = mxl111sf_read_reg(state, addr, &val);
-- 
1.7.10.4


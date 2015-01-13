Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbbAMSQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:16:16 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:48961 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbbAMSQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:16:15 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <robdclark@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: tridentfb: Remove unused function
Date: Tue, 13 Jan 2015 19:19:20 +0100
Message-Id: <1421173160-3644-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function shadowmode_off() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/tridentfb.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/video/fbdev/tridentfb.c b/drivers/video/fbdev/tridentfb.c
index 7ed9a22..b5cbd2c 100644
--- a/drivers/video/fbdev/tridentfb.c
+++ b/drivers/video/fbdev/tridentfb.c
@@ -999,11 +999,6 @@ static inline void shadowmode_on(struct tridentfb_par *par)
 	write3CE(par, CyberControl, read3CE(par, CyberControl) | 0x81);
 }
 
-static inline void shadowmode_off(struct tridentfb_par *par)
-{
-	write3CE(par, CyberControl, read3CE(par, CyberControl) & 0x7E);
-}
-
 /* Set the hardware to the requested video mode */
 static int tridentfb_set_par(struct fb_info *info)
 {
-- 
1.7.10.4


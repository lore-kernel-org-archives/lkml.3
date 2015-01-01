Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbbAAPJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 10:09:48 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55912 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbbAAPJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 10:09:46 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sound: drivers: portman2x4.c:  Remove some unused functions
Date: Thu,  1 Jan 2015 16:12:45 +0100
Message-Id: <1420125165-26527-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
portman_read_data() portman_read_command()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 sound/drivers/portman2x4.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/sound/drivers/portman2x4.c b/sound/drivers/portman2x4.c
index 78ccfa4..b5b6b4e 100644
--- a/sound/drivers/portman2x4.c
+++ b/sound/drivers/portman2x4.c
@@ -198,21 +198,11 @@ static inline void portman_write_command(struct portman *pm, u8 value)
 	parport_write_control(pm->pardev->port, value);
 }
 
-static inline u8 portman_read_command(struct portman *pm)
-{
-	return parport_read_control(pm->pardev->port);
-}
-
 static inline u8 portman_read_status(struct portman *pm)
 {
 	return parport_read_status(pm->pardev->port);
 }
 
-static inline u8 portman_read_data(struct portman *pm)
-{
-	return parport_read_data(pm->pardev->port);
-}
-
 static inline void portman_write_data(struct portman *pm, u8 value)
 {
 	parport_write_data(pm->pardev->port, value);
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbbAKQub (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 11:50:31 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:60696 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbbAKQua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 11:50:30 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Airlie <airlied@linux.ie>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm: gma500: psb_irq: Remove unused function
Date: Sun, 11 Jan 2015 17:53:35 +0100
Message-Id: <1420995215-21383-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function mid_pipe_vsync() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/gma500/psb_irq.c |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/gpu/drm/gma500/psb_irq.c b/drivers/gpu/drm/gma500/psb_irq.c
index 624eb36..dcfd0a7 100644
--- a/drivers/gpu/drm/gma500/psb_irq.c
+++ b/drivers/gpu/drm/gma500/psb_irq.c
@@ -59,18 +59,6 @@ mid_pipe_event(int pipe)
 }
 
 static inline u32
-mid_pipe_vsync(int pipe)
-{
-	if (pipe == 0)
-		return _PSB_VSYNC_PIPEA_FLAG;
-	if (pipe == 1)
-		return _PSB_VSYNC_PIPEB_FLAG;
-	if (pipe == 2)
-		return _MDFLD_PIPEC_VBLANK_FLAG;
-	BUG();
-}
-
-static inline u32
 mid_pipeconf(int pipe)
 {
 	if (pipe == 0)
-- 
1.7.10.4


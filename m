Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaDRJn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:43:58 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45895 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751795AbaDRJWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 14/72] drm/i915: Undo the PIPEA quirk for i845
Date: Fri, 18 Apr 2014 11:21:47 +0200
Message-Id: <14fa4b5461098c6f7731575653023701f945e3bc.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a4945f9522d27e1e6d64a02ad055e83768cb0896 upstream.

The PIPEA quirk is specifically for the issue with the PIPEB PLL on
830gm being slaved to the PIPEA PLL, and so to use PIPEB requires PIPEA
running. i845 doesn't even have the second PLL or pipe, and enabling
the quirk results in a blank DVO LVDS.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/i915/intel_display.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 9dcf34f9a22d..5aa836e6e190 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -10073,8 +10073,7 @@ static struct intel_quirk intel_quirks[] = {
 	/* ThinkPad T60 needs pipe A force quirk (bug #16494) */
 	{ 0x2782, 0x17aa, 0x201a, quirk_pipea_force },
 
-	/* 830/845 need to leave pipe A & dpll A up */
-	{ 0x2562, PCI_ANY_ID, PCI_ANY_ID, quirk_pipea_force },
+	/* 830 needs to leave pipe A & dpll A up */
 	{ 0x3577, PCI_ANY_ID, PCI_ANY_ID, quirk_pipea_force },
 
 	/* Lenovo U160 cannot use SSC on LVDS */
-- 
1.9.2


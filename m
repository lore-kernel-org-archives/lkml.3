Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933435AbaFIIzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:55:18 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58595 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932245AbaFIIv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.12 122/146] drm/i915: quirk invert brightness for Acer Aspire 5336
Date: Mon,  9 Jun 2014 10:50:57 +0200
Message-Id: <331bab456e6690e4ec6ca7d498e9c454fb8340dd.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

This is commit 0f540c3a7cfb91c9d7a19eb0c95c24 upstream.

Since
commit ee1452d7458451a7508e0663553ce88d63958157
Author: Jani Nikula <jani.nikula@intel.com>
Date:   Fri Sep 20 15:05:30 2013 +0300

    drm/i915: assume all GM45 Acer laptops use inverted backlight PWM

failed and was later reverted in
commit be505f643925e257087247b996cd8ece787c12af
Author: Alexander van Heukelum <heukelum@fastmail.fm>
Date:   Sat Dec 28 21:00:39 2013 +0100

    Revert "drm/i915: assume all GM45 Acer laptops use inverted backlight PWM"

fix the individual broken machine instead.

Note to backporters:

http://patchwork.freedesktop.org/patch/17837/

is the patch you want for 3.13 and older.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=54171
Reference: http://mid.gmane.org/DUB115-W7628C7C710EA51AA110CD4A5000@phx.gbl
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
[danvet: Patch mangling for 3.14 plus adding the link to the original
for 3.13.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/intel_display.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index c74bf330d290..837cc6cd7472 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -10108,6 +10108,9 @@ static struct intel_quirk intel_quirks[] = {
 	/* Acer Aspire 4736Z */
 	{ 0x2a42, 0x1025, 0x0260, quirk_invert_brightness },
 
+	/* Acer Aspire 5336 */
+	{ 0x2a42, 0x1025, 0x048a, quirk_invert_brightness },
+
 	/* Dell XPS13 HD Sandy Bridge */
 	{ 0x0116, 0x1028, 0x052e, quirk_no_pcm_pwm_enable },
 	/* Dell XPS13 HD and XPS13 FHD Ivy Bridge */
-- 
1.9.3


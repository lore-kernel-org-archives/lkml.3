Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbaEBQZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:25:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43679 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbaEBPjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:39:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 005/151] drm/i915: quirk invert brightness for Acer Aspire 5336
Date: Fri,  2 May 2014 08:36:33 -0700
Message-Id: <1399045139-4531-6-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 0f540c3a7cfb91c9d7a19eb0c95c24c5de1197d5 upstream.

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
[ kamal: applied Jani's 3.13 backport ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 3c5ff7a..334cf3f 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -10570,6 +10570,9 @@ static struct intel_quirk intel_quirks[] = {
 	/* Acer Aspire 4736Z */
 	{ 0x2a42, 0x1025, 0x0260, quirk_invert_brightness },
 
+	/* Acer Aspire 5336 */
+	{ 0x2a42, 0x1025, 0x048a, quirk_invert_brightness },
+
 	/* Dell XPS13 HD Sandy Bridge */
 	{ 0x0116, 0x1028, 0x052e, quirk_no_pcm_pwm_enable },
 	/* Dell XPS13 HD and XPS13 FHD Ivy Bridge */
-- 
1.9.1


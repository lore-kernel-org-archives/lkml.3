Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaDXIwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:52:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46214 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbaDXIvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:51:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 001/182] drm/i915: quirk invert brightness for Acer Aspire 5336
Date: Thu, 24 Apr 2014 09:48:46 +0100
Message-Id: <1398329507-5911-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.11: used backport suggested in commit message ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 5df9798..a61290e 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9544,6 +9544,9 @@ static struct intel_quirk intel_quirks[] = {
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


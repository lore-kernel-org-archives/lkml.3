Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbaKKLSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:18:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57839 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbaKKLLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Jens=20Stein=20J=C3=B8rgensen?= <jens.s.stein@gmail.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 148/170] drm/i915: Ignore VBT backlight check on Macbook 2, 1
Date: Tue, 11 Nov 2014 11:08:27 +0000
Message-Id: <1415704129-12709-149-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: jens stein <jens.s.stein@gmail.com>

commit b2a9601c587dbc5536546aa54009d1130adedd72 upstream.

commit c675949ec58ca50d5a3ae3c757892f1560f6e896
Author: Jani Nikula <jani.nikula@intel.com>
Date:   Wed Apr 9 11:31:37 2014 +0300

    drm/i915: do not setup backlight if not available according to VBT

prevents backlight setup on Macbook 2,1. Apply quirk to ignore the VBT
check so backlight is set up properly.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=81438
Signed-off-by: Jens Stein Jørgensen <jens.s.stein@gmail.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index ffaf8be939f1..373d652d01fa 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -11693,6 +11693,9 @@ static struct intel_quirk intel_quirks[] = {
 	/* Acer C720 Chromebook (Core i3 4005U) */
 	{ 0x0a16, 0x1025, 0x0a11, quirk_backlight_present },
 
+	/* Apple Macbook 2,1 (Core 2 T7400) */
+	{ 0x27a2, 0x8086, 0x7270, quirk_backlight_present },
+
 	/* Toshiba CB35 Chromebook (Celeron 2955U) */
 	{ 0x0a06, 0x1179, 0x0a88, quirk_backlight_present },
 
-- 
2.1.0


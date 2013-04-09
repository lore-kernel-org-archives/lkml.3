Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937003Ab3DIMio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 08:38:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935852Ab3DIMik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 08:38:40 -0400
Date: Tue, 9 Apr 2013 08:38:34 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: gregkh@linuxfoundation.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3.8.y] drm/i915: add quirk to invert brightness on eMachines
 e725
Message-ID: <20130409123833.GC32476@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upstream commit 01e3a8feb40e54b962a20fa7eb595c5efef5e109

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=31522#c35
[Note: There are more than one broken setups in the bug. This fixes one.]
Reported-by: Martins <andrissr@inbox.lv>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/intel_display.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index e6e4df7..6292677 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8899,6 +8899,12 @@ static struct intel_quirk intel_quirks[] = {
 	/* Acer Aspire 5734Z must invert backlight brightness */
 	{ 0x2a42, 0x1025, 0x0459, quirk_invert_brightness },
 
+	/* Acer/eMachines G725 */
+	{ 0x2a42, 0x1025, 0x0210, quirk_invert_brightness },
+
+	/* Acer/eMachines e725 */
+	{ 0x2a42, 0x1025, 0x0212, quirk_invert_brightness },
+
 	/* Acer Aspire 4736Z */
 	{ 0x2a42, 0x1025, 0x0260, quirk_invert_brightness },
 };
-- 
1.8.1.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbaJCVnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:43:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057AbaJCVcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Scot Doyle <lkml14@scotdoyle.com>,
        Tyler Cleveland <siralucardt@openmailbox.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.16 073/357] drm/i915: Ignore VBT backlight presence check on Acer C720 (4005U)
Date: Fri,  3 Oct 2014 14:27:39 -0700
Message-Id: <20141003212935.678158689@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scot Doyle <lkml14@scotdoyle.com>

commit dfb3d47b2369ad752ab9f7438bbf9949524b46ae upstream.

commit c675949ec58ca50d5a3ae3c757892f1560f6e896
Author: Jani Nikula <jani.nikula@intel.com>
Date:   Wed Apr 9 11:31:37 2014 +0300

    drm/i915: do not setup backlight if not available according to VBT

prevents backlight setup on the Acer C720 (Core i3 4005U CPU), which has a
misconfigured VBT. Apply quirk to ignore the VBT backlight presence check
during backlight setup.

Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
Tested-by: Tyler Cleveland <siralucardt@openmailbox.org>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -11690,6 +11690,9 @@ static struct intel_quirk intel_quirks[]
 	/* Acer C720 and C720P Chromebooks (Celeron 2955U) have backlights */
 	{ 0x0a06, 0x1025, 0x0a11, quirk_backlight_present },
 
+	/* Acer C720 Chromebook (Core i3 4005U) */
+	{ 0x0a16, 0x1025, 0x0a11, quirk_backlight_present },
+
 	/* Toshiba CB35 Chromebook (Celeron 2955U) */
 	{ 0x0a06, 0x1179, 0x0a88, quirk_backlight_present },
 



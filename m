Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760470AbaGOXeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:34:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934037AbaGOXOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Scot Doyle <lkml14@scotdoyle.com>, Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.15 62/84] drm/i915: Toshiba CB35 has a controllable backlight
Date: Tue, 15 Jul 2014 16:17:59 -0700
Message-Id: <20140715231715.053356179@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scot Doyle <lkml14@scotdoyle.com>

commit d4967d8c6d4f52623f2be8eaff0b445dc5863c92 upstream.

The Toshiba CB35 Chromebook (with Celeron 2955U CPU) has a controllable
backlight although its VBT reports otherwise. Apply quirk to ignore the
backlight presence check during backlight setup.

Patch tested by author on Toshiba CB35.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=79813
Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
CC: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
[danvet: Add cc: stable because the regressing commit is in 3.15.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -11248,6 +11248,9 @@ static struct intel_quirk intel_quirks[]
 
 	/* Acer C720 and C720P Chromebooks (Celeron 2955U) have backlights */
 	{ 0x0a06, 0x1025, 0x0a11, quirk_backlight_present },
+
+	/* Toshiba CB35 Chromebook (Celeron 2955U) */
+	{ 0x0a06, 0x1179, 0x0a88, quirk_backlight_present },
 };
 
 static void intel_init_quirks(struct drm_device *dev)



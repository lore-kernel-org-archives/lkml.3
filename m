Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaHESOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:14:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52206 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbaHESOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Scot Doyle <lkml14@scotdoyle.com>, Stefan Nagy <public@stefan-nagy.at>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.15 37/42] drm/i915: Ignore VBT backlight presence check on HP Chromebook 14
Date: Tue,  5 Aug 2014 11:13:51 -0700
Message-Id: <20140805181322.123197343@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181321.018370988@linuxfoundation.org>
References: <20140805181321.018370988@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scot Doyle <lkml14@scotdoyle.com>

commit 724cb06fa9b1e1ffd98188275543fdb3b8eaca4f upstream.

commit c675949ec58ca50d5a3ae3c757892f1560f6e896
    drm/i915: do not setup backlight if not available according to VBT

caused a regression on the HP Chromebook 14 (with Celeron 2955U CPU),
which has a misconfigured VBT. Apply quirk to ignore the VBT backlight
presence check during backlight setup.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=79813
Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
Tested-by: Stefan Nagy <public@stefan-nagy.at>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -11251,6 +11251,9 @@ static struct intel_quirk intel_quirks[]
 
 	/* Toshiba CB35 Chromebook (Celeron 2955U) */
 	{ 0x0a06, 0x1179, 0x0a88, quirk_backlight_present },
+
+	/* HP Chromebook 14 (Celeron 2955U) */
+	{ 0x0a06, 0x103c, 0x21ed, quirk_backlight_present },
 };
 
 static void intel_init_quirks(struct drm_device *dev)



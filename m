Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab3JCEP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:15:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab3JCEPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:15:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Egbert Eich <eich@suse.com>, Jan Niggemann <jn@hz6.de>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 52/52] drm/i915: fix gen4 digital port hotplug definitions
Date: Wed,  2 Oct 2013 21:06:10 -0700
Message-Id: <20131003040525.787427878@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040522.190209641@linuxfoundation.org>
References: <20131003040522.190209641@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 0ce99f749b3834edeb500e17d6ad17e86b60ff83 upstream.

Apparently Bspec is wrong in this case here even for gm45. Note that
Bspec is horribly misguided on i965g/gm, so we don't have any other
data points besides that it seems to make machines work better.

With this changes all the bits in PORT_HOTPLUG_STAT for the digital
ports are ordered the same way. This seems to agree with what register
dumps from the hpd storm handling code shows, where the LIVE bit and
the short/long pulse STATUS bits light up at the same time with this
enumeration (but no with the one from Bspec).

Also tested on my gm45 which has two DP+ ports, and everything seems
to still work as expected.

References: http://www.mail-archive.com/intel-gfx@lists.freedesktop.org/msg23054.html
Cc: Egbert Eich <eich@suse.com>
Cc: Jan Niggemann <jn@hz6.de>
Tested-by: Jan Niggemann <jn@hz6.de>
[danvet: Add a big warning that Bspec seems to be wrong for these
bits, suggested by Jani.]
Acked-by: Jani Nikula <jani.nikula@linux.intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_reg.h |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -1675,10 +1675,16 @@
 #define CRT_HOTPLUG_DETECT_VOLTAGE_475MV	(1 << 2)
 
 #define PORT_HOTPLUG_STAT	(dev_priv->info->display_mmio_offset + 0x61114)
-/* HDMI/DP bits are gen4+ */
-#define   PORTB_HOTPLUG_LIVE_STATUS               (1 << 29)
+/*
+ * HDMI/DP bits are gen4+
+ *
+ * WARNING: Bspec for hpd status bits on gen4 seems to be completely confused.
+ * Please check the detailed lore in the commit message for for experimental
+ * evidence.
+ */
+#define   PORTD_HOTPLUG_LIVE_STATUS               (1 << 29)
 #define   PORTC_HOTPLUG_LIVE_STATUS               (1 << 28)
-#define   PORTD_HOTPLUG_LIVE_STATUS               (1 << 27)
+#define   PORTB_HOTPLUG_LIVE_STATUS               (1 << 27)
 #define   PORTD_HOTPLUG_INT_STATUS		(3 << 21)
 #define   PORTC_HOTPLUG_INT_STATUS		(3 << 19)
 #define   PORTB_HOTPLUG_INT_STATUS		(3 << 17)



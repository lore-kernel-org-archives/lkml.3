Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaFEEWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:22:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44386 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbaFEEV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 172/214] drm/i915: panel: invert brightness acer aspire 5734z
Date: Wed,  4 Jun 2014 21:18:55 -0700
Message-Id: <20140605041702.689521594@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

commit 5a15ab5b93e4a3ebcd4fa6c76cf646a45e9cf806 upstream.

Mark the Acer Aspire 5734Z that this machines requires the module to
invert the panel backlight brightness value after reading from and prior
to writing to the PCI configuration space.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
[wml: Backported to 3.4: Adjust context]
Signed-off-by: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/intel_display.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9201,7 +9201,8 @@ static void quirk_no_pcm_pwm_enable(stru
 }
 
 /*
- * A machine may need to invert the panel backlight brightness value
+ * A machine (e.g. Acer Aspire 5734Z) may need to invert the panel backlight
+ * brightness value
  */
 static void quirk_invert_brightness(struct drm_device *dev)
 {
@@ -9242,6 +9243,9 @@ struct intel_quirk intel_quirks[] = {
 	/* Sony Vaio Y cannot use SSC on LVDS */
 	{ 0x0046, 0x104d, 0x9076, quirk_ssc_force_disable },
 
+	/* Acer Aspire 5734Z must invert backlight brightness */
+	{ 0x2a42, 0x1025, 0x0459, quirk_invert_brightness },
+
 	/* Dell XPS13 HD Sandy Bridge */
 	{ 0x0116, 0x1028, 0x052e, quirk_no_pcm_pwm_enable },
 	/* Dell XPS13 HD and XPS13 FHD Ivy Bridge */



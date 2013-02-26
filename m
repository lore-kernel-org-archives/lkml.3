Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760586Ab3B0A7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:59:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42054 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760285Ab3BZX6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Widawsky <ben@bwidawsk.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 089/150] drm/i915: Use HAS_L3_GPU_CACHE in i915_gem_l3_remap
Date: Tue, 26 Feb 2013 15:55:46 -0800
Message-Id: <20130226235533.331200969@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit eb32e4584d8e9d6cbec20550d4f91396de2cdb55 upstream.

Yet another remnant ... this might explain why l3 remapping didn't
really work on HSW.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=57441
Spotted-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Ben Widawsky <ben@bwidawsk.net>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -3845,7 +3845,7 @@ void i915_gem_l3_remap(struct drm_device
 	u32 misccpctl;
 	int i;
 
-	if (!IS_IVYBRIDGE(dev))
+	if (!HAS_L3_GPU_CACHE(dev))
 		return;
 
 	if (!dev_priv->l3_parity.remap_info)



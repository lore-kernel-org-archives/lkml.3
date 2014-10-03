Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138AbaJDAye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:54:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44710 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbaJCVcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.16 026/357] drm/i915: Disable RCS flips on Ivybridge
Date: Fri,  3 Oct 2014 14:26:52 -0700
Message-Id: <20141003212934.256541428@linuxfoundation.org>
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

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 2a92d5bca1999b69c78f3c3e97b5484985b094b9 upstream.

We currently see random GPU hangs when using RCS flips with multiple
pipes on Ivybridge. Now that we have mmio flips, we can fairly cheaply
fallback to using CPU driven flips instead.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=77104
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9294,6 +9294,8 @@ static int intel_crtc_page_flip(struct d
 
 	if (IS_VALLEYVIEW(dev)) {
 		ring = &dev_priv->ring[BCS];
+	} else if (IS_IVYBRIDGE(dev)) {
+		ring = &dev_priv->ring[BCS];
 	} else if (INTEL_INFO(dev)->gen >= 7) {
 		ring = obj->ring;
 		if (ring == NULL || ring->id != RCS)



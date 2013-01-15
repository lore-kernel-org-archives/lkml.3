Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933741Ab3AOWwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:52:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:47046 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834Ab3AOWwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:52:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Julien Cristau <jcristau@debian.org>
Subject: [ 127/171] drm/i915: prevent possible pin leak on error path
Date: Tue, 15 Jan 2013 14:44:52 -0800
Message-Id: <20130115224322.504160423@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugeni Dodonov <eugeni.dodonov@intel.com>

commit ab3951eb74e7c33a2f5b7b64d72e82f1eea61571 upstream.

We should not hit this under any sane conditions, but still, this does not
looks right.

Reported-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
CC: Chris Wilson <chris@chris-wilson.co.uk>
CC: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Chris Wlison <chris@chris-wilson.co.uk>
Signed-off-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Julien Cristau <jcristau@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7505,7 +7505,7 @@ static int intel_gen7_queue_flip(struct
 	default:
 		WARN_ONCE(1, "unknown plane in flip command\n");
 		ret = -ENODEV;
-		goto err;
+		goto err_unpin;
 	}
 
 	ret = intel_ring_begin(ring, 4);



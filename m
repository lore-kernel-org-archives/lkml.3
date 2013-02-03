Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab3BCO5f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:57:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34462 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754699Ab3BCO5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:57:31 -0500
Message-Id: <20130203144651.978109332@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:13 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Eric Anholt <eric@anholt.net>,
        Kenneth Graunke <kenneth@whitecape.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 089/128] drm/i915: Correct the bit number for the MI_FLUSH_ENABLE.
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Anholt <eric@anholt.net>

commit fc74d8e01165b567922921d110b6d16320a61fa6 upstream.

Older specs claimed this was bit 11, but newer specs and the actual
simulator code say it was bit 12.  Regardless, we don't use MI_FLUSH,
or try to enable it any more.

Signed-off-by: Eric Anholt <eric@anholt.net>
Reviewed-by: Kenneth Graunke <kenneth@whitecape.org>
Reviewed-by: Ben Widawsky <ben@bwidawsk.net>
[danvet: Anyone trying to use this bit, please read all the relevant
discussions, it's epic.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_reg.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -399,7 +399,7 @@
 
 #define MI_MODE		0x0209c
 # define VS_TIMER_DISPATCH				(1 << 6)
-# define MI_FLUSH_ENABLE				(1 << 11)
+# define MI_FLUSH_ENABLE				(1 << 12)
 
 #define GEN6_GT_MODE	0x20d0
 #define   GEN6_GT_MODE_HI	(1 << 9)



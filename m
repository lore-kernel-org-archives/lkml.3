Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab3FZCug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 22:50:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54104 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467Ab3FZCpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 22:45:23 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Luis Henriques" <luis.henriques@canonical.com>,
        "Bradd Figg" <brad.figg@canonical.com>,
        "Steve Conklin" <sconklin@canonical.com>,
        "Stefan Bader" <stefan.bader@canonical.com>
Date: Wed, 26 Jun 2013 03:35:58 +0100
Message-ID: <lsq.1372214158.420710515@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [10/26] Revert "drm/i915: GFX_MODE Flush TLB Invalidate Mode must
 be  '1' for scanline waits"
In-Reply-To: <lsq.1372214158.425780530@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.48-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

This reverts commit 393143615d9f2f581d87387268dc11b95adc339c, which
was commit f05bb0c7b624252a5e768287e340e8e45df96e42 upstream.

This has been found to cause GPU hangs when backported to 3.2, though
not in mainline.

References: http://bugs.launchpad.net/bugs/1140716
Cc: Steve Conklin <sconklin@canonical.com>
Cc: Stefan Bader <stefan.bader@canonical.com>
Cc: Bradd Figg <brad.figg@canonical.com>
Cc: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_ringbuffer.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 4fddd21..38a7793 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -408,11 +408,6 @@ static int init_render_ring(struct intel_ring_buffer *ring)
 	if (INTEL_INFO(dev)->gen >= 6)
 		I915_WRITE(MI_MODE, GFX_MODE_ENABLE(ASYNC_FLIP_PERF_DISABLE));
 
-	/* Required for the hardware to program scanline values for waiting */
-	if (INTEL_INFO(dev)->gen == 6)
-		I915_WRITE(GFX_MODE,
-			   GFX_MODE_ENABLE(GFX_TLB_INVALIDATE_ALWAYS));
-
 	if (IS_GEN7(dev))
 		I915_WRITE(GFX_MODE_GEN7,
 			   GFX_MODE_DISABLE(GFX_TLB_INVALIDATE_ALWAYS) |


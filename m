Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbaC1CqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 22:46:15 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60557 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756885AbaC1CqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 22:46:14 -0400
Date: Fri, 28 Mar 2014 02:46:11 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1403280242370.28928@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

didn't want these to wait for stable cycle, the nouveau and radeon ones
are the same problem, where the runtime pm stuff broke non-runtime pm 
managed secondary GPUs, udl is an oops on unplug, and i915 is a regression 
fix on Sandybridge even though it may break haswell (regression wins).

Dave.

The following changes since commit b098d6726bbfb94c06d6e1097466187afddae61f:

  Linux 3.14-rc8 (2014-03-24 19:31:17 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 8ee661b505613ef2747b350ca2871a31b3781bee:

  drm/i915: Undo gtt scratch pte unmapping again (2014-03-28 12:33:50 +1000)

----------------------------------------------------------------
Daniel Vetter (1):
      drm/i915: Undo gtt scratch pte unmapping again

Dave Airlie (3):
      drm/udl: take reference to device struct for dma-bufs
      drm/nouveau: fail runtime pm properly.
      drm/radeon: fix runtime suspend breaking secondary GPUs

 drivers/gpu/drm/i915/i915_gem_gtt.c   |  2 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c | 14 ++++++++++----
 drivers/gpu/drm/radeon/radeon_drv.c   | 17 ++++++++++++-----
 drivers/gpu/drm/udl/udl_gem.c         | 11 ++++++++---
 4 files changed, 31 insertions(+), 13 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab3HWKjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 06:39:21 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39885 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755348Ab3HWKjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 06:39:20 -0400
Date: Fri, 23 Aug 2013 11:39:17 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1308231137530.9890@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1170244188-1377254357=:9890"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1170244188-1377254357=:9890
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Ben was on holidays for a week so a few nouveau regression fixes backed 
up, but they all seem necessary, otherwise one i915 and one gma500 fix.

Dave.

The following changes since commit 3387ed83943daf6cb1bb4195ae369067b9cd80ce:

  Merge tag 'drm-intel-fixes-2013-08-15' of git://people.freedesktop.org/~danvet/drm-intel (2013-08-19 13:49:20 +1000)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 4dd17ee95742f3e9fd55d07463981711a637bd20:

  Merge tag 'drm-intel-fixes-2013-08-23' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes (2013-08-23 18:52:37 +1000)

----------------------------------------------------------------

Ben Skeggs (2):
      drm/nouveau/mc: fix race condition between constructor and request_irq()
      drm/nv04/disp: fix framebuffer pin refcounting

Chris Wilson (1):
      drm/i915: Invalidate TLBs for the rings after a reset

Dave Airlie (2):
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes
      Merge tag 'drm-intel-fixes-2013-08-23' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes

Guillaume Clement (1):
      gma500: Fix SDVO turning off randomly

Ilia Mirkin (1):
      drm/nouveau/fb: fix null derefs in nv49 and nv4e init

Maarten Lankhorst (2):
      drm/nouveau/ltcg: fix ltcg memory initialization after suspend
      drm/nouveau/ltcg: fix allocating memory as free

Pali Rohár (1):
      drm/nouveau: fix reclocking on nv40

 drivers/gpu/drm/gma500/psb_intel_sdvo.c          |  3 +-
 drivers/gpu/drm/i915/i915_reg.h                  |  2 +
 drivers/gpu/drm/i915/intel_ringbuffer.c          | 12 +++++
 drivers/gpu/drm/nouveau/core/core/mm.c           |  4 ++
 drivers/gpu/drm/nouveau/core/include/subdev/mc.h |  7 +--
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv49.c | 12 ++---
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnv4e.c |  4 +-
 drivers/gpu/drm/nouveau/core/subdev/ltcg/nvc0.c  | 34 ++++++++++----
 drivers/gpu/drm/nouveau/core/subdev/mc/base.c    |  6 ++-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv04.c    |  3 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv44.c    |  3 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c    |  3 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv98.c    |  3 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c    |  3 +-
 drivers/gpu/drm/nouveau/dispnv04/crtc.c          | 58 ++++++++++++++++++------
 drivers/gpu/drm/nouveau/dispnv04/disp.h          |  1 +
 drivers/gpu/drm/nouveau/nouveau_display.c        |  3 ++
 drivers/gpu/drm/nouveau/nv40_pm.c                |  2 +-
 18 files changed, 114 insertions(+), 49 deletions(-)
--29444707-1170244188-1377254357=:9890--

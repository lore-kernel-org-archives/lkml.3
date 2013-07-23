Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428Ab3GWEkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 00:40:31 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41667 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab3GWEka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 00:40:30 -0400
Date: Tue, 23 Jul 2013 05:40:20 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes 
Message-ID: <alpine.DEB.2.00.1307230535040.3501@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1085120751-1374554420=:3501"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1085120751-1374554420=:3501
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

This is just a regular fixes pull, mostly nouveau and i915, the i915 ones
fix RC6 on Sandybridge after suspend/resume, which I think people have be 
wanting for quite a while!

Now you shouldn't wish for more patches, as the new mutex/reservation code 
found a number of problems with the qxl driver, and it currently makes 
lockdep angry, I'm working on a set of fixes for it, but its a bit large, 
I'll submit them separately later today or tomorrow once I've banged on 
them a bit more, just warning you in advance :-)

Dave.

The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:

  Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 058ca4a22ebf22ea1cbedd6cc0340ed1e2e94ee1:

  Merge tag 'drm-intel-fixes-2013-07-22' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes (2013-07-22 16:14:26 +1000)

----------------------------------------------------------------

Ben Skeggs (4):
      Merge remote-tracking branch 'airlied/drm-next' into drm-nouveau-next
      drm/nouveau: fix locking issues in page flipping paths
      drm/nv50/kms: fix pin refcnt leaks
      drm/nouveau: use dedicated channel for async moves on GT/GF chipsets.

Chris Wilson (2):
      drm/i915: Fix dereferencing invalid connectors in is_crtc_connector_off()
      drm/i915: Serialize almost all register access

Daniel Vetter (7):
      drm/i915: fix up readout of the lvds dither bit on gen2/3
      drm/i915: fix pfit regression for non-autoscaled resolutions
      drm/i915: Sanitize shared dpll state
      Merge tag 'v3.10' into drm-intel-fixes
      drm/i915: correctly restore fences with objects attached
      drm/i915: fix up gt init sequence fallout
      drm/crtc-helper: explicit DPMS on after modeset

Dave Airlie (2):
      Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6
      Merge tag 'drm-intel-fixes-2013-07-22' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes

Kamal Mostafa (1):
      drm/i915: quirk no PCH_PWM_ENABLE for Dell XPS13 backlight

Konstantin Khlebnikov (1):
      drm/i915: fix long-standing SNB regression in power consumption after resume v2

Maarten Lankhorst (5):
      drm/nouveau: fix some error-path leaks in fbcon handling code
      drm/nouveau: do not unpin in nouveau_gem_object_del
      drm/nouveau: bump fence timeout to 15 seconds
      drm/nouveau: add falcon interrupt handler
      drm/nouveau: do not allow negative sizes for now

Stéphane Marchesin (1):
      drm/i915: Preserve the DDI_A_4_LANES bit from the bios

 drivers/gpu/drm/drm_crtc_helper.c                  | 27 ++++-----
 drivers/gpu/drm/i915/i915_dma.c                    | 18 +++---
 drivers/gpu/drm/i915/i915_drv.c                    | 13 ++--
 drivers/gpu/drm/i915/i915_drv.h                    |  3 +-
 drivers/gpu/drm/i915/i915_gem.c                    | 18 +++++-
 drivers/gpu/drm/i915/intel_ddi.c                   | 10 ++--
 drivers/gpu/drm/i915/intel_display.c               | 69 ++++++++++++++++------
 drivers/gpu/drm/i915/intel_drv.h                   |  2 +-
 drivers/gpu/drm/i915/intel_lvds.c                  | 12 ++--
 drivers/gpu/drm/i915/intel_panel.c                 |  6 +-
 drivers/gpu/drm/i915/intel_pm.c                    |  8 ++-
 drivers/gpu/drm/nouveau/core/engine/bsp/nvc0.c     |  1 +
 drivers/gpu/drm/nouveau/core/engine/bsp/nve0.c     |  1 +
 drivers/gpu/drm/nouveau/core/engine/falcon.c       | 19 ++++++
 drivers/gpu/drm/nouveau/core/engine/ppp/nvc0.c     |  1 +
 drivers/gpu/drm/nouveau/core/engine/vp/nvc0.c      |  1 +
 drivers/gpu/drm/nouveau/core/engine/vp/nve0.c      |  1 +
 .../gpu/drm/nouveau/core/include/engine/falcon.h   |  2 +
 drivers/gpu/drm/nouveau/nouveau_bo.c               | 21 +++++--
 drivers/gpu/drm/nouveau/nouveau_display.c          | 69 ++++++++++------------
 drivers/gpu/drm/nouveau/nouveau_drm.c              | 15 ++++-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |  1 +
 drivers/gpu/drm/nouveau/nouveau_fence.c            |  2 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |  6 --
 drivers/gpu/drm/nouveau/nv50_display.c             | 46 +++++++++++----
 25 files changed, 242 insertions(+), 130 deletions(-)
--29444707-1085120751-1374554420=:3501--

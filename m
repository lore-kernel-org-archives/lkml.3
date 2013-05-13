Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3EMCWl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 22:22:41 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51941 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782Ab3EMCWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 22:22:40 -0400
Date: Mon, 13 May 2013 03:22:45 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1305130311280.15866@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-759925859-1368411765=:15866"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-759925859-1368411765=:15866
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

just a few straggling fixes I hoovered up, and an intel fixes pull from 
Daniel which fixes some regressions, and some mgag200 fixes from Matrox.

Dave.


The following changes since commit 307b9c022720f9de90d58e51743e01e9a42aec59:

  qxl: update to new idr interfaces. (2013-05-03 10:37:20 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux.git drm-next

for you to fetch changes up to 9f1d036648c1c5ed81b0e98d7a06d55df972701e:

  drm/mgag200: Fix framebuffer base address programming (2013-05-13 12:17:32 +1000)

----------------------------------------------------------------
Ben Widawsky (1):
      Revert "drm/i915: Calculate correct stolen size for GEN7+"

Chris Cummins (1):
      drm: Use names of ioctls in debug traces

Chris Wilson (1):
      drm/i915: Always normalize return timeout for wait_timeout_ioctl

Christopher Harvey (4):
      drm/mgag200: Don't change unrelated registers during modeset
      drm/mgag200: Fix writes into MGA1064_PIX_CLK_CTL register
      drm/mgag200: Convert counter delays to jiffies
      drm/mgag200: Fix framebuffer base address programming

Damien Lespiau (2):
      drm: Add missing break in the command line mode parsing code
      drm: Don't prune modes loudly when a connector is disconnected

Daniel Vetter (3):
      drm/mm: fix dump table BUG
      drm: don't check modeset locks in panic handler
      Revert "drm/i915: revert eDP bpp clamping code changes"

Dave Airlie (1):
      Merge branch 'for-linux-next' of git://people.freedesktop.org/~danvet/drm-intel into drm-next

Imre Deak (1):
      drm/i915: hsw: fix link training for eDP on port-A

Jani Nikula (1):
      drm/i915: clear the stolen fb before resuming

Kees Cook (1):
      drm: refactor call to request_module

Lespiau, Damien (2):
      drm: Make the HPD status updates debug logs more readable
      drm: Only print a debug message when the polled connector has changed

Ville Syrjälä (3):
      drm/i915: Fix pipe enabled mask for pipe C in WM calculations
      drm: Add kernel-doc for drm_fb_helper_funcs->initial_config
      drm: Remove pointless '-' characters from drm_fb_helper documentation

 drivers/gpu/drm/drm_crtc.c             |  5 ++
 drivers/gpu/drm/drm_crtc_helper.c      | 27 +++++++---
 drivers/gpu/drm/drm_drv.c              | 20 +++++---
 drivers/gpu/drm/drm_encoder_slave.c    |  6 +--
 drivers/gpu/drm/drm_mm.c               | 34 +++++++------
 drivers/gpu/drm/drm_modes.c            |  1 +
 drivers/gpu/drm/i915/i915_gem.c        |  8 ++-
 drivers/gpu/drm/i915/i915_gem_gtt.c    | 15 +-----
 drivers/gpu/drm/i915/i915_reg.h        |  2 -
 drivers/gpu/drm/i915/intel_ddi.c       |  5 ++
 drivers/gpu/drm/i915/intel_dp.c        | 77 ++++++++++++++++++-----------
 drivers/gpu/drm/i915/intel_drv.h       |  1 +
 drivers/gpu/drm/i915/intel_fb.c        | 16 +++++-
 drivers/gpu/drm/i915/intel_pm.c        | 44 ++++++++---------
 drivers/gpu/drm/mgag200/mgag200_mode.c | 90 ++++++++++++++++++++--------------
 include/drm/drmP.h                     |  3 +-
 include/drm/drm_fb_helper.h            | 15 +++---
 17 files changed, 213 insertions(+), 156 deletions(-)
--29444707-759925859-1368411765=:15866--

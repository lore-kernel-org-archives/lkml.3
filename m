Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab3CUDNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 23:13:19 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57355 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab3CUDNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 23:13:18 -0400
Date: Thu, 21 Mar 2013 03:13:10 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1303210310410.4751@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

radeon, intel and nouveau, along with one mgag200 fix,

intel fix for an ioctl overflow, along with a regression fix for some 
phantom irqs on Ironlake.
nouveau has a lockdep warning and a bunch of thermal fixes
radeon has new pci ids and some minor fixes.

Dave.

The following changes since commit 10b38669d64c757cfd927e3820292c580ed70aae:

  Merge tag 'for-linus-v3.9-rc4' of git://oss.sgi.com/xfs/xfs (2013-03-19 15:17:40 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to b56fb70870ad76f8295a4e826dab9a9fbb0033f6:

  Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-next (2013-03-21 10:17:38 +1000)

----------------------------------------------------------------

Alex Deucher (6):
      drm/radeon: fix S/R on VM systems (cayman/TN/SI)
      drm/radeon: fix backend map setup on 1 RB trinity boards
      drm/radeon/benchmark: make sure bo blit copy exists before using it
      drm/radeon/benchmark: allow same domains for dma copy
      drm/radeon: add support for Richland APUs
      drm/radeon: add Richland pci ids

Ben Skeggs (2):
      drm/nouveau/core: fix return value of nouveau_object_del()
      drm/nv50/kms: prevent lockdep false-positive in page flipping path

Daniel Vetter (1):
      MAINTAINERS: intel-gfx is no longer subscribers-only

Dave Airlie (3):
      Merge branch 'drm-nouveau-fixes-3.9' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next
      Merge branch 'drm-fixes-3.9' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-next

Jiri Kosina (1):
      drm/i915: stop using GMBUS IRQs on Gen4 chips

Julia Lemire (1):
      drm/mgag200: Bug fix: Modified pll algorithm for EH project

Kees Cook (2):
      drm/i915: restrict kernel address leak in debugfs
      drm/i915: bounds check execbuffer relocation count

Martin Peres (11):
      drm/nv40/therm: improve selection between the old and the new style
      drm/nv40/therm: increase the sensor's settling delay to 20ms
      drm/nouveau/therm: do not make assumptions on temperature
      drm/nouveau/therm: remove some confusion introduced by therm_mode
      drm/nouveau/therm-ic: the temperature is off by sensor_constant, warn the user
      drm/nv40/therm: disable temperature reading if the bios misses some parameters
      drm/nv40/therm: reserve negative temperatures for errors
      drm/nouveau/therm: disable auto fan management if temperature is not available
      drm/nouveau/therm: disable temperature management if the sensor isn't readable
      drm/nouveau/therm: display the availability of the internal sensor
      drm/nouveau/hwmon: do not expose a buggy temperature if it is unavailable

Takashi Iwai (2):
      Revert "drm/i915: try to train DP even harder"
      drm/i915: Use the fixed pixel clock for eDP in intel_dp_set_m_n()

 MAINTAINERS                                        |  2 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |  2 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         | 11 +++-
 drivers/gpu/drm/i915/intel_dp.c                    | 14 ++++-
 drivers/gpu/drm/i915/intel_i2c.c                   | 11 +++-
 drivers/gpu/drm/mgag200/mgag200_mode.c             | 10 ++--
 drivers/gpu/drm/nouveau/core/core/object.c         |  3 +-
 .../gpu/drm/nouveau/core/include/subdev/therm.h    |  2 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/base.c   | 18 ++++--
 drivers/gpu/drm/nouveau/core/subdev/therm/ic.c     |  6 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/nv40.c   | 67 ++++++++++++++++------
 drivers/gpu/drm/nouveau/core/subdev/therm/priv.h   |  3 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/temp.c   | 30 +++++-----
 drivers/gpu/drm/nouveau/nouveau_pm.c               | 44 +++++++++-----
 drivers/gpu/drm/nouveau/nv50_display.c             |  4 +-
 drivers/gpu/drm/radeon/ni.c                        | 33 +++++++++--
 drivers/gpu/drm/radeon/radeon_benchmark.c          | 21 ++++---
 drivers/gpu/drm/radeon/si.c                        |  1 +
 include/drm/drm_pciids.h                           | 13 ++++-
 19 files changed, 204 insertions(+), 91 deletions(-)

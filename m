Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaBFFXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 00:23:49 -0500
Received: from gir.skynet.ie ([193.1.99.77]:58297 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbaBFFXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 00:23:47 -0500
Date: Thu, 6 Feb 2014 05:23:45 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1402060522001.31796@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

a few regression fixes already, one for my own stupidity, and mgag200 typo 
fix, vmwgfx fixes and ttm regression fixes, and a radeon register checker 
update for older cards to handle geom shaders.

Dave.

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 7c4c62a04a2a80e3feb5d6c97aca1e413b11c790:

  drm/radeon: allow geom rings to be setup on r600/r700 (v2) (2014-02-06 12:13:52 +1000)

----------------------------------------------------------------
Dave Airlie (5):
      drm/mgag200: fix typo causing bw limits to be ignored on some chips
      drm/mgag200,ast,cirrus: fix regression with drm_can_sleep conversion
      Merge tag 'ttm-fixes-3.14-2014-02-05' of git://people.freedesktop.org/~thomash/linux into drm-next
      Merge tag 'vmwgfx-fixes-3.14-2014-02-05' of git://people.freedesktop.org/~thomash/linux into drm-next
      drm/radeon: allow geom rings to be setup on r600/r700 (v2)

Dave Jones (1):
      vmwgfx: Fix unitialized stack read in vmw_setup_otable_base

Thomas Hellstrom (9):
      drm/vmwgfx: Don't commit staged bindings if execbuf fails
      drm/vmwgfx: Fix regression caused by "drm/ttm: make ttm reservation calls behave like reservation calls"
      drm/vmwgfx: Fix SET_SHADER_CONST emulation on guest-backed devices
      drm/vmwgfx: Fix legacy surface reference size copyback
      drm/vmwgfx: Emulate legacy shaders on guest-backed devices v2
      drm/vmwgfx: Detect old user-space drivers and set up legacy emulation v2
      drm/vmwgfx: Reemit context bindings when necessary v2
      drm/ttm: Fix TTM object open regression
      drm/ttm: Don't clear page metadata of imported sg pages

 drivers/gpu/drm/ast/ast_fb.c             |   2 +-
 drivers/gpu/drm/cirrus/cirrus_fbdev.c    |   2 +-
 drivers/gpu/drm/mgag200/mgag200_fb.c     |   2 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c   |   4 +-
 drivers/gpu/drm/radeon/r600_cs.c         |  18 +-
 drivers/gpu/drm/radeon/radeon_drv.c      |   3 +-
 drivers/gpu/drm/radeon/reg_srcs/r600     |   1 +
 drivers/gpu/drm/ttm/ttm_object.c         |   2 +-
 drivers/gpu/drm/ttm/ttm_tt.c             |   3 +
 drivers/gpu/drm/vmwgfx/svga3d_reg.h      |  24 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_context.c  | 144 ++++++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c      |   7 +
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h      |  35 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c  | 330 +++++++++++++++++++---
 drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c    |  93 ++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_mob.c      |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c |  11 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c   | 467 +++++++++++++++++++++++++++----
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c  |   6 +-
 19 files changed, 1016 insertions(+), 139 deletions(-)

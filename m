Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaKBTlM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 14:41:12 -0500
Received: from gir.skynet.ie ([193.1.99.77]:45654 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbaKBTlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 14:41:09 -0500
Date: Sun, 2 Nov 2014 19:41:02 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1411021938010.11887@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-503844566-1414957262=:11887"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-503844566-1414957262=:11887
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

drm fixes, nothing too astounding or major, radeon, i915
vmwgfx, armada and exynos.

biggest ones:
vmwgfx has one big locking regression fix,
i915 has come displayport fixes
radeon has some stability and a memory alloc failure
armada and exynos have some vblank fixes.

Dave.

The following changes since commit f7e87a44ef60ad379e39b45437604141453bf0ec:

  Merge tag 'media/v3.18-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media (2014-10-27 15:05:40 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 66338feee458cb2b04e8f2b515b8d660e49ba29a:

  Merge branch 'exynos-drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/daeinki/drm-exynos into drm-fixes (2014-11-03 05:23:17 +1000)

----------------------------------------------------------------

Alex Deucher (3):
      drm/radeon/dpm: disable ulv support on SI
      drm/radeon: dpm fixes for asrock systems
      drm/radeon: remove invalid pci id

Andrzej Hajda (6):
      drm/exynos: init vblank with real number of crtcs
      drm/exynos: remove explicit encoder/connector de-initialization
      drm/exynos: propagate plane initialization errors
      drm/exynos: init kms poll at the end of initialization
      drm/exynos: enable vblank after DPMS on
      drm/exynos: correct connector->dpms field before resuming

Dan Carpenter (1):
      drm/radeon: remove some buggy dead code

Dave Airlie (5):
      Merge branch 'drm-armada-fixes' of git://ftp.arm.linux.org.uk/~rmk/linux-arm into drm-fixes
      Merge tag 'drm-intel-fixes-2014-10-30' of git://anongit.freedesktop.org/drm-intel into drm-fixes
      Merge branch 'drm-fixes-3.18' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge branch 'vmwgfx-fixes-3.18' of git://people.freedesktop.org/~thomash/linux
      Merge branch 'exynos-drm-fixes' of git://git.kernel.org/.../daeinki/drm-exynos into drm-fixes

Inki Dae (1):
      drm/exynos: vidi: fix build warning

Jani Nikula (1):
      drm/i915/dp: only use training pattern 3 on platforms that support it

Michel Dänzer (1):
      drm/radeon: Use drm_malloc_ab instead of kmalloc_array

Rob Clark (1):
      drm/vmwgfx: fix lock breakage

Russell King (3):
      drm/armada: add IRQ support back
      drm/armada: fix page_flip refcounting leak
      drm/armada: convert to use vblank_on/off calls

Sinclair Yeh (1):
      drm/vmwgfx: Filter out modes those cannot be supported by the current VRAM size.

Thomas Hellstrom (1):
      drm/vmwgfx: Fix hash key computation

Ville Syrjälä (3):
      drm/i915: Do a dummy DPCD read before the actual read
      drm/i915: Ignore long hpds on eDP ports
      drm/i915: Fix GMBUSFREQ on vlv/chv

Wilfried Klaebe (1):
      radeon: clean up coding style differences in radeon_get_bios()

jens stein (1):
      drm/i915: Ignore VBT backlight check on Macbook 2, 1

 drivers/gpu/drm/armada/armada_crtc.c       | 21 +++++++--------
 drivers/gpu/drm/armada/armada_drv.c        |  3 ++-
 drivers/gpu/drm/exynos/exynos_dp_core.c    |  5 ----
 drivers/gpu/drm/exynos/exynos_drm_crtc.c   |  5 +++-
 drivers/gpu/drm/exynos/exynos_drm_dpi.c    |  4 ---
 drivers/gpu/drm/exynos/exynos_drm_drv.c    | 43 +++++++++++++++++-------------
 drivers/gpu/drm/exynos/exynos_drm_dsi.c    |  4 ---
 drivers/gpu/drm/exynos/exynos_drm_vidi.c   |  4 ---
 drivers/gpu/drm/exynos/exynos_hdmi.c       |  6 -----
 drivers/gpu/drm/i915/intel_display.c       |  5 +++-
 drivers/gpu/drm/i915/intel_dp.c            | 24 +++++++++++++++--
 drivers/gpu/drm/radeon/evergreen.c         |  4 +--
 drivers/gpu/drm/radeon/kv_dpm.c            | 19 ++++++++++---
 drivers/gpu/drm/radeon/radeon_bios.c       |  6 ++---
 drivers/gpu/drm/radeon/radeon_cs.c         |  2 +-
 drivers/gpu/drm/radeon/radeon_ring.c       |  4 +--
 drivers/gpu/drm/radeon/radeon_vm.c         |  4 +--
 drivers/gpu/drm/radeon/si_dpm.c            |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c |  3 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c        |  6 ++++-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c        | 24 ++++++++++++-----
 include/drm/drm_pciids.h                   |  1 -
 22 files changed, 116 insertions(+), 83 deletions(-)
--29444707-503844566-1414957262=:11887--

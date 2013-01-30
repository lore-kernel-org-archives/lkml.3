Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab3A3AoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 19:44:04 -0500
Received: from gir.skynet.ie ([193.1.99.77]:53355 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab3A3AoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 19:44:02 -0500
Date: Wed, 30 Jan 2013 00:43:49 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1301300039180.1288@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1245153662-1359506629=:1288"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1245153662-1359506629=:1288
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

from LCA request, intel, radeon and exynos fixes, nothing too major or 
wierd, one dmar fix and a radeon cursor corruption, along with misc exynos 
fixes.

Dave.

The following changes since commit 014b34409fb2015f63663b6cafdf557fdf289628:

  ttm: on move memory failure don't leave a node dangling (2013-01-21 13:45:23 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 483674325f64a37c7696edb12ce6ad3e535421bc:

  Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel (2013-01-26 18:17:39 +1000)

----------------------------------------------------------------

Arnd Bergmann (2):
      drm/exynos: don't include plat/gpio-cfg.h
      drm/exynos: fimd and ipp are broken on multiplatform

Chris Wilson (2):
      drm/i915: Disable AsyncFlip performance optimisations
      drm/i915: GFX_MODE Flush TLB Invalidate Mode must be '1' for scanline waits

Daniel Vetter (2):
      iommu/intel: disable DMAR for g4x integrated gfx
      drm/i915: dump UTS_RELEASE into the error_state

Dave Airlie (3):
      Merge branch 'drm-fixes-3.8' of git://people.freedesktop.org/~agd5f/linux into drm-next
      Merge branch 'exynos-drm-fixes' of git://git.kernel.org/.../daeinki/drm-exynos into drm-next
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel

Ilija Hadzic (1):
      drm/radeon: fix a rare case of double kfree

Inki Dae (2):
      drm/exynos: free sg object if dma_map_sg is failed
      drm/exynos: consider DMA_NONE flag to dmabuf import

Jerome Glisse (1):
      drm/radeon: fix cursor corruption on DCE6 and newer

Michel Dänzer (1):
      drm/radeon: Enable DMA_IB_SWAP_ENABLE on big endian hosts.

Rahul Sharma (1):
      drm/exynos: let drm handle edid allocations

Sachin Kamat (4):
      drm/exynos: Make g2d_userptr_get_dma_addr static
      drm/exynos: Make ipp_handle_cmd_work static
      drm/exynos: Add missing static specifiers in exynos_drm_rotator.c
      drm/exynos: Make 'drm_hdmi_get_edid' static

Sean Paul (2):
      drm/exynos: Replace mdelay with usleep_range
      drm/exynos: Remove "internal" interrupt handling

Seung-Woo Kim (1):
      drm/exynos: added validation of edid for vidi connection

Shirish S (1):
      drm/exynos: add check for the device power status

xueminsu (1):
      radeon_display: Use pointer return error codes

 drivers/gpu/drm/exynos/Kconfig                |   4 +-
 drivers/gpu/drm/exynos/exynos_drm_connector.c |  33 ++++---
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c    |  24 +++--
 drivers/gpu/drm/exynos/exynos_drm_drv.h       |   4 +-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c       |   2 +-
 drivers/gpu/drm/exynos/exynos_drm_hdmi.c      |   9 +-
 drivers/gpu/drm/exynos/exynos_drm_hdmi.h      |   4 +-
 drivers/gpu/drm/exynos/exynos_drm_ipp.c       |   2 +-
 drivers/gpu/drm/exynos/exynos_drm_rotator.c   |   4 +-
 drivers/gpu/drm/exynos/exynos_drm_vidi.c      |  26 +++---
 drivers/gpu/drm/exynos/exynos_hdmi.c          | 121 ++++++++------------------
 drivers/gpu/drm/exynos/exynos_mixer.c         |   9 +-
 drivers/gpu/drm/i915/i915_debugfs.c           |   2 +
 drivers/gpu/drm/i915/i915_reg.h               |   1 +
 drivers/gpu/drm/i915/intel_ringbuffer.c       |  24 +++--
 drivers/gpu/drm/radeon/ni.c                   |   8 +-
 drivers/gpu/drm/radeon/r600.c                 |   8 +-
 drivers/gpu/drm/radeon/radeon_cs.c            |   2 +
 drivers/gpu/drm/radeon/radeon_cursor.c        |   3 +-
 drivers/gpu/drm/radeon/radeon_display.c       |   2 +-
 drivers/iommu/intel-iommu.c                   |  21 +++--
 21 files changed, 155 insertions(+), 158 deletions(-)
--29444707-1245153662-1359506629=:1288--

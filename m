Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaBQPzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 10:55:42 -0500
Received: from adelie.canonical.com ([91.189.90.139]:49188 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaBQPzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 10:55:40 -0500
Subject: [PATCH 0/6] dma-buf synchronization patches
To: linux-kernel@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, ccross@google.com,
        linaro-mm-sig@lists.linaro.org, robdclark@gmail.com,
        dri-devel@lists.freedesktop.org, daniel@ffwll.ch,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org
Date: Mon, 17 Feb 2014 16:55:34 +0100
Message-ID: <20140217155056.20337.25254.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements fence and converts dma-buf and
android sync to use it. Patch 6 and 7 add support for polling
to dma-buf, blocking until all fences are signaled.

I've dropped the extra patch to copy an export from the core,
and instead use the public version of it. I've had to fix
some fallout from the rebase, hopefully everything's clean now,
and ready for -next.
---
Maarten Lankhorst (6):
      fence: dma-buf cross-device synchronization (v17)
      seqno-fence: Hardware dma-buf implementation of fencing (v4)
      dma-buf: use reservation objects
      android: convert sync to fence api, v3
      reservation: add support for fences to enable cross-device synchronisation
      dma-buf: add poll support, v2

 Documentation/DocBook/device-drivers.tmpl      |    3 
 drivers/base/Kconfig                           |    9 
 drivers/base/Makefile                          |    2 
 drivers/base/dma-buf.c                         |  123 +++
 drivers/base/fence.c                           |  465 +++++++++++++
 drivers/gpu/drm/drm_prime.c                    |    8 
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c     |    2 
 drivers/gpu/drm/i915/i915_gem_dmabuf.c         |    2 
 drivers/gpu/drm/nouveau/nouveau_drm.c          |    1 
 drivers/gpu/drm/nouveau/nouveau_gem.h          |    1 
 drivers/gpu/drm/nouveau/nouveau_prime.c        |    7 
 drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c      |    2 
 drivers/gpu/drm/radeon/radeon_drv.c            |    2 
 drivers/gpu/drm/radeon/radeon_prime.c          |    8 
 drivers/gpu/drm/ttm/ttm_object.c               |    2 
 drivers/media/v4l2-core/videobuf2-dma-contig.c |    2 
 drivers/staging/android/Kconfig                |    1 
 drivers/staging/android/Makefile               |    2 
 drivers/staging/android/sw_sync.c              |    4 
 drivers/staging/android/sync.c                 |  892 ++++++++----------------
 drivers/staging/android/sync.h                 |   80 +-
 drivers/staging/android/sync_debug.c           |  245 +++++++
 drivers/staging/android/trace/sync.h           |   12 
 include/drm/drmP.h                             |    2 
 include/linux/dma-buf.h                        |   21 -
 include/linux/fence.h                          |  329 +++++++++
 include/linux/reservation.h                    |   18 
 include/linux/seqno-fence.h                    |  109 +++
 include/trace/events/fence.h                   |  125 +++
 29 files changed, 1822 insertions(+), 657 deletions(-)
 create mode 100644 drivers/base/fence.c
 create mode 100644 drivers/staging/android/sync_debug.c
 create mode 100644 include/linux/fence.h
 create mode 100644 include/linux/seqno-fence.h
 create mode 100644 include/trace/events/fence.h

-- 
Signature

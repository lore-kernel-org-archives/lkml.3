Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbaESHLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 03:11:25 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11784 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbaESHLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 03:11:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 19 May 2014 00:06:30 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 0/4] drm/ttm: nouveau: memory coherency fixes for ARM
Date: Mon, 19 May 2014 16:10:54 +0900
Message-ID: <1400483458-9648-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small series introduces TTM helper functions as well as Nouveau hooks that
are needed to ensure buffer coherency on ARM. Most of this series is a
forward-port of some patches Lucas Stach sent last year and that are also
needed for Nouveau GK20A support:

http://lists.freedesktop.org/archives/nouveau/2013-August/014026.html

Another patch takes care of flushing the CPU write-buffer when writing BOs
through a non-BAR path.

Alexandre Courbot (1):
  drm/nouveau: introduce CPU cache flushing macro

Lucas Stach (3):
  drm/ttm: recognize ARM arch in ioprot handler
  drm/ttm: introduce dma cache sync helpers
  drm/nouveau: hook up cache sync functions

 drivers/gpu/drm/nouveau/core/os.h     | 17 +++++++++++++++
 drivers/gpu/drm/nouveau/nouveau_bo.c  | 40 +++++++++++++++++++++++++++++++++--
 drivers/gpu/drm/nouveau/nouveau_bo.h  | 20 ++++++++++++++++++
 drivers/gpu/drm/nouveau/nouveau_gem.c |  8 ++++++-
 drivers/gpu/drm/ttm/ttm_bo_util.c     |  2 +-
 drivers/gpu/drm/ttm/ttm_tt.c          | 25 ++++++++++++++++++++++
 include/drm/ttm/ttm_bo_driver.h       | 28 ++++++++++++++++++++++++
 7 files changed, 136 insertions(+), 4 deletions(-)

-- 
1.9.2


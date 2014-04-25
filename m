Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaDYHVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 03:21:11 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:1493 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaDYHUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 03:20:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 25 Apr 2014 00:11:37 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <nouveau@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v3 0/9] drm/nouveau: support for GK20A, cont'd
Date: Fri, 25 Apr 2014 16:19:47 +0900
Message-ID: <1398410396-23338-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v2:
- Enabled software class
- Removed unneeded changes to nouveau_accel_init()
- Replaced use of architecture-private pfn_to_dma() and dma_to_pfn() with
  the portable page_to_phys()/phys_to_page()
- Fixed incorrect comment/commit log talking about bytes instead of words

Hope this looks good! Once this gets merged the next set will be to use this
driver on Jetson and Venice2 boards.

Cheers,

Alexandre Courbot (9):
  drm/nouveau/bar: only ioremap BAR3 if it exists
  drm/nouveau/bar/nvc0: support chips without BAR3
  drm/nouveau/ibus: add GK20A support
  drm/nouveau/fb: add GK20A support
  drm/nouveau/fifo: add GK20A support
  drm/nouveau/graph: enable when using external firmware
  drm/nouveau/graph: pad firmware code at load time
  drm/nouveau/graph: add GK20A support
  drm/nouveau: support for probing GK20A

 drivers/gpu/drm/nouveau/Makefile                   |   6 +
 drivers/gpu/drm/nouveau/core/engine/device/nve0.c  |  17 +++
 drivers/gpu/drm/nouveau/core/engine/fifo/gk20a.c   |  35 +++++
 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.h    |   1 +
 .../gpu/drm/nouveau/core/engine/graph/ctxgk20a.c   |  53 +++++++
 .../gpu/drm/nouveau/core/engine/graph/ctxnvc0.h    |   9 ++
 .../gpu/drm/nouveau/core/engine/graph/ctxnve4.c    |  14 +-
 drivers/gpu/drm/nouveau/core/engine/graph/gk20a.c  |  47 ++++++
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c   |  13 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.h   |   2 +
 drivers/gpu/drm/nouveau/core/engine/graph/nve4.c   |   4 +-
 drivers/gpu/drm/nouveau/core/include/engine/fifo.h |   1 +
 .../gpu/drm/nouveau/core/include/engine/graph.h    |   1 +
 drivers/gpu/drm/nouveau/core/include/subdev/fb.h   |   1 +
 drivers/gpu/drm/nouveau/core/include/subdev/ibus.h |   1 +
 drivers/gpu/drm/nouveau/core/subdev/bar/base.c     |   6 +-
 drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c     | 114 +++++++-------
 drivers/gpu/drm/nouveau/core/subdev/fb/gk20a.c     |  56 +++++++
 drivers/gpu/drm/nouveau/core/subdev/fb/priv.h      |   1 +
 drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c  | 167 +++++++++++++++++++++
 drivers/gpu/drm/nouveau/core/subdev/ibus/gk20a.c   | 103 +++++++++++++
 21 files changed, 583 insertions(+), 69 deletions(-)
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/gk20a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/ctxgk20a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/gk20a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/gk20a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/ibus/gk20a.c

-- 
1.9.2


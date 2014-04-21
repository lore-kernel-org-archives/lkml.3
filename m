Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaDUGDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 02:03:39 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3823 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaDUGDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 02:03:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 20 Apr 2014 22:58:08 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <nouveau@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v2 00/10] drm/nouveau: support for GK20A, cont'd
Date: Mon, 21 Apr 2014 15:02:12 +0900
Message-ID: <1398060142-7937-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Way overdue v2 of the final patches that enable basic GK20A support. Hopefully
all the issues raised with v1 have been addressed.

Changes since v1:
- Use gk20a clock driver by Ben instead of twiddling nv04's
- Name new classes after gk20a instead of nvea
- Addressed comments about BAR initialization code factorization
- Removed non-essential code which only purpose was to avoid warnings
- Use nv_wait in ibus driver

Alexandre Courbot (10):
  drm/nouveau/bar: only ioremap BAR3 if it exists
  drm/nouveau/bar/nvc0: support chips without BAR3
  drm/nouveau/ibus: add GK20A support
  drm/nouveau/fb: add GK20A support
  drm/nouveau/fifo: add GK20A support
  drm/nouveau/graph: enable when using external firmware
  drm/nouveau/graph: pad firmware code at load time
  drm/nouveau/graph: add GK20A support
  drm/nouveau: support GK20A in nouveau_accel_init()
  drm/nouveau: support for probing GK20A

 drivers/gpu/drm/nouveau/Makefile                   |   6 +
 drivers/gpu/drm/nouveau/core/engine/device/nve0.c  |  20 +++
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
 drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c  | 168 +++++++++++++++++++++
 drivers/gpu/drm/nouveau/core/subdev/ibus/gk20a.c   | 103 +++++++++++++
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   5 +
 22 files changed, 592 insertions(+), 69 deletions(-)
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/gk20a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/ctxgk20a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/gk20a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/gk20a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/ibus/gk20a.c

-- 
1.9.2


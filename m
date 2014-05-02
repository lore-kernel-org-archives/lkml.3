Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbaEBJdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 05:33:43 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15460 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaEBJdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 05:33:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 02 May 2014 02:28:00 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <nouveau@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v4 0/9] drm/nouveau: support for GK20A, cont'd
Date: Fri, 2 May 2014 18:32:33 +0900
Message-ID: <1399023162-13159-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest patches for GK20A, taking comments received for v3 into account.

Changes since v3:
- use only pfn_to_page() and page_to_pfn() in GK20A's FB. These functions
  are present on every arch and the physical address to page frame number
  conversion is also consistently a shift of PAGE_SHIFT. This part will
  probably be replaced by something nicer in the future anyway.
- fixed a warning on 64-bit architectures when printing a dma_addr_t
- tested compilation on x86_64 and ensured there was no error! ;)
- in graph, always use external firmware if no microcode is linked for the
  graph class (instead of only relying on the NvGrUseFW parameter).

Alexandre Courbot (9):
  drm/nouveau/bar: only ioremap BAR3 if it exists
  drm/nouveau/bar/nvc0: support chips without BAR3
  drm/nouveau/ibus: add GK20A support
  drm/nouveau/fb: add GK20A support
  drm/nouveau/fifo: add GK20A support
  drm/nouveau/graph: enable when using external fw
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
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c   |  14 +-
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
 21 files changed, 584 insertions(+), 69 deletions(-)
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/gk20a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/ctxgk20a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/gk20a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/gk20a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/ibus/gk20a.c

-- 
1.9.2


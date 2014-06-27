Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbaF0LWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:22:42 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16406 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaF0LWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:22:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 27 Jun 2014 04:16:26 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v3 0/2] drm: nouveau: memory coherency for ARM
Date: Fri, 27 Jun 2014 20:22:12 +0900
Message-ID: <1403868134-31741-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2 was doing some pretty nasty things with the DMA API, so I took a different
approach for this v3.

As suggested, this version uses ttm_dma_populate() to populate BOs. The reason
for doing this was that it would entitle us to using the DMA sync functions,
but since the memory returned is already coherent anyway, we do not even
need to call these functions anymore.

So this series has turned into 2 small patches:

- The first attempts to make it more obvious that Nouveau can use different
ways to populate TTs, and make it possible to choose which method to use from
a single place.
- The second leverages this work to select the DMA allocator to populate TTs
on ARM.

Doing this solves all our coherency problems with Nouveau on Tegra, and
hopefully makes the code easier to read in the process.

Alexandre Courbot (2):
  drm/nouveau: cleanup TTM population logic
  drm/nouveau: use DMA TT population method on ARM

 drivers/gpu/drm/nouveau/nouveau_bo.c  | 63 ++++++++++++++++++-----------------
 drivers/gpu/drm/nouveau/nouveau_drm.h | 11 ++++++
 drivers/gpu/drm/nouveau/nouveau_ttm.c | 17 ++++++++++
 3 files changed, 61 insertions(+), 30 deletions(-)

-- 
2.0.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808Ab3CZNOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:14:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:46757 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352Ab3CZNOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:14:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,911,1355126400"; 
   d="scan'208";a="307579970"
From: Imre Deak <imre.deak@intel.com>
To: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 0/2] lib/scatterlist: sg_page_iter: support for memory w/o backing pages
Date: Tue, 26 Mar 2013 15:14:17 +0200
Message-Id: <1364303659-1951-1-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When adding sg_page_iter I haven't thought properly through the use case
for sg lists w/o backing pages - which is specific to the i915 driver -
so this patchset adds support for this.

It applies on the i915 tree [1], where the iterator is in use already.

[1] git://people.freedesktop.org/~danvet/drm-intel [nightly branch]

Imre Deak (2):
  lib/scatterlist: sg_page_iter: support sg lists w/o backing pages
  Revert "drm/i915: set dummy page for stolen objects"

 drivers/gpu/drm/drm_cache.c            |    2 +-
 drivers/gpu/drm/i915/i915_drv.h        |    2 +-
 drivers/gpu/drm/i915/i915_gem.c        |    8 ++++----
 drivers/gpu/drm/i915/i915_gem_dmabuf.c |    2 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c    |    6 ++----
 drivers/gpu/drm/i915/i915_gem_stolen.c |    4 ++--
 drivers/gpu/drm/i915/i915_gem_tiling.c |    4 ++--
 include/linux/scatterlist.h            |   28 +++++++++++++++++++++++-----
 lib/scatterlist.c                      |    4 +---
 9 files changed, 37 insertions(+), 23 deletions(-)

-- 
1.7.10.4


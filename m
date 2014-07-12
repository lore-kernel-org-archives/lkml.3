Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaGLHA1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 03:00:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39406 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752037AbaGLHAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 03:00:19 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Rob Clark <robdclark@gmail.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 0/2] drm: rework flip-work framework
Date: Sat, 12 Jul 2014 09:00:07 +0200
Message-Id: <1405148409-18171-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series reworks the flip-work framework to make it safe when
calling drm_flip_work_queue from atomic contexts.

The 2nd patch of this series is optional, as it only reworks
drm_flip_work_init prototype to remove unneeded size argument and
return code (this function cannot fail anymore).

Best Regards,

Boris


Boris BREZILLON (2):
  drm: rework flip-work helpers to avoid calling func when the FIFO is
    full
  drm: flip-work: change drm_flip_work_init prototype

 drivers/gpu/drm/drm_flip_work.c          | 104 ++++++++++++++++++++++---------
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_crtc.c |  19 ++----
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c |  16 +----
 drivers/gpu/drm/omapdrm/omap_plane.c     |  14 +----
 drivers/gpu/drm/tilcdc/tilcdc_crtc.c     |   6 +-
 include/drm/drm_flip_work.h              |  31 ++++++---
 6 files changed, 105 insertions(+), 85 deletions(-)

-- 
1.8.3.2


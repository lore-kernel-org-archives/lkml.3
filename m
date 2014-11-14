Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965796AbaKNSai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:30:38 -0500
Received: from down.free-electrons.com ([37.187.137.238]:37847 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965734AbaKNSag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:30:36 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Rob Clark <robdclark@gmail.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 RESEND 0/2] drm: rework flip-work framework
Date: Fri, 14 Nov 2014 19:30:28 +0100
Message-Id: <1415989830-17691-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dave,

I'm resending this series because I haven't had any news despite for a
while.

This patch series reworks the flip-work framework to make it safe when
calling drm_flip_work_queue from atomic contexts.

The 2nd patch of this series is optional, as it only reworks
drm_flip_work_init prototype to remove unneeded size argument and
return code (this function cannot fail anymore).

Best Regards,

Boris

Changes since v2:
- add missing spin_lock_init
- fix flip utils description

Changes since v1:
- add gfp flags argument to drm_flip_work_allocate_task function
- make drm_flip_work_queue safe when called from atomic context


Boris Brezillon (2):
  drm: rework flip-work helpers to avoid calling func when the FIFO is
    full
  drm: flip-work: change drm_flip_work_init prototype

 drivers/gpu/drm/drm_flip_work.c          | 105 ++++++++++++++++++++++---------
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_crtc.c |  19 ++----
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_crtc.c |  16 +----
 drivers/gpu/drm/omapdrm/omap_plane.c     |  14 +----
 drivers/gpu/drm/tilcdc/tilcdc_crtc.c     |   6 +-
 include/drm/drm_flip_work.h              |  33 +++++++---
 6 files changed, 108 insertions(+), 85 deletions(-)

-- 
1.9.1


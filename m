Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577Ab3FMJyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 05:54:23 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8122 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758477Ab3FMJyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 05:54:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 13 Jun 2013 02:54:21 -0700
From: Mayuresh Kulkarni <mkulkarni@nvidia.com>
To: <tbergstrom@nvidia.com>, <amerilainen@nvidia.com>,
        <thierry.reding@avionic-design.de>, <airlied@redhat.com>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Mayuresh Kulkarni <mkulkarni@nvidia.com>
Subject: [PATCH v2 0/4] gpu: host1x: add runtime pm support
Date: Thu, 13 Jun 2013 15:23:34 +0530
Message-ID: <1371117218-2326-1-git-send-email-mkulkarni@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set series adds runtime pm support for host1x,
gr2d & dc. It retains the current behaviour if CONFIG_PM_RUNTIME
is not enabled.

For host1x & gr2d, the clocks are now enabled in .probe
and disabled on its exit. This is needed for correct
init of hardware.

Additionally for gr2d, the clocks are also enabled when
a new work is submitted and disabled when the work is done.
Due to parent->child relations between host1x->gr2d,
this scheme also ends up in enabling & disabling host1x clock

For dc, the clocks are enabled in .probe and disabled in
.remove but via runtime pm instead of direct clock APIs.

Mayuresh Kulkarni (4):
  gpu: host1x: shuffle job APIs
  gpu: host1x: add runtime pm support for gr2d
  gpu: host1x: add runtime pm support for dc
  gpu: host1x: add runtime pm support for host1x

 drivers/gpu/host1x/cdma.c     |  2 ++
 drivers/gpu/host1x/channel.c  |  8 ------
 drivers/gpu/host1x/channel.h  |  1 -
 drivers/gpu/host1x/dev.c      | 57 ++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/host1x/drm/dc.c   | 60 +++++++++++++++++++++++++++++++++++++++----
 drivers/gpu/host1x/drm/gr2d.c | 56 +++++++++++++++++++++++++++++++++++++++-
 drivers/gpu/host1x/job.c      | 21 +++++++++++++++
 drivers/gpu/host1x/job.h      |  3 +++
 8 files changed, 193 insertions(+), 15 deletions(-)

-- 
1.8.1.5


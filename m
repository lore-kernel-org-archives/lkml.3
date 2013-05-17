Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab3EQLwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:52:17 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18178 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab3EQLwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:52:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 17 May 2013 04:52:15 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <thierry.reding@avionic-design.de>, <airlied@linux.ie>,
        <linux-tegra@vger.kernel.org>
CC: <tbergstrom@nvidia.com>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: [PATCH 0/6] Miscellaneous fixes to host1x
Date: Fri, 17 May 2013 14:49:42 +0300
Message-ID: <1368791388-31441-1-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes two issues in the host1x driver: First, the
command buffer validation routine had vulnerabilities that were not
detected in earlier testing. Second, the return codes of some
functions were misleading or completely missing. This caused the
driver to give wrong return codes also to the userspace.

The series is based on top of 3.10rc1. I have tested the patch series
on cardhu by running host1x and gr2d test cases (available at [0]).
I would appreciate any help in testing/reviewing these patches.

[0] https://gitorious.org/linux-host1x/libdrm-host1x

Arto Merilainen (5):
  gpu: host1x: Fix syncpoint wait return value
  gpu: host1x: Fix memory access in syncpt request
  gpu: host1x: Fix client_managed type
  gpu: host1x: Rework CPU syncpoint increment
  drm/tegra: Fix syncpoint increment return code

Terje Bergstrom (1):
  gpu: host1x: Fixes to host1x firewall

 drivers/gpu/host1x/dev.h          |    8 +--
 drivers/gpu/host1x/drm/drm.c      |    3 +-
 drivers/gpu/host1x/drm/gr2d.c     |    2 +-
 drivers/gpu/host1x/hw/cdma_hw.c   |    2 +-
 drivers/gpu/host1x/hw/syncpt_hw.c |   12 ++--
 drivers/gpu/host1x/job.c          |  120 ++++++++++++++++---------------------
 drivers/gpu/host1x/syncpt.c       |   29 +++------
 drivers/gpu/host1x/syncpt.h       |   13 ++--
 8 files changed, 79 insertions(+), 110 deletions(-)

-- 
1.7.9.5


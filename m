Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab3JIL6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 07:58:49 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10259 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab3JIL6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 07:58:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 09 Oct 2013 04:58:45 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <tbergstrom@nvidia.com>, <thierry.reding@gmail.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>
Subject: [PATCH 0/3] gpu: host1x: Add syncpoint base support
Date: Wed, 9 Oct 2013 14:54:07 +0300
Message-ID: <1381319650-9799-1-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The host1x driver uses currently syncpoints statically from host1x point of
view. If we do a wait inside a job, it always has a constant value to wait.
host1x supports also doing relative syncpoint waits with respect to syncpoint
bases. This allows doing multiple operations inside a single submit and
waiting an operation to complete before moving to next one.

This set of patches adds support for syncpoint bases to host1x driver and
enables the support for gr2d client. The series is based on 3.12-rc4.

I have tested the series using the host1x test application (available at [0],
function test_wait_base() in tests/tegra/host1x/tegra_host1x_test.c) on cardhu.
I would appreciate help in reviewing the series and testing the patches
on other boards.

[0] https://gitorious.org/linux-host1x/libdrm-host1x

Arto Merilainen (3):
  gpu: host1x: Add syncpoint base support
  drm/tegra: Deliver syncpoint base to user space
  drm/tegra: Reserve base for gr2d

 drivers/gpu/host1x/dev.h                   |  2 ++
 drivers/gpu/host1x/drm/drm.c               |  2 ++
 drivers/gpu/host1x/drm/gr2d.c              |  2 +-
 drivers/gpu/host1x/hw/channel_hw.c         | 19 +++++++++++
 drivers/gpu/host1x/hw/hw_host1x01_uclass.h |  6 ++++
 drivers/gpu/host1x/syncpt.c                | 55 +++++++++++++++++++++++++++---
 drivers/gpu/host1x/syncpt.h                | 10 ++++++
 include/uapi/drm/tegra_drm.h               |  4 ++-
 8 files changed, 93 insertions(+), 7 deletions(-)

-- 
1.8.1.5


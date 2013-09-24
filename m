Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab3IXMNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:13:36 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15347 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3IXMJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:09:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 24 Sep 2013 05:05:46 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <tbergstrom@nvidia.com>, <treding@nvidia.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>,
        <mkulkarni@nvidia.com>
Subject: [PATCHv3 0/4] gpu: host1x: Add runtime pm support
Date: Tue, 24 Sep 2013 15:05:21 +0300
Message-ID: <1380024325-18280-1-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds runtime pm support for host1x, gr2d and dc. It retains the
current behaviour if CONFIG_PM_RUNTIME is not enabled.

The gr2d clock is enabled when a new job is submitted and disabled when
the work is done. Due to parent->child relations between host1x->gr2d, this
scheme enables and disables host1x clock.

For dc, the clocks are enabled in .probe and disabled in .remove via runtime
pm instead of direct clock APIs.

Mayuresh is unfortunately not available to continue with the series and hence
I will continue working on the patches.

Changes in v3:
- Rebased patches on top of 3.12-rc2
- Removed unnecessary #ifdefs
- Added descriptions to commit messages
- If runtime pm is disabled, the code calls suspend/resume functions
for enabling/disabling the clocks instead of repeating the functions

Mayuresh Kulkarni (4):
  gpu: host1x: shuffle job APIs
  drm/tegra: Add runtime pm support for gr2d
  drm/tegra: Add runtime pm support for dc
  gpu: host1x: Add runtime pm support for host1x

 drivers/gpu/host1x/cdma.c     |  2 ++
 drivers/gpu/host1x/channel.c  |  8 ------
 drivers/gpu/host1x/channel.h  |  1 -
 drivers/gpu/host1x/dev.c      | 57 +++++++++++++++++++++++++++++++++++++++---
 drivers/gpu/host1x/drm/dc.c   | 58 +++++++++++++++++++++++++++++++++++++++----
 drivers/gpu/host1x/drm/gr2d.c | 57 ++++++++++++++++++++++++++++++++++++++----
 drivers/gpu/host1x/job.c      | 13 ++++++++++
 drivers/gpu/host1x/job.h      |  3 +++
 8 files changed, 176 insertions(+), 23 deletions(-)

-- 
1.8.1.5


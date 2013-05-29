Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965563Ab3E2K1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 06:27:48 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12057 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965412Ab3E2K1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 06:27:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 29 May 2013 03:27:33 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <thierry.reding@gmail.com>, <airlied@linux.ie>,
        <linux-tegra@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
CC: <tbergstrom@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: [PATCHv2 0/7] Miscellaneous fixes to host1x
Date: Wed, 29 May 2013 13:26:01 +0300
Message-ID: <1369823168-5396-1-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
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

The series is based on top of 3.10rc3. I have tested the patch series
on cardhu by running host1x and gr2d test cases (available at [0]).
I would appreciate any help in testing/reviewing these patches.

Changes from v1:
 * Rebased on top of 3.10rc3
 * Split firewall fixes to smaller patches
 * Reworked no-reloc case in firewall code. Fix in v1 was not
   sufficient in all cases
 * Dropped patch "Fix syncpoint wait return value" as it is not
   critical and discussion on it has not yet settled.
 * Fixed style and whitespace issues

[0] https://gitorious.org/linux-host1x/libdrm-host1x

Arto Merilainen (5):
  gpu: host1x: Check reloc table before usage
  gpu: host1x: Copy gathers before verification
  gpu: host1x: Fix memory access in syncpt request
  gpu: host1x: Fix client_managed type
  gpu: host1x: Rework CPU syncpoint increment

Terje Bergstrom (2):
  gpu: host1x: Check INCR opcode correctly
  gpu: host1x: Don't reset firewall between gathers

 drivers/gpu/host1x/dev.h          |   8 +--
 drivers/gpu/host1x/drm/drm.c      |   3 +-
 drivers/gpu/host1x/drm/gr2d.c     |   2 +-
 drivers/gpu/host1x/hw/cdma_hw.c   |   2 +-
 drivers/gpu/host1x/hw/syncpt_hw.c |  12 ++--
 drivers/gpu/host1x/job.c          | 135 +++++++++++++++++---------------------
 drivers/gpu/host1x/syncpt.c       |  26 +++-----
 drivers/gpu/host1x/syncpt.h       |  13 ++--
 8 files changed, 85 insertions(+), 116 deletions(-)

-- 
1.8.1.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab3FTXId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 19:08:33 -0400
Received: from gir.skynet.ie ([193.1.99.77]:46687 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757878Ab3FTXIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 19:08:32 -0400
Date: Fri, 21 Jun 2013 00:08:37 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm radeon fixes
Message-ID: <alpine.DEB.2.00.1306210007001.14351@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

one core fix, but mostly radeon fixes for s/r and big endian UVD support,
and a fix to stop the GPU being reset for no good reason, and crashing 
people's machines.

Dave.

The following changes since commit df63d3ecbca514bad99513b2401448d19a9bb92e:

  Merge tag 'drm-intel-fixes-2013-06-11' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes (2013-06-11 19:38:27 +1000)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 9aa36876ddeb85dfb0bcf37be06bbdc62e954f16:

  Merge branch 'drm-fixes-3.10' of git://people.freedesktop.org/~agd5f/linux into drm-fixes (2013-06-21 08:52:19 +1000)

----------------------------------------------------------------

Alex Deucher (1):
      drm/radeon: fix UVD on big endian

Dave Airlie (2):
      Merge branch 'drm-fixes-3.10' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge branch 'drm-fixes-3.10' of git://people.freedesktop.org/~agd5f/linux into drm-fixes

Jerome Glisse (3):
      drm/radeon: do not try to uselessly update virtual memory pagetable
      drm/radeon: fix write back suspend regression with uvd v2
      drm/radeon: update lockup tracking when scheduling in empty ring

Laurent Pinchart (1):
      drm/prime: Honor requested file flags when exporting a buffer

 drivers/gpu/drm/drm_prime.c            |  3 +-
 drivers/gpu/drm/radeon/r600.c          | 13 +++++++--
 drivers/gpu/drm/radeon/radeon_device.c | 53 +++++++++++++++-------------------
 drivers/gpu/drm/radeon/radeon_fence.c  | 10 +++++--
 drivers/gpu/drm/radeon/radeon_gart.c   |  6 ++--
 drivers/gpu/drm/radeon/radeon_ring.c   |  7 +++++
 drivers/gpu/drm/radeon/radeon_uvd.c    | 48 +++++++++++++++++++-----------
 7 files changed, 85 insertions(+), 55 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab3BCXkO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 18:40:14 -0500
Received: from gir.skynet.ie ([193.1.99.77]:45862 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab3BCXkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 18:40:12 -0500
Date: Sun, 3 Feb 2013 23:40:00 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm radeon fixes
Message-ID: <alpine.DEB.2.00.1302032336360.12371@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

I got these late last week, the main chunks of these fix a rendering 
regression since 3.7, and the settle ones all fix the issue where we don't 
wait long enough for the memory controller to settle after turning it off 
which causes bad memory reads, they all fix real users bugs, and most of 
them are destined for stable.

can't remember if you had net connection on that island :-)

Dave.

The following changes since commit ff0d05bf73620eb7dc8aee7423e992ef87870bdf:

  Revert "console: implement lockdep support for console_lock" (2013-01-31 15:46:56 +1100)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux.git drm-fixes

for you to fetch changes up to 089c71a7c306dff067097f37ef329ccdf3269811:

  Merge branch 'drm-fixes-3.8' of git://people.freedesktop.org/~agd5f/linux (2013-02-01 10:51:02 +1100)

----------------------------------------------------------------

Alex Deucher (7):
      drm/radeon: add WAIT_UNTIL to the non-VM safe regs list for cayman/TN
      drm/radeon: add quirk for RV100 board
      drm/radeon: fix backend map setup on 1 RB sumo boards
      drm/radeon/evergreen+: wait for the MC to settle after MC blackout
      drm/radeon/r5xx-r7xx: wait for the MC to settle after MC blackout
      drm/radeon: prevent crash in the ring space allocation
      drm/radeon: switch back to the CP ring for VM PT updates

Christopher Staite (1):
      drm/radeon: fix MC blackout on evergreen+

Dave Airlie (1):
      Merge branch 'drm-fixes-3.8' of git://people.freedesktop.org/~agd5f/linux

Mikko Tiihonen (1):
      drm/radeon: protect against div by 0 in backend setup

liu chuansheng (1):
      drm/radeon: Calling object_unrefer() when creating fb failure

 drivers/gpu/drm/radeon/evergreen.c      | 27 ++++++++++++++++++++++++---
 drivers/gpu/drm/radeon/r600.c           |  7 +++++--
 drivers/gpu/drm/radeon/radeon_asic.c    |  6 +++---
 drivers/gpu/drm/radeon/radeon_combios.c |  8 ++++++++
 drivers/gpu/drm/radeon/radeon_display.c |  4 +++-
 drivers/gpu/drm/radeon/radeon_ring.c    |  3 +++
 drivers/gpu/drm/radeon/reg_srcs/cayman  |  1 +
 drivers/gpu/drm/radeon/rv515.c          |  2 ++
 8 files changed, 49 insertions(+), 9 deletions(-)

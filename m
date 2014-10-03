Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaJCFVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 01:21:49 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44899 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbaJCFVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 01:21:48 -0400
Date: Fri, 3 Oct 2014 06:21:44 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm i915 and nouveau fixes
Message-ID: <alpine.DEB.2.00.1410030619490.14293@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Nothing too major or scary,

one i915 regression fix, nouveau has a tmds regression fix, along with a 
regression fix for the runtime pm code for optimus laptops not restoring 
the display hw correctly.

Dave.

The following changes since commit fe82dcec644244676d55a1384c958d5f67979adb:

  Linux 3.17-rc7 (2014-09-28 14:29:07 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to eee0815dabbdd7d584bea8275f5758d25c97cb9b:

  Merge tag 'drm-intel-fixes-2014-10-02' of git://anongit.freedesktop.org/drm-intel into drm-fixes (2014-10-03 11:38:16 +1000)

----------------------------------------------------------------

Ben Skeggs (4):
      drm/nv50/disp: fix dpms regression on certain boards
      drm/nouveau: fix regression on original nv50 board
      drm/nouveau: punt fbcon resume out to a workqueue
      drm/nouveau: make sure display hardware is reinitialised on runtime resume

Chris Wilson (1):
      drm/i915: Flush the PTEs after updating them before suspend

Dave Airlie (2):
      Merge branch 'linux-3.17' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes
      Merge tag 'drm-intel-fixes-2014-10-02' of git://anongit.freedesktop.org/drm-intel into drm-fixes

 drivers/gpu/drm/i915/i915_gem_gtt.c             | 14 ++++++-
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c |  3 +-
 drivers/gpu/drm/nouveau/nouveau_chan.c          |  7 +++-
 drivers/gpu/drm/nouveau/nouveau_display.c       | 23 ++++++-----
 drivers/gpu/drm/nouveau/nouveau_display.h       |  5 +--
 drivers/gpu/drm/nouveau/nouveau_drm.c           | 51 +++++++------------------
 drivers/gpu/drm/nouveau/nouveau_fbcon.c         | 23 ++++++++---
 drivers/gpu/drm/nouveau/nouveau_fbcon.h         |  1 +
 8 files changed, 65 insertions(+), 62 deletions(-)

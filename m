Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762480Ab3DBU7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 16:59:00 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47973 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762466Ab3DBU67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 16:58:59 -0400
Date: Tue, 2 Apr 2013 21:58:57 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1304022157560.11547@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

two core fixes, both regressions, along with some intel and some nouveau 
fixes for regressions and oopses.

Dave.

The following changes since commit 2dc958fa2fe6987e7ab106bd97029a09a82fcd8d:

  ipc: set msg back to -EAGAIN if copy wasn't performed (2013-04-02 10:09:01 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to a8ec3a662921220fc058ed6f7f3674697876d218:

  drm: correctly restore mappings if drm_open fails (2013-04-03 06:44:38 +1000)

----------------------------------------------------------------
Adam Jackson (1):
      drm/i915: Be sure to turn hsync/vsync back on at crt enable (v2)

Daniel Vetter (2):
      drm/i915: duct-tape locking when eDP init fails
      drm: don't unlock in the addfb error paths

Dave Airlie (2):
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-next
      Merge branch 'drm-nouveau-fixes-3.9' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next

Ilija Hadzic (1):
      drm: correctly restore mappings if drm_open fails

Lauri Kasanen (1):
      drm/i915: Fix build failure

Maarten Lankhorst (2):
      drm/nouveau: fix handling empty channel list in ioctl's
      drm/nouveau: fix NULL ptr dereference from nv50_disp_intr()

 drivers/gpu/drm/drm_crtc.c                 |  2 --
 drivers/gpu/drm/drm_fops.c                 |  6 +++--
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |  2 +-
 drivers/gpu/drm/i915/intel_crt.c           | 40 +++++++++++++-----------------
 drivers/gpu/drm/i915/intel_dp.c            |  3 +++
 drivers/gpu/drm/nouveau/nouveau_abi16.c    | 18 ++++++++------
 drivers/gpu/drm/nouveau/nouveau_drm.c      | 32 +++++++++++++++---------
 drivers/gpu/drm/nouveau/nouveau_drm.h      |  2 +-
 8 files changed, 56 insertions(+), 49 deletions(-)
